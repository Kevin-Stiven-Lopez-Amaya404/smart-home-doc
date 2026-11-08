#!/usr/bin/env bash
# End-to-end smoke test of the SmartHome stack started with docker-compose.yml.
# It talks to the API through the web container (same path as the browser),
# signs in with every demo role and exercises the main flows.
#
#   ./smoke-test.sh                      # defaults to http://localhost:8080
#   BASE_URL=http://host:8080 MAILPIT_URL=http://host:8025 ./smoke-test.sh
#
# Requires bash, curl and python3. Exit code 0 means every check passed.
set -uo pipefail

BASE_URL="${BASE_URL:-http://localhost:8080}"
API="$BASE_URL/api/v1"
MAILPIT_URL="${MAILPIT_URL:-http://localhost:8025}"
PASSWORD='SmartHome#2026'
HOME_ID='d1000000-0000-4000-8000-000000000001'
DEVICE_ID='d3000000-0000-4000-8000-000000000001'
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

passed=0
failed=0
STATUS=''
BODY=''

# request METHOD PATH [TOKEN] [JSON] -> sets STATUS and BODY
request() {
  local method=$1 path=$2 token=${3:-} data=${4:-}
  local args=(-s -o "$WORK/body" -w '%{http_code}' -X "$method" -c "$WORK/cookies" -b "$WORK/cookies")
  [ -n "$token" ] && args+=(-H "Authorization: Bearer $token")
  [ -n "$data" ] && args+=(-H 'Content-Type: application/json' --data "$data")
  STATUS=$(curl "${args[@]}" "$API$path")
  BODY=$(cat "$WORK/body")
}

# json EXPRESSION -> evaluates a Python expression over the parsed BODY as `d`
json() {
  python3 -c "import json,sys; d=json.loads(sys.argv[1]); print($1)" "$BODY" 2>/dev/null
}

check() {
  local description=$1 expected=$2 actual=$3
  if [ "$expected" = "$actual" ]; then
    passed=$((passed + 1))
    printf '  ok    %s\n' "$description" >&2
  else
    failed=$((failed + 1))
    printf '  FAIL  %s (expected %s, got %s)\n' "$description" "$expected" "$actual" >&2
    printf '        %s\n' "${BODY:0:300}" >&2
  fi
}

login() {
  request POST /auth/login '' "{\"email\":\"$1\",\"password\":\"$PASSWORD\"}"
  check "login $1" 201 "$STATUS"
  json "d['accessToken']"
}

echo "SmartHome smoke test against $BASE_URL" >&2

echo "1. Web and API availability" >&2
check 'web serves the SPA' 200 "$(curl -s -o /dev/null -w '%{http_code}' "$BASE_URL/")"
check 'web serves deep links (/login)' 200 "$(curl -s -o /dev/null -w '%{http_code}' "$BASE_URL/login")"
check 'API health through the web proxy' 200 "$(curl -s -o /dev/null -w '%{http_code}' "$BASE_URL/health")"

echo "2. Sign in with every declared role" >&2
ADMIN=$(login admin@example.com)
OWNER=$(login owner@example.com)
MEMBER=$(login member@example.com)
GUEST=$(login guest@example.com)
request GET /auth/me "$ADMIN"
check 'admin token carries SYSTEM_ADMIN' SYSTEM_ADMIN "$(json "d['role']")"

echo "3. Stability and error handling" >&2
request POST /auth/login '' "{\"email\":\"owner@example.com\",\"password\":\"Wrong#2026x\"}"
check 'wrong password is 401' 401 "$STATUS"
request POST /auth/login '' '{"email":"not-an-email"}'
check 'malformed body is 400' 400 "$STATUS"
check '400 response has no stack trace' False "$(json "'stack' in json.dumps(d) or 'at ' in json.dumps(d)")"
request GET /homes
check 'missing token is 401' 401 "$STATUS"
request GET /homes 'invalid.token.value'
check 'invalid token is 401' 401 "$STATUS"
request GET /homes/not-a-uuid "$OWNER"
check 'invalid UUID is 400' 400 "$STATUS"
request GET /homes/00000000-0000-4000-8000-000000000000 "$OWNER"
check 'unknown home is 404' 404 "$STATUS"
request GET /notifications "$OWNER"
check 'empty notification list is 200' 200 "$STATUS"

echo "4. SYSTEM_ADMIN functions" >&2
request GET /admin/users "$ADMIN"
check 'admin lists users' 200 "$STATUS"
check 'admin sees the 4 demo users' True "$(json "len([u for u in d if u['email'].endswith('@example.com')]) >= 4")"
request GET /admin/audit-events "$ADMIN"
check 'admin reads the audit log' 200 "$STATUS"
request GET /admin/users "$OWNER"
check 'a regular user cannot reach admin routes' 403 "$STATUS"

echo "5. Homes and memberships (OWNER / MEMBER / GUEST)" >&2
request GET /homes "$OWNER"
check 'owner lists homes' 200 "$STATUS"
check 'owner sees Casa Demo' True "$(json "any(h['name']=='Casa Demo' for h in d)")"
request GET "/homes/$HOME_ID/members" "$OWNER"
check 'owner lists the 3 members' 3 "$(json "len(d)")"
request GET /homes "$GUEST"
check 'guest also sees the shared home' True "$(json "any(h['id']=='$HOME_ID' for h in d)")"

