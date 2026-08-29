#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$DIR/../build"
mkdir -p "$BUILD" "$BUILD/shims"
chmod +x "$DIR/shims/dlltool"
[ -f "$DIR/mingw64.cross" ] || { echo "missing $DIR/mingw64.cross" >&2; exit 1; }
echo "cross file: $DIR/mingw64.cross"
echo "dlltool shim: $DIR/shims/dlltool -> $(x86_64-w64-mingw32-dlltool --version | head -1)"
echo "crossfile OK"
