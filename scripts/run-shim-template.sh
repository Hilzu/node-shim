#!/usr/bin/env bash

set -euo pipefail

exec node-shim-run $PROGRAM_PLACEHOLDER -- "$@"
