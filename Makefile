.PHONY: all help fetch latest-fetch check crossfile deps freetype fribidi harfbuzz libass libplacebo ffmpeg mpv verify clean distclean

all: verify

help:
	@echo "make              full chain: fetch, deps, ffmpeg, mpv, verify"
	@echo "make fetch        download frozen source versions"
	@echo "make latest-fetch re-resolve latest versions and rewrite versions.lock"
	@echo "make deps         cross-build freetype, fribidi, harfbuzz, libass, libplacebo"
	@echo "make ffmpeg       cross-build static ffmpeg"
	@echo "make mpv          build libmpv-2.dll"
	@echo "make verify       export/import checks plus WASAPI smoke test"
	@echo "make clean        remove build directory"
	@echo "make distclean    remove build directory and sources"

fetch:
	bash scripts/fetch-sources.sh

latest-fetch:
	LATEST=1 bash scripts/fetch-sources.sh

check:
	bash scripts/00-check-toolchain.sh

crossfile: check fetch
	bash scripts/10-crossfile.sh

deps: crossfile freetype fribidi harfbuzz libass libplacebo

freetype: crossfile
	bash scripts/20-freetype.sh

fribidi: crossfile
	bash scripts/21-fribidi.sh

harfbuzz: crossfile
	bash scripts/22-harfbuzz.sh

libplacebo: crossfile
	bash scripts/24-libplacebo.sh

libass: crossfile freetype fribidi harfbuzz
	bash scripts/23-libass.sh

ffmpeg: fetch
	bash scripts/30-ffmpeg.sh

mpv: deps ffmpeg
	bash scripts/40-mpv.sh

verify: mpv
	bash scripts/50-verify.sh

clean:
	rm -rf build

distclean: clean
	rm -rf src prefix
