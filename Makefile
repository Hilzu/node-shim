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

.PHONY: default clean install all test build
