.PHONY: all frozen latest fetch build check crossfile deps freetype fribidi harfbuzz libass libplacebo ffmpeg stub-libs mpv verify clean distclean help

all: frozen

help:
	@echo "make frozen    fetch frozen versions and build with stub libs (patches applied)"
	@echo "make latest    fetch latest versions and build WITHOUT patches (real libraries)"
	@echo "make fetch     fetch only, using the frozen versions.lock"
	@echo "make deps      cross-build freetype, fribidi, harfbuzz, libass, libplacebo"
	@echo "make ffmpeg    cross-build static ffmpeg"
	@echo "make mpv       build libmpv-2.dll"
	@echo "make verify    export/import checks plus WASAPI smoke test"
	@echo "make clean     remove build directory"
	@echo "make distclean remove build directory, sources and prefix"
	@echo ""
	@echo "frozen: ~7 MB DLL with audio-only stubs (no libass/swscale/fonts/libplacebo)"
	@echo "latest: ~13 MB DLL with real libraries - stub patches will NOT be applied"

frozen:
	@if [ -f latest.lock ]; then \
	    echo "refusing: latest.lock present - delete it (or run 'make latest') to build the frozen configuration" >&2; \
	    exit 1; \
	fi
	$(MAKE) fetch
	$(MAKE) build

latest:
	LATEST=1 $(MAKE) fetch
	$(MAKE) build

build: check crossfile deps ffmpeg stub-libs mpv verify

fetch:
	bash scripts/fetch-sources.sh

check:
	bash scripts/00-check-toolchain.sh

crossfile: check
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

ffmpeg:
	bash scripts/30-ffmpeg.sh

stub-libs: ffmpeg
	bash scripts/35-stub-libs.sh

mpv: deps ffmpeg stub-libs
	bash scripts/40-mpv.sh

verify: mpv
	bash scripts/50-verify.sh

clean:
	rm -rf build

distclean: clean
	rm -rf src prefix latest.lock
