#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
if [ "${STUBS_ENABLED:-0}" = "1" ]; then
    echo "[stubs] skipped: stubbed out in frozen mode"
    exit 0
fi
meson_build libass "$SRC/libass-$LIBASS_VERSION" \
    --default-library=static \
    -Dfontconfig=disabled \
    -Dlibunibreak=disabled \
    -Ddirectwrite=enabled \
    -Dasm=disabled \
    -Dtest=disabled \
    -Dcompare=disabled \
    -Dprofile=disabled \
    -Dfuzz=disabled \
    -Dcheckasm=disabled
