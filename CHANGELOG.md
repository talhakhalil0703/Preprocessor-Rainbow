# Change Log

All notable changes to the "Preprocessor Rainbow" extension are documented here.

## [0.1.0] - 2026-06-17

### Added
- Layered, translucent background highlighting of C/C++ `#if` / `#ifdef` /
  `#ifndef` … `#endif` blocks, colored by nesting depth so nested blocks
  visually stack and deepen.
- Status bar button to toggle highlighting on/off (also available as the
  *Preprocessor Rainbow: Toggle Highlighting* command).
- Configurable color palette (`preprocessorRainbow.colors`) and per-layer
  alpha (`preprocessorRainbow.alphas`), with a depth cap
  (`preprocessorRainbow.maxDepth`).
- Default five-color, color-blind-friendly palette (Paul Tol *bright*).
- Runs only for C / C++ files.
