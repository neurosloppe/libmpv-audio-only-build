#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
meson_build fribidi "$SRC/fribidi-$FRIBIDI_VERSION" \
    --default-library=static \
    -Ddocs=false \
    -Dtests=false \
    -Dbin=false
