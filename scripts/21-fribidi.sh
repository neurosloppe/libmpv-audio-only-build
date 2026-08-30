#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
if [ "${STUBS_ENABLED:-0}" = "1" ]; then
    echo "[stubs] skipped: stubbed out in frozen mode"
    exit 0
fi
meson_build fribidi "$SRC/fribidi-$FRIBIDI_VERSION" \
    --default-library=static \
    -Ddocs=false \
    -Dtests=false \
    -Dbin=false
