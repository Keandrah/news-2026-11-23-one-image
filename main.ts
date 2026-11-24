import { copyFileSync, existsSync, mkdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const source = join(here, 'entry.png');
const outputDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

if (!existsSync(source)) {
  throw new Error('entry.png is missing from the repository root');
}

const bytes = statSync(source).size;
if (bytes > 1024 * 1024) {
  throw new Error('entry.png is larger than the 1 MiB gate limit');
}

const header = readFileSync(source).subarray(0, 8);
if (header[0] !== 0x89 || header.toString('ascii', 1, 4) !== 'PNG') {
  throw new Error('entry.png is not a valid PNG file');
}

mkdirSync(outputDir, { recursive: true });
copyFileSync(source, join(outputDir, 'entry.png'));
console.log(`Wrote entry.png (${bytes} bytes) to ${outputDir}`);
