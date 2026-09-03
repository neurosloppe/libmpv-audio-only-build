#!/usr/bin/env bash
set -euo pipefail
case "$(uname -s)" in
    CYGWIN*|MSYS*|MINGW*) host=cygwin ;;
    *) host=linux ;;
esac
fail=0
for t in meson ninja nasm pkgconf python3 make wget jq git tar xz gzip \
         x86_64-w64-mingw32-gcc x86_64-w64-mingw32-g++ \
         x86_64-w64-mingw32-ar x86_64-w64-mingw32-gcc-ar x86_64-w64-mingw32-gcc-ranlib \
         x86_64-w64-mingw32-dlltool x86_64-w64-mingw32-windres x86_64-w64-mingw32-strip; do
    if command -v "$t" >/dev/null 2>&1; then
        echo "OK   $t"
    else
        echo "MISS $t"
        fail=1
    fi
done
if [ "$fail" -ne 0 ]; then
    if [ "$host" = "cygwin" ]; then
        echo "toolchain incomplete, install missing cygwin packages" >&2
    else
        echo "toolchain incomplete, install missing host packages:" >&2
        echo "  alpine:        apk add meson ninja-build nasm pkgconf" >&2
        echo "  debian/ubuntu: apt install meson ninja-build nasm pkgconf" >&2
        echo "  fedora:        dnf install meson ninja-build nasm pkgconf" >&2
    fi
    exit 1
fi
echo "meson      $(meson --version)"
echo "ninja      $(ninja --version)"
echo "nasm       $(nasm -v 2>&1 | head -1)"
echo "gcc        $(x86_64-w64-mingw32-gcc --version | head -1)"
echo "pkgconf    $(pkgconf --version)"
echo "toolchain OK"
