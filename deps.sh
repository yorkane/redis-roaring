#!/usr/bin/env bash
# libroaring building:
curl -Lk  https://github.com/RoaringBitmap/CRoaring/releases/download/v0.4.0/roaring.zip | bsdtar -xkf- -C croaring
cd croaring
make && make install