all: main test

main: main.native

test: test.native

%.native:
	ocamlbuild -use-ocamlfind $@
	mv $@ $*

clean:
	rm -rf _build main test

install:
	scripts/install.sh

.PHONY: test default clean install
