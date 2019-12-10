prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/xcodebuild-to-md" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcodebuild-to-md"

clean:
	rm -rf .build

.PHONY: build install uninstall clean