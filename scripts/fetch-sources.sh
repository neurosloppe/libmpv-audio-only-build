#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src"
SCRIPTS="$ROOT/scripts"
LOCK="$SCRIPTS/versions.lock"
mkdir -p "$SRC"
cd "$SRC"

say() {
    printf '[fetch] %s\n' "$*"
}

need() {
    command -v "$1" >/dev/null 2>&1 || { printf 'missing tool: %s\n' "$1" >&2; exit 1; }
}

need wget
need jq
need tar
need git

lock_get() {
    [ -f "$LOCK" ] || return 0
    grep -m1 "^$1=" "$LOCK" | cut -d= -f2- | tr -d '\r'
}

set_version() {
    local var="$1" latest="$2"
    if [ -n "${!var:-}" ]; then
        say "$var overridden via environment: ${!var}"
        return 0
    fi
    if [ "${LATEST:-0}" = "1" ]; then
        eval "$var=\$latest"
        say "$var resolved to latest: ${!var}"
        return 0
    fi
    local locked
    locked="$(lock_get "$var")"
    if [ -n "$locked" ]; then
        eval "$var=\$locked"
        say "$var frozen: ${!var}"
        return 0
    fi
    printf 'no version for %s: not in %s, not set via env, LATEST=1 not given\n' "$var" "$LOCK" >&2
    exit 1
}

