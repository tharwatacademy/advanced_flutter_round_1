#!/usr/bin/env python3
"""Generate flavor-specific Android launcher PNGs from main mipmaps."""
from __future__ import annotations

import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
MAIN_RES = ROOT / "app" / "src" / "main" / "res"
DENSITIES = ["mipmap-mdpi", "mipmap-hdpi", "mipmap-xhdpi", "mipmap-xxhdpi", "mipmap-xxxhdpi"]


def blend_tint(base: Image.Image, rgb: tuple[int, int, int], strength: float) -> Image.Image:
    """Multiply blend a tint over the icon (strength 0..1)."""
    img = base.convert("RGBA")
    tint = Image.new("RGBA", img.size, (*rgb, int(255 * strength)))
    r, g, b, a = img.split()
    rgb_img = Image.merge("RGB", (r, g, b))
    tint_rgb = Image.new("RGB", img.size, rgb)
    blended = Image.blend(rgb_img, tint_rgb, strength)
    out = Image.merge("RGBA", (*blended.split(), a))
    return out


def add_corner_badge(img: Image.Image, label: str, color: tuple[int, int, int]) -> Image.Image:
    """Small rounded badge with letter in bottom-right."""
    w, h = img.size
    img = img.convert("RGBA")
    draw = ImageDraw.Draw(img)
    pad = max(1, w // 16)
    size = max(w // 4, 12)
    x1, y1 = w - pad - size, h - pad - size
    x2, y2 = w - pad, h - pad
    draw.rounded_rectangle((x1, y1, x2, y2), radius=max(2, size // 5), fill=(*color, 230))
    font = None
    for font_path in (
        os.environ.get("SYSTEMROOT", "C:\\Windows") + "\\Fonts\\segoeui.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ):
        if font_path and os.path.isfile(font_path):
            try:
                font = ImageFont.truetype(font_path, size=int(size * 0.55))
                break
            except OSError:
                continue
    if font is None:
        font = ImageFont.load_default()
    bbox = draw.textbbox((0, 0), label, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = x1 + (size - tw) / 2
    ty = y1 + (size - th) / 2 - bbox[1]
    draw.text((tx, ty), label, fill=(255, 255, 255, 255), font=font)
    return img


def process_density(dest_root: Path, tint_rgb: tuple[int, int, int], badge: str | None) -> None:
    for density in DENSITIES:
        src = MAIN_RES / density / "ic_launcher.png"
        if not src.exists():
            raise FileNotFoundError(src)
        img = Image.open(src)
        # Light tint + optional badge for readability on home screen
        out = blend_tint(img, tint_rgb, 0.22)
        if badge:
            out = add_corner_badge(out, badge, tint_rgb)
        out_dir = dest_root / density
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "ic_launcher.png"
        out.save(out_path, "PNG")
        print(f"Wrote {out_path}")


def main() -> None:
    flavors = {
        "dev": ((33, 150, 243), "D"),  # Material blue
        "staging": ((255, 152, 0), "S"),  # Material orange
    }
    for name, (rgb, badge) in flavors.items():
        dest = ROOT / "app" / "src" / name / "res"
        process_density(dest, rgb, badge)
    print("Done. Prod uses main/res mipmaps (no override).")


if __name__ == "__main__":
    main()
