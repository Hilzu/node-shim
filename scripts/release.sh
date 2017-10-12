#!/usr/bin/env bash

set -euo pipefail

VERSION=${1:-}

if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 version"
  exit 1
fi

make clean
make

RELEASE_NAME="node-shim-${VERSION}-macos"
RELEASE_PATH="_release/$RELEASE_NAME"
rm -rf _release
mkdir -p "$RELEASE_PATH"
cp main scripts/install.sh LICENSE.txt README.md "$RELEASE_PATH"

mkdir "$RELEASE_PATH"/scripts
cp scripts/run-shim-template.sh "$RELEASE_PATH"/scripts/

git tag -a $VERSION -m $VERSION

cd _release
tar -cvzf $RELEASE_NAME.tgz $RELEASE_NAME
