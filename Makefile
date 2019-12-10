prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/xcodebuild-to-md" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcodebuild-to-md"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