echo "6. Devices" >&2
request GET "/homes/$HOME_ID/devices" "$MEMBER"
check 'member lists devices' 200 "$STATUS"
check 'member sees the demo device' True "$(json "any(x['id']=='$DEVICE_ID' for x in d)")"
request POST "/homes/$HOME_ID/devices" "$OWNER" '{"name":"Ventilador smoke","transportType":"WIFI","messagingProtocol":"MQTT"}'
check 'owner creates a device' 201 "$STATUS"
NEW_DEVICE=$(json "d['id']")
request PATCH "/homes/$HOME_ID/devices/$NEW_DEVICE" "$OWNER" '{"name":"Ventilador renombrado"}'
check 'owner renames the device' 200 "$STATUS"
request GET "/homes/$HOME_ID/devices/$NEW_DEVICE" "$GUEST"
check 'the change is visible to the guest' 'Ventilador renombrado' "$(json "d['name']")"
request POST "/homes/$HOME_ID/devices" "$MEMBER" '{"name":"No permitido"}'
check 'member cannot create devices' 403 "$STATUS"
request PATCH "/homes/$HOME_ID/devices/$DEVICE_ID/control" "$OWNER" '{"command":"TURN_ON"}'
check 'controlling an offline device is 409' 409 "$STATUS"
request DELETE "/homes/$HOME_ID/devices/$NEW_DEVICE" "$OWNER"
check 'owner deletes the device' 200 "$STATUS"

echo "7. Consumption and energy permissions" >&2
# A different effective date on every run keeps the test repeatable
# (the API correctly rejects a second tariff with the same date).
TARIFF_DATE=$(python3 -c "import datetime,time; print(datetime.date(2025,1,1)+datetime.timedelta(days=int(time.time())%3000))")
request GET "/homes/$HOME_ID/consumption/summary" "$OWNER"
check 'owner reads the consumption summary' 200 "$STATUS"
request GET "/homes/$HOME_ID/consumption" "$GUEST"
check 'guest cannot read detailed consumption' 403 "$STATUS"
request POST "/homes/$HOME_ID/energy/tariffs" "$OWNER" '{"unitPriceCopKwh":"850.5","effectiveFrom":"'"$TARIFF_DATE"'"}'
check 'owner records a tariff' 201 "$STATUS"
request GET "/homes/$HOME_ID/energy/tariffs" "$MEMBER"
check 'member reads tariffs' 200 "$STATUS"
request GET "/homes/$HOME_ID/energy/tariffs" "$GUEST"
check 'guest cannot read tariffs' 403 "$STATUS"
request POST "/homes/$HOME_ID/energy/tariffs" "$MEMBER" '{"unitPriceCopKwh":"1","effectiveFrom":"2026-02-01"}'
check 'member cannot record tariffs' 403 "$STATUS"

echo "8. Registration, email activation and session refresh" >&2
EMAIL="smoke-$(date +%s)@example.com"
request POST /auth/register '' "{\"name\":\"Smoke Test\",\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"passwordConfirmation\":\"$PASSWORD\"}"
check 'a new user registers' 201 "$STATUS"
request POST /auth/login '' "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"
check 'a pending account cannot sign in' 403 "$STATUS"
TOKEN=''
for _ in 1 2 3 4 5 6 7 8 9 10; do
  MESSAGE_ID=$(curl -s "$MAILPIT_URL/api/v1/search?query=to:$EMAIL" | python3 -c "import json,sys; m=json.load(sys.stdin)['messages']; print(m[0]['ID'] if m else '')" 2>/dev/null)
  if [ -n "$MESSAGE_ID" ]; then
    TOKEN=$(curl -s "$MAILPIT_URL/api/v1/message/$MESSAGE_ID" | python3 -c "import json,sys,re,urllib.parse; t=json.load(sys.stdin)['Text']; print(urllib.parse.unquote(re.search(r'token=([^\s&]+)', t).group(1)))")
    break
  fi
  sleep 1
done
check 'the activation email arrives' true "$([ -n "$TOKEN" ] && echo true || echo false)"
request POST /auth/activate '' "{\"token\":\"$TOKEN\"}"
check 'the account is activated with the emailed token' 201 "$STATUS"
NEW_USER=$(login "$EMAIL")
request POST /homes "$NEW_USER" '{"name":"Hogar smoke"}'
check 'the new user creates a home' 201 "$STATUS"
request POST /auth/refresh
check 'the refresh cookie issues a new access token' 201 "$STATUS"
request POST /auth/logout
check 'logout succeeds' 200 "$STATUS"
request POST /auth/refresh
check 'refresh fails after logout' 401 "$STATUS"

echo "9. Brute-force protection" >&2
LIMITED=false
for _ in $(seq 1 12); do
  request POST /auth/login '' '{"email":"owner@example.com","password":"Wrong#2026x"}'
  if [ "$STATUS" = 429 ]; then LIMITED=true; break; fi
done
check 'repeated failed logins are rate limited (429)' true "$LIMITED"

echo
echo "Result: $passed passed, $failed failed" >&2
[ "$failed" -eq 0 ]
