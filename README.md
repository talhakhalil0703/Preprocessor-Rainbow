# Preprocessor Rainbow

Highlights C/C++ `#if` / `#ifdef` / `#ifndef` … `#endif` blocks with layered,
translucent backgrounds. Each nesting depth gets its own color, and because the
fills are semi-transparent, nested blocks visually stack and deepen — making it
easy to track where a block begins and ends even when they're deeply nested.

## Features

- Colors every preprocessor block by nesting depth (not just inactive branches).
- Colors loop, so depth 6 reuses the depth-1 color, etc.
- Status bar button to toggle highlighting on/off at any time.
- Runs only for C / C++ files (`c`, `cpp` language IDs → `.c`, `.cpp`, `.h`, `.hpp`, …).
- Fully configurable colors and per-layer alpha.

## Settings

| Setting | Default | Description |
| --- | --- | --- |
| `preprocessorRainbow.enabled` | `true` | Master on/off (also toggled from the status bar). |
| `preprocessorRainbow.colors` | Paul Tol *bright* palette (5 colors) | Hex colors looped over per depth. |
| `preprocessorRainbow.alphas` | `[0.12 × 5]` | Per-layer alpha (0–1). Last value reused if shorter than `colors`. |
| `preprocessorRainbow.maxDepth` | `24` | Safety cap on nesting depth processed. |

### Default palette (color-blind friendly)

The defaults use the [Paul Tol *bright* qualitative palette](https://personal.sron.nl/~pault/),
chosen specifically to remain distinguishable for the common forms of color
vision deficiency:

| Depth | Color |
| --- | --- |
| 1 | `#4477AA` (blue) |
| 2 | `#EE6677` (red) |
| 3 | `#228833` (green) |
| 4 | `#CCBB44` (yellow) |
| 5 | `#AA3377` (purple) |

## Develop / run locally

```bash
npm install
npm run compile
```

Then press `F5` in the editor (uses `.vscode/launch.json`) to launch an
Extension Development Host with the extension loaded. Open any `.hpp`/`.cpp`
file containing `#if` blocks to see it in action, and click the status bar
button (bottom right) to toggle.

## Notes / limitations

- Directives are matched even when indented.
- Unbalanced `#endif` directives are skipped gracefully.
- `#if` appearing inside comments or string literals is not currently excluded
  (a simple line-based parser is used for speed).
