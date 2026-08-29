ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src"
BUILD="$ROOT/build"
SCRIPTS="$ROOT/scripts"
PREFIX="$ROOT/prefix"
PKGCFG="pkgconf"
export PKG_CONFIG="$PKGCFG"
export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig:/usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig"
export PATH="$SCRIPTS/shims:$PATH"
[ -f "$SRC/versions.env" ] || { echo "sources not fetched - run 'make fetch' first" >&2; exit 1; }
. "$SRC/versions.env"
JOBS="$(nproc 2>/dev/null || echo 4)"

meson_build() {
    local name="$1" srcdir="$2"
    shift 2
    rm -rf "$BUILD/$name"
    meson setup "$BUILD/$name" "$srcdir" \
        --cross-file "$SCRIPTS/mingw64.cross" \
        --buildtype=release \
        --prefix="$PREFIX" \
        "$@"
    ninja -C "$BUILD/$name" -j "$JOBS" install
}
