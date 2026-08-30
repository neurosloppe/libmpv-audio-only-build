#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
if [ "${STUBS_ENABLED:-0}" = "1" ]; then
    echo "[stubs] skipped: stubbed out in frozen mode"
    exit 0
fi
meson_build freetype "$SRC/freetype-$FREETYPE_VERSION" \
    --default-library=static \
    -Dzlib=enabled \
    -Dbzip2=disabled \
    -Dpng=disabled \
    -Dharfbuzz=disabled \
    -Dbrotli=disabled \
    -Dtests=disabled
