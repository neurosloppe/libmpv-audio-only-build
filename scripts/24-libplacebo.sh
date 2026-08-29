#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
export PATH="$BUILD/shims:$PATH"
meson_build libplacebo "$SRC/libplacebo-$LIBPLACEBO_VERSION" \
    --default-library=static \
    -Dvulkan=disabled \
    -Dvk-proc-addr=disabled \
    -Dopengl=disabled \
    -Dgl-proc-addr=disabled \
    -Dd3d11=disabled \
    -Dglslang=disabled \
    -Dshaderc=disabled \
    -Dlcms=disabled \
    -Ddovi=disabled \
    -Dlibdovi=disabled \
    -Dxxhash=disabled \
    -Dunwind=disabled \
    -Ddemos=false \
    -Dtests=false \
    -Dbench=false \
    -Dfuzz=false
