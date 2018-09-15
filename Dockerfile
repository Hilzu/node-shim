FROM ocaml/opam2:4.07

WORKDIR /opt/node-shim
RUN sudo chown opam:opam .

RUN sudo apt-get -qy update && sudo apt-get -qy install m4

COPY --chown=opam:opam node-shim.opam .
RUN opam install . --deps-only --with-test

COPY --chown=opam:opam . .
RUN eval $(opam env) && ./scripts/build-release.sh
