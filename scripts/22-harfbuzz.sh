#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
if [ "${STUBS_ENABLED:-0}" = "1" ]; then
    echo "[stubs] skipped: stubbed out in frozen mode"
    exit 0
fi
meson_build harfbuzz "$SRC/harfbuzz-$HARFBUZZ_VERSION" \
    --default-library=static \
    -Dglib=disabled \
    -Dgobject=disabled \
    -Dcairo=disabled \
    -Dfreetype=disabled \
    -Dicu=disabled \
    -Dgraphite=disabled \
    -Dgraphite2=disabled \
    -Dchafa=disabled \
    -Dpng=disabled \
    -Dzlib=disabled \
    -Dfontations=disabled \
    -Dharfrust=disabled \
    -Dkbts=disabled \
    -Dwasm=disabled \
    -Dgpu=disabled \
    -Draster=disabled \
    -Dvector=disabled \
    -Dsubset=disabled \
    -Dutilities=disabled \
    -Dintrospection=disabled \
    -Dbenchmark=disabled \
    -Dtests=disabled \
    -Ddocs=disabled
