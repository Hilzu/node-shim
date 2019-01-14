#!/usr/bin/env bash

set -euo pipefail

cd "${0%/*}/.."

workdir='/opt/node-shim-build'
docker build -t node-shim-build --pull --build-arg workdir="${workdir}" .

container_id="$(docker create --entrypoint='sleep 1d' node-shim-build:latest)"

docker cp "${container_id}:${workdir}/_release/." _release/

docker rm -f "${container_id}"
