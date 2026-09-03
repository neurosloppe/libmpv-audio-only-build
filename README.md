# libmpv audio-only build (Windows x86_64)

Reproducible cross-build of a **single-file `libmpv-2.dll`** for Windows x86_64:
an LGPL build of mpv stripped of video functionality.  
Built on a Cygwin host with the mingw-w64 cross toolchain.

## Result

After `make frozen` you get, inside the project-local `prefix\` directory:

| File | Purpose |
|---|---|
| `prefix\bin\libmpv-2.dll` | the library (~7 MB frozen / ~13 MB latest, single file, stripped, no runtime DLL dependencies) |
| `prefix\lib\libmpv.dll.a` | import library for linking your app |
| `prefix\include\mpv\*.h` | client API headers (`client.h`, `render.h`, `stream_cb.h`) |

Properties of the DLL:

- mpv 0.41.0 built with `-Dgpl=false` (LGPL-2.1+), `libmpv=true`, no player binary
- ffmpeg 9.0.1 statically linked, LGPL-2.1+ (`--disable-version3`, `--enable-schannel`)
- audio-only: WASAPI output, decoders limited to common audio codecs
  (aac/ac3/dca/flac/mp3/opus/vorbis/wavpack/alac/tta/ape/wma/pcm/adpcm),
  demuxers + HTTP/HTTPS/file streaming enabled, video decoding disabled
- all video outputs, hardware acceleration, scripting (lua/js) disabled
- zlib baked in statically - the DLL imports only Windows system DLLs
- frozen build: `libswscale`/`libass`/`libplacebo` (+ fonts) are replaced by
  audio-only stubs; `latest` build: all real libraries
- fully stripped release binary

## Requirements

The build runs on a cygwin host (Windows) or a Linux host - the host is
auto-detected, all targets work unchanged on both.
Developed and tested on Alpine Linux (WSL2); any modern Linux with the
mingw-w64 toolchain and meson >= 1.x should work.

On cygwin you need:

Base tools: `make`, `git`, `python3`, `pkgconf`,
`wget`, `jq`, `tar`, `bash`.

Build-specific packages - download `setup-x86_64.exe` from
https://cygwin.com/install.html and install with (adjust `--root` to your Cygwin
location):

```
setup-x86_64.exe -q --root D:\cygwin -P meson,ninja,nasm,mingw64-x86_64-gcc-g++
```

On Linux you need: `make`, `git`, `python3`, `pkgconf`, `wget`, `jq`,
`tar`, `xz`, `meson`, `ninja`, `nasm` and the `mingw-w64` cross toolchain
(`x86_64-w64-mingw32-gcc`, `g++`, binutils). For example on Alpine:

```
apk add make git python3 pkgconf wget jq xz tar meson ninja-build nasm mingw-w64-gcc
```

zlib is cross-built from source into the project-local `prefix\` directory on
every host - no distro package is needed for it.

## Build

```
make frozen
```

The frozen build fetches the exact versions pinned in `scripts/versions.lock`
(internet required) and:

1. `deps` - cross-builds static zlib; libplacebo builds real; freetype/fribidi/harfbuzz/libass are skipped
2. `ffmpeg` - cross-build static ffmpeg (audio subset)
3. `stub-libs` - compile the audio-only stub libraries (`scripts/stubs/`)
4. `mpv` - configure + build + install libmpv-2.dll (stripped)
5. `verify` - export/import checks (cygwin host: + WASAPI smoke test)

The stubs implement the ~175 libswscale/libass/libplacebo symbols mpv references
(functions plus const data tables) as silent no-ops over opaque handles, so the
linker resolves mpv's hard dependency chain without shipping ~5.5 MB of
video/font code plus the C++ runtime it would drag in. Video conversion,
subtitles and the OSD become no-ops - irrelevant for audio playback. In frozen
mode the mpv icon resource is also replaced by a minimal version-info block.

**`make latest`** fetches the newest upstream releases instead (writes
`latest.lock`), builds **without applying the stub patches** - the real
libswscale/libass/freetype/fribidi/harfbuzz/libplacebo are compiled and linked
(~13 MB DLL) - and runs the same verification. While `latest.lock` exists,
`make frozen` refuses to run (delete `latest.lock` to switch back). Use latest
deliberately: the build is only known-good for the frozen versions, and no
patches are applied in latest mode.

`make -j8` parallelizes safely (the dependency graph is encoded in the Makefile).

Useful targets:

- `make help` - list all targets
- `make fetch` - fetch only, using the frozen `versions.lock`
- `make check` - verify the toolchain
- `make zlib` - cross-build static zlib
- `make deps` - cross-build zlib and the dependency libraries (auto-skips stubbed ones in frozen mode)
- `make ffmpeg` - cross-build static ffmpeg
- `make stub-libs` - compile the stub libraries (frozen mode only)
- `make mpv` - build and install libmpv-2.dll
- `make verify` - re-run export/import checks against the current DLL (cygwin only: plus WASAPI smoke test)
- `make clean` - remove the build directory (keeps sources and `prefix\`)
- `make distclean` - remove `build\`, `src\`, `prefix\` and `latest.lock`

To rebuild only the DLL after changing its options: `make mpv verify`.

## Licensing

This repository contains build scripts for producing `libmpv-2.dll`. The repository itself is licensed under the MIT License.

The resulting DLL incorporates third-party software, including components distributed under the GNU Lesser General Public License (LGPL). The exact licenses and versions depend on the build configuration and pinned dependency revisions.
