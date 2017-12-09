# node-shim

[![Build Status](https://travis-ci.org/Hilzu/node-shim.svg?branch=master)](https://travis-ci.org/Hilzu/node-shim)

Shim node, npm and yarn binaries to use the correct version according to `engines` field in `package.json`. The file is found by traversing the current directory hierarchy up and the first one found is used. If no `package.json` is found or it doesn't have a version for the program the shims default to the global node, npm or yarn.

This app is a work in progress so a lot of features that you would expect are missing. Some known issues are:

- No Windows support ([#4](https://github.com/Hilzu/node-shim/issues/4))
- Only tilde and caret semver ranges are supported ([#7](https://github.com/Hilzu/node-shim/issues/7))
- node, npm and yarn have to be downloaded manually and be put to the correct location like `~/.local/opt/node-shim/yarn/1.1.0` ([#3](https://github.com/Hilzu/node-shim/issues/3))
- Global node, npm and yarn binaries are only searched from `/usr/local/bin` ([#2](https://github.com/Hilzu/node-shim/issues/2))

That said I've been able to completely replace `nvm` on my machine with node-shim. I hope you'll try it and tell me how it went!

## Installing

You can download the latest release from [GitHub releases](https://github.com/Hilzu/node-shim/releases). Extract the file and run the `install.sh` script. By default it copies the necessary files to `~/bin`. You can also install the app by running `make && make install`.

For the files to work you should have `~/bin` in your `$PATH` environment variable before paths that might have global node, npm or yarn binaries.

## Options

To enable debug logging to `stderr` you can set `NODE_SHIM_DEBUG` environment variable to `"true"`.

By default the program versions are searched from `~/.local/opt/node-shim`. To override it you can use the `NODE_SHIM_ROOT` environment variable.

## Building

Source code is available at [GitHub](https://github.com/Hilzu/node-shim).

```bash
# Install and init opam
# You can install opam with Homebrew on macOS
brew install opam
opam init

# Create a new opam switch with the correct compiler
opam switch node-shim --alias-of 4.06.0
eval `opam config env`

# Pin package
opam pin add node-shim . -n -y

# Install dependecies
opam install node-shim -t

# Compile everything and run tests
make

# Run executable
./main
```
