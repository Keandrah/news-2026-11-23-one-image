import { copyFileSync, existsSync, mkdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

// Resolve directory paths
const currentDir = dirname(fileURLToPath(import.meta.url));
const imagePath = join(currentDir, 'entry.png');
const destinationDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

// Verify source image existence
if (!existsSync(imagePath)) {
  throw new Error('entry.png not found at root');
}

// Check size constraints
const fileSize = statSync(imagePath).size;
if (fileSize > 1024 * 1024) {
  throw new Error('entry.png exceeds 1 MiB limit');
}

// Validate PNG signature bytes
const magic = readFileSync(imagePath).subarray(0, 8);
if (magic[0] !== 0x89 || magic.toString('ascii', 1, 4) !== 'PNG') {
  throw new Error('entry.png is not a valid PNG image format');
}

mkdirSync(destinationDir, { recursive: true });
copyFileSync(imagePath, join(destinationDir, 'entry.png'));
console.log(`Successfully exported entry.png (${fileSize} bytes) to ${destinationDir}`);