gh_latest() {
    wget -qO- "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

gh_tags() {
    wget -qO- "https://api.github.com/repos/$1/tags?per_page=100" | jq -r '.[].name'
}

strip_v() {
    printf '%s' "${1#v}"
}

dl() {
    local url="$1" out="$2"
    if [ -s "$out" ]; then
        say "cached $out"
        return 0
    fi
    say "GET $url"
    wget -q -O "$out" "$url"
}

extract_to() {
    local archive="$1" want="$2"
    if [ -d "$want" ]; then
        say "exists $want"
        return 0
    fi
    tar -xf "$archive"
    [ -d "$want" ] || { printf 'expected directory %s after extracting %s\n' "$want" "$archive" >&2; exit 1; }
    say "extracted $want"
}

FFMPEG_LATEST=""
MPV_LATEST=""
LIBPLACEBO_LATEST=""
HARFBUZZ_LATEST=""
FRIBIDI_LATEST=""
LIBASS_LATEST=""
FREETYPE_LATEST=""

if [ "${LATEST:-0}" = "1" ]; then
    FFMPEG_TARBALL="$(wget -qO- https://ffmpeg.org/releases/ | grep -oE 'ffmpeg-[0-9]+(\.[0-9]+)+\.tar\.xz' | sort -uV | tail -1)"
    FFMPEG_LATEST="${FFMPEG_TARBALL#ffmpeg-}"
    FFMPEG_LATEST="${FFMPEG_LATEST%.tar.xz}"
    MPV_LATEST="$(gh_latest mpv-player/mpv)"
    LIBPLACEBO_LATEST="$(gh_latest haasn/libplacebo)"
    HARFBUZZ_LATEST="$(gh_latest harfbuzz/harfbuzz)"
    FRIBIDI_LATEST="$(gh_latest fribidi/fribidi)"
    LIBASS_LATEST="$(gh_latest libass/libass)"
    FREETYPE_LATEST="$(gh_tags freetype/freetype | grep -E '^VER-2-[0-9]+(-[0-9]+)?$' | sort -V | tail -1)"
fi

set_version FFMPEG_VERSION "$FFMPEG_LATEST"
say "ffmpeg $FFMPEG_VERSION"
dl "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz" "ffmpeg-${FFMPEG_VERSION}.tar.xz"
extract_to "ffmpeg-${FFMPEG_VERSION}.tar.xz" "ffmpeg-${FFMPEG_VERSION}"

set_version MPV_TAG "$MPV_LATEST"
MPV_VERSION="$(strip_v "$MPV_TAG")"
say "mpv $MPV_VERSION"
dl "https://github.com/mpv-player/mpv/archive/refs/tags/${MPV_TAG}.tar.gz" "mpv-${MPV_VERSION}.tar.gz"
extract_to "mpv-${MPV_VERSION}.tar.gz" "mpv-${MPV_VERSION}"

set_version LIBPLACEBO_TAG "$LIBPLACEBO_LATEST"
LIBPLACEBO_VERSION="$(strip_v "$LIBPLACEBO_TAG")"
say "libplacebo $LIBPLACEBO_VERSION"
if [ -d "libplacebo-${LIBPLACEBO_VERSION}" ]; then
    say "exists libplacebo-${LIBPLACEBO_VERSION}"
else
    git clone --depth 1 --shallow-submodules --branch "$LIBPLACEBO_TAG" \
        --recursive https://github.com/haasn/libplacebo.git "libplacebo-${LIBPLACEBO_VERSION}"
fi

set_version HARFBUZZ_TAG "$HARFBUZZ_LATEST"
HARFBUZZ_VERSION="$(strip_v "$HARFBUZZ_TAG")"
say "harfbuzz $HARFBUZZ_VERSION"
dl "https://github.com/harfbuzz/harfbuzz/releases/download/${HARFBUZZ_TAG}/harfbuzz-${HARFBUZZ_VERSION}.tar.xz" "harfbuzz-${HARFBUZZ_VERSION}.tar.xz"
extract_to "harfbuzz-${HARFBUZZ_VERSION}.tar.xz" "harfbuzz-${HARFBUZZ_VERSION}"

set_version FRIBIDI_TAG "$FRIBIDI_LATEST"
FRIBIDI_VERSION="$(strip_v "$FRIBIDI_TAG")"
say "fribidi $FRIBIDI_VERSION"
dl "https://github.com/fribidi/fribidi/releases/download/${FRIBIDI_TAG}/fribidi-${FRIBIDI_VERSION}.tar.xz" "fribidi-${FRIBIDI_VERSION}.tar.xz"
extract_to "fribidi-${FRIBIDI_VERSION}.tar.xz" "fribidi-${FRIBIDI_VERSION}"

set_version LIBASS_TAG "$LIBASS_LATEST"
LIBASS_VERSION="$(strip_v "$LIBASS_TAG")"
say "libass $LIBASS_VERSION"
dl "https://github.com/libass/libass/releases/download/${LIBASS_TAG}/libass-${LIBASS_VERSION}.tar.xz" "libass-${LIBASS_VERSION}.tar.xz"
extract_to "libass-${LIBASS_VERSION}.tar.xz" "libass-${LIBASS_VERSION}"

set_version FREETYPE_TAG "$FREETYPE_LATEST"
FREETYPE_VERSION="2.$(printf '%s' "$FREETYPE_TAG" | sed -e 's/^VER-2-//' -e 's/-/./g')"
FREETYPE_DIR="freetype-${FREETYPE_VERSION}"
say "freetype $FREETYPE_VERSION"
if [ -d "$FREETYPE_DIR" ]; then
    say "exists $FREETYPE_DIR"
else
    dl "https://download.savannah.gnu.org/releases/freetype/${FREETYPE_DIR}.tar.xz" "${FREETYPE_DIR}.tar.xz" \
        || dl "https://github.com/freetype/freetype/archive/refs/tags/${FREETYPE_TAG}.tar.gz" "${FREETYPE_DIR}.tar.xz"
    tar -xf "${FREETYPE_DIR}.tar.xz"
    if [ ! -d "$FREETYPE_DIR" ] && [ -d "freetype-${FREETYPE_TAG}" ]; then
        mv "freetype-${FREETYPE_TAG}" "$FREETYPE_DIR"
    fi
    [ -d "$FREETYPE_DIR" ] || { printf 'freetype extraction failed\n' >&2; exit 1; }
    say "extracted $FREETYPE_DIR"
fi

cat > versions.env <<EOF
FFMPEG_VERSION=${FFMPEG_VERSION}
MPV_TAG=${MPV_TAG}
MPV_VERSION=${MPV_VERSION}
LIBPLACEBO_TAG=${LIBPLACEBO_TAG}
LIBPLACEBO_VERSION=${LIBPLACEBO_VERSION}
HARFBUZZ_TAG=${HARFBUZZ_TAG}
HARFBUZZ_VERSION=${HARFBUZZ_VERSION}
FRIBIDI_TAG=${FRIBIDI_TAG}
FRIBIDI_VERSION=${FRIBIDI_VERSION}
LIBASS_TAG=${LIBASS_TAG}
LIBASS_VERSION=${LIBASS_VERSION}
FREETYPE_TAG=${FREETYPE_TAG}
FREETYPE_VERSION=${FREETYPE_VERSION}
EOF

if [ "${LATEST:-0}" = "1" ]; then
    cat > "$LOCK" <<EOF
FFMPEG_VERSION=${FFMPEG_VERSION}
MPV_TAG=${MPV_TAG}
LIBPLACEBO_TAG=${LIBPLACEBO_TAG}
HARFBUZZ_TAG=${HARFBUZZ_TAG}
FRIBIDI_TAG=${FRIBIDI_TAG}
LIBASS_TAG=${LIBASS_TAG}
FREETYPE_TAG=${FREETYPE_TAG}
EOF
    say "versions.lock updated to the resolved latest versions"
fi

say "versions.env written"
say "mpv meson ffmpeg requirements:"
grep -E "^lib(av|sw)[a-z]+ = dependency" "mpv-${MPV_VERSION}/meson.build" | sed 's/^/  /'
say "done"
