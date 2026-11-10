#!/usr/bin/env python3
"""Turns the original illustrations into the tiles of the nest and the icon.

Usage: tool/prepare_art.py <folder with 01_ovo.jpeg ... 11_rainha.jpeg>

Only the plain background around the drawing changes colour, so that each step
of the chain can be told apart at a glance. Birds that reach the bottom of the
picture stay cut by the edge of the tile.
"""
import random
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "birds"
SIZE = 320
# Cuts off the mark that the generator leaves on the bottom right corner.
CROP = .94

NAMES = [
    ("01_ovo", (243, 231, 201)),
    ("02_trincando", (242, 214, 160)),
    ("03_pelado", (190, 214, 196)),
    ("04_penugem", (176, 205, 226)),
    ("05_jovem", (235, 196, 170)),
    ("06_cinza", (244, 190, 120)),
    ("07_perola", (174, 208, 200)),
    ("08_canela", (206, 192, 226)),
    ("09_lutino", (226, 150, 150)),
    ("10_arlequim", (150, 196, 150)),
    ("11_rainha", (96, 58, 140)),
]

MARKER = (255, 0, 255)


def background_mask(img: Image.Image, threshold: int = 30) -> Image.Image:
    """The background, found from the top of the picture and its upper sides."""
    flood = img.copy()
    w, h = img.size
    seeds = [(x, 0) for x in range(0, w, 6)]
    seeds += [(side, y) for y in range(0, h // 2, 6) for side in (0, w - 1)]
    for seed in seeds:
        if flood.getpixel(seed) != MARKER:
            ImageDraw.floodfill(flood, seed, MARKER, thresh=threshold)
    mask = Image.eval(
        ImageChops.difference(flood, Image.new("RGB", (w, h), MARKER)).convert("L"),
        lambda v: 0 if v > 6 else 255,
    )
    # Reaches a little into the outline, so that no pale fringe is left.
    return mask.filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.GaussianBlur(1.5))


def paper(size: int, colour, rng: random.Random) -> Image.Image:
    grain = Image.new("L", (size // 6, size // 6))
    grain.putdata([128 + rng.randint(-7, 7) for _ in range(grain.width**2)])
    grain = grain.resize((size, size), Image.BICUBIC).filter(ImageFilter.GaussianBlur(3))
    return ImageChops.overlay(Image.new("RGB", (size, size), colour), grain.convert("RGB"))


def rounded(size: int, radius: int) -> Image.Image:
    big = Image.new("L", (size * 3, size * 3), 0)
    ImageDraw.Draw(big).rounded_rectangle((0, 0, size * 3 - 1, size * 3 - 1), radius * 3, fill=255)
    return big.resize((size, size), Image.LANCZOS)


def load(art: Path, name: str) -> Image.Image:
    img = Image.open(art / f"{name}.jpeg").convert("RGB")
    side = int(img.width * CROP)
    return img.crop((0, 0, side, side))


def tile(art: Path, name: str, colour, level: int) -> None:
    img = load(art, name)
    mask = background_mask(img)
    ground = paper(img.width, colour, random.Random(level))
    out = Image.composite(ground, img, mask).resize((SIZE, SIZE), Image.LANCZOS).convert("RGBA")
    out.putalpha(rounded(SIZE, int(SIZE * .14)))
    out.save(OUT / f"{level}.png", optimize=True)


def icon(art: Path) -> None:
    img = load(art, "02_trincando")
    mask = ImageChops.invert(background_mask(img))
    egg = img.convert("RGBA")
    egg.putalpha(mask)
    egg = egg.crop(mask.getbbox())
    side = 512
    ground = paper(side, (138, 90, 58), random.Random(1)).convert("RGBA")
    ground.putalpha(rounded(side, 110))
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    canvas.alpha_composite(ground)
    ratio = 400 / max(egg.size)
    egg = egg.resize((round(egg.width * ratio), round(egg.height * ratio)), Image.LANCZOS)
    canvas.alpha_composite(egg, ((side - egg.width) // 2, (side - egg.height) // 2))
    canvas.save(ROOT / "icon.png", optimize=True)
    canvas.save(ROOT / "site" / "icon.png", optimize=True)
    canvas.resize((256, 256), Image.LANCZOS).save(
        ROOT / "windows" / "runner" / "resources" / "app_icon.ico",
        sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
    )


def main() -> None:
    art = Path(sys.argv[1])
    OUT.mkdir(parents=True, exist_ok=True)
    for level, (name, colour) in enumerate(NAMES, 1):
        tile(art, name, colour, level)
    icon(art)


if __name__ == "__main__":
    main()
