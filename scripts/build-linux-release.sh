#!/usr/bin/env bash

set -euo pipefail

cd "${0%/*}/.."

docker build -t node-shim-build --pull .

container_id="$(docker create --entrypoint='sleep 1d' node-shim-build:latest)"

docker cp "${container_id}:/opt/node-shim/_release/." _release/

docker rm -f "${container_id}"
