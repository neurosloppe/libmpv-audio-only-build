#!/usr/bin/env bash
set -euo pipefail
fail=0
for t in meson ninja nasm python3 make wget jq git \
         x86_64-w64-mingw32-gcc x86_64-w64-mingw32-g++ \
         x86_64-w64-mingw32-ar x86_64-w64-mingw32-gcc-ar x86_64-w64-mingw32-gcc-ranlib \
         x86_64-w64-mingw32-dlltool x86_64-w64-mingw32-windres x86_64-w64-mingw32-strip \
         x86_64-w64-mingw32-pkg-config; do
    if command -v "$t" >/dev/null 2>&1; then
        echo "OK   $t"
    else
        echo "MISS $t"
        fail=1
    fi
done
if [ "$fail" -ne 0 ]; then
    echo "toolchain incomplete, install missing cygwin packages" >&2
    exit 1
fi
echo "meson      $(meson --version)"
echo "ninja      $(ninja --version)"
echo "nasm       $(nasm -v 2>&1 | head -1)"
echo "gcc        $(x86_64-w64-mingw32-gcc --version | head -1)"
echo "pkgconf    $(x86_64-w64-mingw32-pkg-config --version)"
echo "zlib       $(x86_64-w64-mingw32-pkg-config --modversion zlib)"
echo "liblzma    $(x86_64-w64-mingw32-pkg-config --modversion liblzma)"
PREFIX=/usr/x86_64-w64-mingw32/sys-root/mingw
for h in zlib.h lzma.h; do
    [ -f "$PREFIX/include/$h" ] || { echo "missing sysroot header $h" >&2; exit 1; }
done
echo "toolchain OK"
