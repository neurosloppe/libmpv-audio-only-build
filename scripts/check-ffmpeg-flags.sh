#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/env.sh"
mkdir -p "$BUILD"
"$SRC/ffmpeg-$FFMPEG_VERSION/configure" --help > "$BUILD/ffmpeg-help.txt" 2>&1
flags="$(grep -oE '^[[:space:]]*--[a-zA-Z0-9_-]+' "$DIR/30-ffmpeg.sh" | tr -d ' \t' | sort -u)"
status=0
checked=0
for f in $flags; do
    base="${f%%=*}"
    if grep -q -- "$base" "$BUILD/ffmpeg-help.txt"; then
        checked=$((checked + 1))
        continue
    fi
    if [[ "$base" == --enable-* ]]; then
        inv="--disable-${base#--enable-}"
    elif [[ "$base" == --disable-* ]]; then
        inv="--enable-${base#--disable-}"
    else
        inv=""
    fi
    if [ -n "$inv" ] && grep -q -- "$inv" "$BUILD/ffmpeg-help.txt"; then
        checked=$((checked + 1))
        continue
    fi
    echo "INVALID: $f"
    status=1
done
if [ "$status" -eq 0 ]; then
    echo "all $checked ffmpeg configure flags valid for ffmpeg-$FFMPEG_VERSION"
fi
exit "$status"
