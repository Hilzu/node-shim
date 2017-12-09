#!/usr/bin/env bash

set -euo pipefail

VERSION=$(sed -n 's/^version: "\([0-9.]*\)"/\1/p' opam)

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
make

RELEASE_NAME="node-shim-${VERSION}-${PLATFORM}"
RELEASE_PATH="_release/$RELEASE_NAME"
rm -rf _release
mkdir -p "$RELEASE_PATH"
cp main scripts/install.sh LICENSE.txt README.md "$RELEASE_PATH"

mkdir "$RELEASE_PATH"/scripts
cp scripts/run-shim-template.sh "$RELEASE_PATH"/scripts/

cd _release
tar cvzf $RELEASE_NAME.tgz $RELEASE_NAME
