ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src"
BUILD="$ROOT/build"
SCRIPTS="$ROOT/scripts"
PREFIX="$ROOT/prefix"
case "$(uname -s)" in
    CYGWIN*|MSYS*|MINGW*) HOST_KIND=cygwin ;;
    *) HOST_KIND=linux ;;
esac
export HOST_KIND
PKGCFG="pkgconf"
export PKG_CONFIG="$PKGCFG"
export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig"
if [ "$HOST_KIND" = "cygwin" ]; then
    export PATH="/usr/bin:$SCRIPTS/shims:$PATH"
else
    export PATH="$SCRIPTS/shims:$PATH"
fi
pc_prefix() {
    if command -v cygpath >/dev/null 2>&1; then
        cygpath -m "$1"
    else
        printf '%s' "$1"
    fi
}
[ -f "$SRC/versions.env" ] || { echo "sources not fetched - run 'make fetch' (frozen) or 'make latest' first" >&2; exit 1; }
. "$SRC/versions.env"
BUILD_MODE="${BUILD_MODE:-custom}"
STUBS_ENABLED=0
if [ "$BUILD_MODE" = "frozen" ] && [ ! -f "$ROOT/latest.lock" ]; then
    STUBS_ENABLED=1
fi
export STUBS_ENABLED
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
