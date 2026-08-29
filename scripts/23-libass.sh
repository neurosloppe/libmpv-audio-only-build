#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
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
