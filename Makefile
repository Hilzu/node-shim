all: build test

build:
	dune build @install

test:
	dune runtest
	opam lint

clean:
	rm -rf _build _release

install: build
	scripts/install.sh

release: clean test
	scripts/build-release.sh

format:
	dune build @fmt --auto-promote

.PHONY: default clean install all test build release format
