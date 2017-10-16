#!/usr/bin/env bash

set -euo pipefail

INSTALL_PATH=~/bin

cp main "${INSTALL_PATH}/node-shim"
for PROGRAM in node npm yarn
do
  TARGET="${INSTALL_PATH}/$PROGRAM"
  cp scripts/run-shim-template.sh "$TARGET"
  sed -i.bak "s/\\\$PROGRAM_PLACEHOLDER/$PROGRAM/" "$TARGET"
  rm "$TARGET.bak"
done
