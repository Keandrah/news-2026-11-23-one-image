import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath } from 'node:url';

// Discover execution context and target directories
const scriptFolder = path.dirname(fileURLToPath(import.meta.url));
const sourceArtifact = path.resolve(scriptFolder, 'entry.png');
const targetFolder = process.env.MAKEFUN_OUTPUT_DIR || '/output';

// Perform pre-flight integrity verification
if (!fs.existsSync(sourceArtifact)) {
  console.error(`Missing input asset: ${sourceArtifact}`);
  process.exit(1);
}

// Verify payload byte budget (maximum 1 megabyte)
const payloadStats = fs.statSync(sourceArtifact);
const payloadBytes = payloadStats.size;
const maxAllowedBytes = 1048576; // 1024 * 1024 bytes

if (payloadBytes > maxAllowedBytes) {
  console.error(`Payload size ${payloadBytes} exceeds limit of ${maxAllowedBytes} bytes`);
  process.exit(1);
}

// Validate PNG magic header bytes [137, 80, 78, 71, 13, 10, 26, 10]
const fileDescriptor = fs.openSync(sourceArtifact, 'r');
const headerBuffer = Buffer.alloc(8);
fs.readSync(fileDescriptor, headerBuffer, 0, 8, 0);
fs.closeSync(fileDescriptor);

const isPngSignature =
  headerBuffer[0] === 0x89 &&
  headerBuffer[1] === 0x50 &&
  headerBuffer[2] === 0x4e &&
  headerBuffer[3] === 0x47 &&
  headerBuffer[4] === 0x0d &&
  headerBuffer[5] === 0x0a &&
  headerBuffer[6] === 0x1a &&
  headerBuffer[7] === 0x0a;

if (!isPngSignature) {
  console.error('Asset does not match the PNG specification signature');
  process.exit(1);
}

// Ensure destination container folder exists
if (!fs.existsSync(targetFolder)) {
  fs.mkdirSync(targetFolder, { recursive: true });
}

// Copy the final verified asset to the target path
const destinationArtifact = path.join(targetFolder, 'entry.png');
fs.copyFileSync(sourceArtifact, destinationArtifact);

console.log(`[PASS] Verified and delivered entry.png (${payloadBytes} bytes) to ${destinationArtifact}`);
