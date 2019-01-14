#!/usr/bin/env bash

set -euo pipefail

cd "${0%/*}/.."

VERSION=$(sed -n 's/^version: "\([0-9.]*\)"/\1/p' node-shim.opam)

case "$OSTYPE" in
  darwin*) PLATFORM="macos64" ;;
  linux*)
    ARCHITECTURE="$(uname -m)"
    case "$ARCHITECTURE" in
      x86_64) PLATFORM="linux64" ;;
      i?86) PLATFORM="linux32" ;;
      *)
        echo "Unsupported architecture $ARCHITECTURE"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Unsupported platform $OSTYPE"
    exit 1
    ;;
esac

echo "Building release for version $VERSION and platform $PLATFORM"

make clean
dune build -p node-shim

RELEASE_NAME="node-shim-${VERSION}-${PLATFORM}"
RELEASE_PATH="_release/$RELEASE_NAME"

mkdir -p "$RELEASE_PATH"
cp LICENSE.txt README.md "$RELEASE_PATH"

mkdir "$RELEASE_PATH"/scripts
cp scripts/run-shim-template.sh scripts/install.sh "$RELEASE_PATH"/scripts/

mkdir "$RELEASE_PATH/bin"
cp _build/install/default/bin/* "$RELEASE_PATH/bin"

mkdir "$RELEASE_PATH/src"
cp -R bin lib test Makefile dune-project node-shim.opam "$RELEASE_PATH/src"

cd _release
tar cvzf $RELEASE_NAME.tgz $RELEASE_NAME
