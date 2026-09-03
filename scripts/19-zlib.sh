#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
ZDIR="$SRC/zlib-$ZLIB_VERSION"
[ -f "$ZDIR/win32/Makefile.gcc" ] || { echo "missing $ZDIR - run 'make fetch' first" >&2; exit 1; }
rm -rf "$BUILD/zlib"
mkdir -p "$BUILD/zlib"
cp -r "$ZDIR/." "$BUILD/zlib/"
cd "$BUILD/zlib"
make -f win32/Makefile.gcc -j"$JOBS" libz.a PREFIX=x86_64-w64-mingw32-
mkdir -p "$PREFIX/include" "$PREFIX/lib" "$PREFIX/lib/pkgconfig"
cp zlib.h zconf.h "$PREFIX/include/"
cp libz.a "$PREFIX/lib/"
prefix="$(pc_prefix "$PREFIX")"
cat > "$PREFIX/lib/pkgconfig/zlib.pc" <<EOF
prefix=$prefix
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: zlib
Description: zlib compression library (static)
Version: $ZLIB_VERSION
Libs: -L\${libdir} -lz
Cflags: -I\${includedir}
EOF
echo "zlib $ZLIB_VERSION installed: $PREFIX/lib/libz.a"
