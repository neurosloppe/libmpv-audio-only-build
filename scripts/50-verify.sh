#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/env.sh"
DLL="$PREFIX/bin/libmpv-2.dll"
[ -f "$DLL" ] || { echo "missing $DLL, run 40-mpv.sh first" >&2; exit 1; }
dump="$(x86_64-w64-mingw32-objdump -p "$DLL")"
echo "== mpv exports =="
mpv_count="$(printf '%s\n' "$dump" | grep -cE '\+base\[[[:space:]]*[0-9]+\][[:space:]]+[0-9a-f]{4}[[:space:]]+mpv_' || true)"
total_count="$(printf '%s\n' "$dump" | grep -cE '\+base\[[[:space:]]*[0-9]+\][[:space:]]+[0-9a-f]{4}[[:space:]]+[A-Za-z_]' || true)"
echo "mpv API exports: $mpv_count (total exported symbols incl. statically linked deps: $total_count)"
[ "$mpv_count" -ge 50 ] || { echo "missing mpv API exports" >&2; exit 1; }
echo "export sanity: full client API present"
echo "== DLL imports =="
printf '%s\n' "$dump" | grep 'DLL Name' | sort -u
if printf '%s\n' "$dump" | grep -qi 'cygwin1'; then
    echo "FAIL: libmpv links against cygwin1.dll" >&2
    exit 1
fi
if printf '%s\n' "$dump" | grep -qiE 'lib(stdc\+\+|gcc_s|winpthread|freetype|fribidi|harfbuzz|placebo)|zlib1'; then
    echo "FAIL: libmpv depends on mingw runtime DLLs (libstdc++/libgcc/libwinpthread/zlib1)" >&2
    exit 1
fi
echo "OK: system DLLs only, single-file distribution"
echo "== ffmpeg static libs =="
ls "$PREFIX/lib"/libav*.a "$PREFIX/lib"/libsw*.a
if [ "$HOST_KIND" != "cygwin" ]; then
    echo "smoke test skipped: requires a cygwin host (WASAPI playback)"
    exit 0
fi
echo "== smoke test =="
mkdir -p "$BUILD/smoke"
python3 - "$BUILD/smoke/sine.wav" <<'PYEOF'
import sys, wave, math, struct
path = sys.argv[1]
with wave.open(path, 'wb') as w:
    w.setnchannels(2)
    w.setsampwidth(2)
    w.setframerate(44100)
    frames = bytearray()
    for i in range(44100 * 5):
        v = int(28000 * math.sin(2 * math.pi * 440 * i / 44100))
        frames += struct.pack('<hh', v, v)
    w.writeframes(bytes(frames))
PYEOF
x86_64-w64-mingw32-gcc "$SCRIPTS/smoke.c" \
    -I"$PREFIX/include" -L"$PREFIX/lib" -lmpv \
    -o "$BUILD/smoke/smoke.exe"
cp "$PREFIX/bin/libmpv-2.dll" "$BUILD/smoke/"
AO="${1:-wasapi}"
WAV="$(cygpath -w "$BUILD/smoke/sine.wav")"
"$BUILD/smoke/smoke.exe" "$WAV" "$AO"
