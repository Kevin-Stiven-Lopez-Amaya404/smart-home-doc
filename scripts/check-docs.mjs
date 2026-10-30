import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const errors = [];
const stats = { markdown: 0, relativeLinks: 0, anchors: 0, externalLinks: 0, jsonExamples: 0, mermaidBlocks: 0, directories: 0 };
const skip = new Set(['.git', 'node_modules', '.codegraph']);
function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
    if (skip.has(entry.name)) return [];
    const full = path.join(dir, entry.name);
    return entry.isDirectory() ? walk(full) : [full];
  });
}
const files = walk(root);
const mdFiles = files.filter(file => file.endsWith('.md'));
const sources = JSON.parse(fs.readFileSync(path.join(root, 'scripts/source-references.json'), 'utf8'));
const verified = new Map(sources.references.map(item => [item.url.split('#')[0], item]));
const texts = new Map();
const anchors = new Map();
const canonical = new Map();
const rel = file => path.relative(root, file).split(path.sep).join('/');
const issue = (file, message) => errors.push(rel(file) + ': ' + message);
const allowed = new Set(['README.md', 'CONTRIBUTING.md', 'DOCUMENTATION_POLICY.md']);
const expected = {
  '00-contexto': ['vision-del-sistema', 'alcance-y-no-objetivos', 'mapa-de-repositorios', 'glosario'],
  '10-arquitectura': ['arquitectura-general', 'backend', 'persistencia-y-datos', 'frontend-web', 'aplicacion-movil', 'comunicaciones-mqtt-realtime'],
  '20-contratos': ['eventos-realtime', 'errores-api', 'api-rest/README', 'mqtt/README', 'mqtt/contrato-mqtt'],
  '30-desarrollo': ['inicio-local', 'configuracion-entorno', 'estrategia-de-pruebas', 'flujo-git-pull-requests'],
  '40-operacion': ['despliegue', 'variables-de-entorno', 'monitoreo-y-salud', 'copias-de-seguridad', 'solucion-de-problemas'],
  '50-decisiones': ['plantilla-adr'],
  '60-producto-procesos': ['roles-y-permisos', 'flujos-de-usuario', 'proceso-de-liberacion'],
  '99-archivo': []
};
for (const name of ['README.md', 'CONTRIBUTING.md', 'DOCUMENTATION_POLICY.md', 'docs/README.md']) {
  if (!fs.existsSync(path.join(root, name))) errors.push('Missing required file: ' + name);
}
for (const [dir, names] of Object.entries(expected)) {
  for (const name of ['README', ...names]) {
    const target = path.join(root, 'docs', dir, name + '.md');
    if (!fs.existsSync(target)) errors.push('Missing required file: ' + rel(target));
  }
}
for (const dir of new Set(files.map(file => path.dirname(file)))) {
  if (dir === root || dir.startsWith(path.join(root, 'docs')) || dir === path.join(root, 'scripts')) {
    stats.directories++;
    if (!fs.existsSync(path.join(dir, 'README.md'))) issue(dir, 'directory has no README.md');
  }
}
for (const file of mdFiles) {
  const text = fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n');
  stats.markdown++;
  if (!allowed.has(path.basename(file)) && !/^[a-z0-9]+(?:-[a-z0-9]+)*\.md$/.test(path.basename(file))) issue(file, 'invalid Markdown filename');
  const front = /^---\n([\s\S]*?)\n---\n/.exec(text);
  if (!front) issue(file, 'missing YAML front matter');
  const meta = front?.[1] ?? '';
  for (const key of ['title', 'status', 'owner', 'last_reviewed']) {
    if (!new RegExp('^' + key + ':\\s*\\S.+$', 'm').test(meta)) issue(file, 'missing metadata: ' + key);
  }
  if (!/^status: (borrador|vigente|obsoleto)$/m.test(meta)) issue(file, 'invalid status');
  const date = /^last_reviewed: (\d{4}-\d{2}-\d{2})$/m.exec(meta)?.[1];
  if (!date || Number.isNaN(Date.parse(date)) || new Date(date).toISOString().slice(0, 10) !== date) issue(file, 'invalid last_reviewed date');
  const keys = /^canonical_for:\s*\n((?:[ \t]+-[^\n]*\n?)+)/m.exec(meta)?.[1].match(/(?<=- )\S+/g) ?? [];
  if (!keys.length) issue(file, 'missing canonical_for list');
  for (const key of keys) {
    if (canonical.has(key)) issue(file, 'duplicate canonical_for ' + key + ' also in ' + canonical.get(key));
    canonical.set(key, rel(file));
  }
  let fenced = null;
  let buffer = [];
  const visible = [];
  let tableWidth = null;
  for (const [lineNo, line] of text.slice(front?.[0].length ?? 0).split('\n').entries()) {
    const fence = /^\s*(\x60{3,}|~{3,})(.*)$/.exec(line);
    if (fence) {
      if (!fenced) {
        fenced = { marker: fence[1][0], width: fence[1].length, lang: fence[2].trim().toLowerCase() };
        buffer = [];
      } else if (fence[1][0] === fenced.marker && fence[1].length >= fenced.width && !fence[2].trim()) {
        if (fenced.lang === 'json') {
          stats.jsonExamples++;
          try { JSON.parse(buffer.join('\n')); } catch (error) { issue(file, 'invalid JSON example near body line ' + lineNo + ': ' + error.message); }
        }
        if (fenced.lang === 'mermaid') stats.mermaidBlocks++;
        fenced = null;
      }
      tableWidth = null;
      continue;
    }
    if (fenced) { buffer.push(line); continue; }
    visible.push(line);
    if (/^\s*\|.*\|\s*$/.test(line)) {
      const count = line.replace(/\\\|/g, '').split('|').length - 2;
      if (tableWidth !== null && tableWidth !== count) issue(file, 'inconsistent table near body line ' + (lineNo + 1));
      tableWidth = count;
    } else tableWidth = null;
  }
  if (fenced) issue(file, 'unclosed code fence');
  const body = visible.join('\n');
  if ((body.match(/^# [^\n]+$/gm) ?? []).length !== 1) issue(file, 'expected exactly one H1');
  if (/^status: vigente$/m.test(meta) && !/fuente|referencia|evidencia/i.test(body)) issue(file, 'vigente document has no source indication');
  if (/[ \t]+$/m.test(text)) issue(file, 'trailing whitespace');
  if (/-----BEGIN [A-Z ]*PRIVATE KEY-----/.test(text)) issue(file, 'private key marker');
  if (/^(?:JWT_SECRET|SMTP_APP_PASSWORD|MQTT_PASSWORD|DATABASE_URL)\s*=\s*\S+/m.test(body)) issue(file, 'secret assignment outside a code example');
  const ids = new Set([...body.matchAll(/<a\s+(?:id|name)=["']([^"']+)["'][^>]*>/g)].map(match => match[1]));
  const slugs = new Map();
  for (const match of body.matchAll(/^#{1,6} (.+?)\s*#*$/gm)) {
    const slug = match[1].toLowerCase().replace(/<[^>]+>/g, '').replace(/[^\p{L}\p{N}_\s-]/gu, '').replace(/\s/g, '-');
    const n = slugs.get(slug) ?? 0;
    ids.add(n ? slug + '-' + n : slug);
    slugs.set(slug, n + 1);
  }
  anchors.set(file, ids);
  texts.set(file, body);
}
for (const [file, body] of texts) {
  for (const match of body.matchAll(/!?\[[^\]\n]*\]\((?:<([^>\n]+)>|([^\s)\n]+))(?:\s+"[^"]*")?\)/g)) {
    const target = match[1] ?? match[2];
    if (/^https?:\/\//i.test(target)) {
      stats.externalLinks++;
      if (!verified.has(target.split('#')[0])) issue(file, 'external reference not verified: ' + target);
      continue;
    }
    if (/^(mailto:|tel:)/i.test(target)) continue;
    if (/^[a-z]+:/i.test(target)) { issue(file, 'unsupported link scheme: ' + target); continue; }
    stats.relativeLinks++;
    const [name, fragment] = target.split('#');
    let dest;
    try { dest = name ? path.resolve(path.dirname(file), decodeURIComponent(name)) : file; }
    catch { issue(file, 'invalid relative link encoding: ' + target); continue; }
    if (dest !== root && !dest.startsWith(root + path.sep)) { issue(file, 'link leaves repository: ' + target); continue; }
    if (!fs.existsSync(dest)) { issue(file, 'missing target: ' + target); continue; }
    if (fragment) {
      stats.anchors++;
      if (!anchors.get(dest)?.has(decodeURIComponent(fragment))) issue(file, 'unknown anchor: ' + target);
    }
  }
}
console.log(JSON.stringify({ ok: !errors.length, ...stats, canonicalKeys: canonical.size, verifiedExternalReferences: verified.size, errors }, null, 2));
if (errors.length) process.exitCode = 1;
