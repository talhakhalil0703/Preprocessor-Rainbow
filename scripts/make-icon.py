#!/usr/bin/env python3
"""Generate images/icon.png: a 128x128 icon with five horizontal bands using
the extension's color-blind-friendly Paul Tol 'bright' palette. No third-party
dependencies (pure stdlib PNG encoder)."""
import os
import struct
import zlib

SIZE = 128
PALETTE = [
    (0x44, 0x77, 0xAA),  # blue
    (0xEE, 0x66, 0x77),  # red
    (0x22, 0x88, 0x33),  # green
    (0xCC, 0xBB, 0x44),  # yellow
    (0xAA, 0x33, 0x77),  # purple
]
BORDER = (0x22, 0x22, 0x22)  # subtle dark frame


def build_pixels():
    rows = []
    band_h = SIZE / len(PALETTE)
    for y in range(SIZE):
        band = min(int(y // band_h), len(PALETTE) - 1)
        r, g, b = PALETTE[band]
        row = bytearray()
        row.append(0)  # PNG filter type 0 (None) per scanline
        for x in range(SIZE):
            if x < 3 or x >= SIZE - 3 or y < 3 or y >= SIZE - 3:
                pr, pg, pb = BORDER
            else:
                pr, pg, pb = r, g, b
            row += bytes((pr, pg, pb, 255))
        rows.append(bytes(row))
    return b"".join(rows)


def chunk(tag, data):
    return (
        struct.pack(">I", len(data))
        + tag
        + data
        + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
    )


def main():
    raw = build_pixels()
    ihdr = struct.pack(">IIBBBBB", SIZE, SIZE, 8, 6, 0, 0, 0)  # 8-bit RGBA
    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", ihdr)
        + chunk(b"IDAT", zlib.compress(raw, 9))
        + chunk(b"IEND", b"")
    )
    out_dir = os.path.join(os.path.dirname(__file__), "..", "images")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "icon.png")
    with open(out_path, "wb") as f:
        f.write(png)
    print("wrote", os.path.normpath(out_path), len(png), "bytes")


if __name__ == "__main__":
    main()
