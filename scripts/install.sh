#!/usr/bin/env bash

set -euo pipefail

cd "${0%/*}/.."

INSTALL_PATH=${INSTALL_PATH:-~/bin}
mkdir -p "$INSTALL_PATH"

if [ -f "bin/node-shim" ]; then
  cp -R "bin/" "${INSTALL_PATH}"
else
  cp -RL "_build/install/default/bin/" "${INSTALL_PATH}"
fi

for PROGRAM in node npm yarn
do
  TARGET="${INSTALL_PATH}/$PROGRAM"
  cp -f scripts/run-shim-template.sh "$TARGET"
  sed -i.bak "s/\\\$PROGRAM_PLACEHOLDER/$PROGRAM/" "$TARGET"
  rm "$TARGET.bak"
done
