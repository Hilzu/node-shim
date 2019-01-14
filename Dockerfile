FROM ocaml/opam2:4.07
ARG workdir

WORKDIR $workdir
RUN sudo chown opam:opam .

RUN sudo apt-get -qqy update && sudo apt-get -qqy install m4

COPY --chown=opam:opam node-shim.opam .
RUN opam repository add remote https://opam.ocaml.org
RUN opam update
RUN opam install . --deps-only --with-test

COPY --chown=opam:opam . .
RUN eval $(opam env) && make release
