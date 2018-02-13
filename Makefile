all: build test

build:
	jbuilder build @install

test:
	jbuilder runtest

clean:
	rm -rf _build _release

install: build
	scripts/install.sh

.PHONY: default clean install all test build
