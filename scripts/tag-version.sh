#!/usr/bin/env bash

set -euo pipefail

cd "${0%/*}/.."

VERSION=${1:-}

if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 version"
  exit 1
fi

sed -i.bak "s/^version: \"[0-9.]*\"/version: \"$VERSION\"/" node-shim.opam
rm node-shim.opam.bak
git commit -a -m "v$VERSION"
git tag -a "v$VERSION" -m "v$VERSION"
