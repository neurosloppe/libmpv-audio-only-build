#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
meson_build mpv "$SRC/mpv-$MPV_VERSION" \
    --default-library=shared \
    -Dc_link_args="['-L$PREFIX/lib', '-static-libgcc', '-Wl,-Bstatic', '-lstdc++', '-lz', '-lwinpthread', '-Wl,-Bdynamic', '-Wl,-s']" \
    -Dauto_features=disabled \
    -Dgpl=false \
    -Dlibmpv=true \
    -Dcplayer=false \
    -Dbuild-date=false \
    -Dtests=false \
    -Dfuzzers=false \
    -Dgl=disabled \
    -Dplain-gl=disabled \
    -Dvulkan=disabled \
    -Dzlib=enabled \
    -Diconv=disabled \
    -Dwin32-threads=enabled \
    -Dwasapi=enabled \
    -Db_lto=false
