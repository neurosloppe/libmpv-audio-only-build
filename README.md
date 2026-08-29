# libmpv audio-only build (Windows x86_64)

Reproducible cross-build of a **single-file `libmpv-2.dll`** for Windows x86_64:
an LGPL build of mpv stripped of video functionality.  
Built on a Cygwin host with the mingw-w64 cross toolchain.

## Result

After `make` you get, inside the project-local `prefix\` directory:

| File | Purpose |
|---|---|
| `prefix\bin\libmpv-2.dll` | the library (~13 MB, single file, stripped, no runtime DLL dependencies) |
| `prefix\lib\libmpv.dll.a` | import library for linking your app |
| `prefix\include\mpv\*.h` | client API headers (`client.h`, `render.h`, `stream_cb.h`) |

Properties of the DLL:

- mpv 0.41.0 built with `-Dgpl=false` (LGPL-2.1+), `libmpv=true`, no player binary
- ffmpeg 9.0.1 statically linked, LGPL-2.1+ (`--disable-version3`, `--enable-schannel`)
- audio-only: WASAPI output, decoders limited to common audio codecs
  (aac/ac3/dca/flac/mp3/opus/vorbis/cook/wavpack/alac/tta/ape/wma/pcm/adpcm),
  demuxers + HTTP/HTTPS/file streaming enabled, video decoding disabled
- all video outputs, hardware acceleration, scripting (lua/js) disabled
- freetype, fribidi, harfbuzz, libass, libplacebo, zlib, liblzma baked in
  statically - the DLL imports only Windows system DLLs
- fully stripped release binary

## Requirements

Windows with **Cygwin**.  
Inside Cygwin you need:

Base tools: `make`, `git`, `python3`, `pkgconf`,
`wget`, `jq`, `tar`, `bash`.

Build-specific packages - download `setup-x86_64.exe` from
https://cygwin.com/install.html and install with (adjust `--root` to your Cygwin
location):

```
setup-x86_64.exe -q --root D:\cygwin -P meson,ninja,nasm,mingw64-x86_64-gcc-g++,mingw64-x86_64-zlib,mingw64-x86_64-xz,mingw64-x86_64-pkg-config
```

## Build

```
make
```

1. `fetch` - download the exact source versions frozen in `scripts/versions.lock`
2. `deps` - cross-build freetype, fribidi, harfbuzz, libass, libplacebo (static)
3. `ffmpeg` - cross-build static ffmpeg (audio subset)
4. `mpv` - configure + build + install libmpv-2.dll (stripped)
5. `verify` - export/import checks + WASAPI smoke test

Step 1 requires internet access - it downloads the pinned sources from
ffmpeg.org and GitHub.

Useful targets:

- `make help` - list all targets
- `make clean` - remove the build directory (keeps sources and `prefix\`)
- `make distclean` - remove `build\`, `src\` and `prefix\` for a from-scratch build
- `make verify` - re-run checks + smoke test against the current DLL
- `make latest-fetch` - deliberately re-resolve latest upstream versions and
  rewrite `scripts/versions.lock`; only do this after re-verifying the whole
  chain, the build is only known-good for the locked versions

To rebuild only the DLL after changing its options: `make mpv verify`.

## Licensing

This repository contains build scripts for producing `libmpv-2.dll`. The repository itself is licensed under the MIT License.

The resulting DLL incorporates third-party software, including components distributed under the GNU Lesser General Public License (LGPL). The exact licenses and versions depend on the build configuration and pinned dependency revisions.

| Component | License |
| --- | --- |
| mpv (`-Dgpl=false`) | LGPL-2.1-or-later |
| FFmpeg (`--disable-version3`) | LGPL-2.1-or-later, with individual files/components subject to their respective licenses |
| libplacebo | LGPL-2.1-or-later |
| FriBidi | LGPL-2.1-or-later |
| libass | ISC |
| FreeType | FTL |
| HarfBuzz | MIT |
| zlib | Zlib |