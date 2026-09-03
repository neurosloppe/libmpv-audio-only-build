#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/env.sh"

if [ "${STUBS_ENABLED:-0}" != "1" ]; then
    echo "[stubs] disabled (BUILD_MODE=${BUILD_MODE:-unknown}) - real libraries will be linked"
    exit 0
fi

echo "[stubs] building stub libraries for the frozen audio-only build"
STUBBUILD="$BUILD/stubs"
rm -rf "$STUBBUILD"
mkdir -p "$STUBBUILD/plinc/libplacebo" "$PREFIX/lib" "$PREFIX/lib/pkgconfig" "$PREFIX/include/ass" "$PREFIX/include/libplacebo"

CC=x86_64-w64-mingw32-gcc
AR=x86_64-w64-mingw32-ar

"$CC" -c "$SCRIPTS/stubs/libswscale_stub.c" -I"$PREFIX/include" -o "$STUBBUILD/libswscale_stub.o"

cp "$SRC/libass-$LIBASS_VERSION/libass/ass.h" "$PREFIX/include/ass/"
cp "$SRC/libass-$LIBASS_VERSION/libass/ass_types.h" "$PREFIX/include/ass/"
"$CC" -c "$SCRIPTS/stubs/libass_stub.c" -I"$PREFIX/include" -o "$STUBBUILD/libass_stub.o"

python3 "$SRC/libplacebo-$LIBPLACEBO_VERSION/src/version.py" \
    "$SRC/libplacebo-$LIBPLACEBO_VERSION/src/version.h.in" \
    "$STUBBUILD/plinc/libplacebo/version.h" \
    "$SRC/libplacebo-$LIBPLACEBO_VERSION/src" \
    "v$LIBPLACEBO_VERSION"
cp -r "$SRC/libplacebo-$LIBPLACEBO_VERSION/src/include/libplacebo/." "$PREFIX/include/libplacebo/"
cp "$STUBBUILD/plinc/libplacebo/version.h" "$PREFIX/include/libplacebo/version.h"
APIVER="$(echo "$LIBPLACEBO_VERSION" | cut -d. -f2)"
MAJORVER="$(echo "$LIBPLACEBO_VERSION" | cut -d. -f1)"
sed -e "s/@majorver@/$MAJORVER/" -e "s/@apiver@/$APIVER/" -e "s/@extra_defs@//" \
    "$SRC/libplacebo-$LIBPLACEBO_VERSION/src/include/libplacebo/config.h.in" \
    > "$PREFIX/include/libplacebo/config.h"
"$CC" -c "$SCRIPTS/stubs/libplacebo_stub.c" -I"$PREFIX/include" -DPL_STATIC -o "$STUBBUILD/libplacebo_stub.o"

rm -f "$PREFIX/lib/libswscale.a" "$PREFIX/lib/libass.a" "$PREFIX/lib/libplacebo.a"
"$AR" rcs "$PREFIX/lib/libswscale.a" "$STUBBUILD/libswscale_stub.o"
"$AR" rcs "$PREFIX/lib/libass.a" "$STUBBUILD/libass_stub.o"
"$AR" rcs "$PREFIX/lib/libplacebo.a" "$STUBBUILD/libplacebo_stub.o"

PCCFG="libswscale:10.1.101 libass:0.17.5 libplacebo:7.360.1"
for entry in $PCCFG; do
    name="${entry%%:*}"
    ver="${entry##*:}"
    base="${name#lib}"
    cat > "$PREFIX/lib/pkgconfig/$name.pc" <<EOF
prefix=$(pc_prefix "$PREFIX")
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: $name
Description: audio-only stub (frozen build)
Version: $ver
Libs: -L\${libdir} -l$base
Cflags: -I\${includedir}
EOF
done

cat >> "$PREFIX/lib/pkgconfig/libplacebo.pc" <<EOF
pl_has_vulkan=0
pl_has_opengl=0
pl_has_d3d11=0
pl_has_shaderc=0
pl_has_glslang=0
pl_has_lcms=0
pl_has_dovi=0
pl_has_libdovi=0
pl_has_xxhash=0
EOF

sed -i 's/^Cflags: -I${includedir}$/Cflags: -I${includedir} -DPL_STATIC/' "$PREFIX/lib/pkgconfig/libplacebo.pc"

echo "[stubs] minimal Windows resource (icon/manifest replaced with version info)"
cat > "$SRC/mpv-$MPV_VERSION/osdep/mpv.rc" <<EOF
#include <winver.h>

VS_VERSION_INFO VERSIONINFO
    FILEVERSION 2, 0, 0, 0
    PRODUCTVERSION 2, 0, 0, 0
    FILEFLAGSMASK VS_FFI_FILEFLAGSMASK
    FILEFLAGS 0
    FILEOS VOS__WINDOWS32
    FILETYPE VFT_DLL
    FILESUBTYPE 0
    {
        BLOCK "StringFileInfo" {
            BLOCK "000004b0" {
                VALUE "FileDescription", "libmpv (audio-only build)"
                VALUE "FileVersion", "$MPV_VERSION"
                VALUE "ProductName", "libmpv"
                VALUE "ProductVersion", "$MPV_VERSION"
            }
        }
        BLOCK "VarFileInfo" {
            VALUE "Translation", 0, 1200
        }
    }
EOF

echo "[stubs] installed: libswscale.a libass.a libplacebo.a + headers + .pc files + minimal resource"
