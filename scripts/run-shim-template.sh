#!/usr/bin/env bash

set -euo pipefail

exec node-shim $PROGRAM_PLACEHOLDER -- "$@"
