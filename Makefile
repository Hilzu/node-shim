all: main test

main: main.native

test: test.native
	./test

%.native:
	ocamlbuild -use-ocamlfind $@
	mv $@ $*

clean:
	rm -rf _build _release main test

install:
	scripts/install.sh

.PHONY: default clean install all
