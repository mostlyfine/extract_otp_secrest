#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.9"
# dependencies = ["opencv-python-headless"]
# ///
import sys

import cv2


def decode(path):
    img = cv2.imread(path)
    if img is None:
        raise ValueError(f"cannot read image: {path}")
    ok, texts, _, _ = cv2.QRCodeDetector().detectAndDecodeMulti(img)
    return [t for t in texts if t] if ok else []


def main():
    if len(sys.argv) < 2:
        print(f"usage: {sys.argv[0]} IMAGE [IMAGE...]", file=sys.stderr)
        sys.exit(1)
    for path in sys.argv[1:]:
        texts = decode(path)
        if not texts:
            print(f"no QR code found: {path}", file=sys.stderr)
        for t in texts:
            print(t)


if __name__ == "__main__":
    main()
