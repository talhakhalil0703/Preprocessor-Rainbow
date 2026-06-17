// Node 18 lacks a global `File`, which newer undici (pulled in by vsce)
// references at load time. Provide it from node:buffer before vsce loads.
if (typeof globalThis.File === 'undefined') {
  const { File } = require('node:buffer');
  if (File) {
    globalThis.File = File;
  }
}
