# node-shim

[![Build Status](https://travis-ci.org/Hilzu/node-shim.svg?branch=master)](https://travis-ci.org/Hilzu/node-shim)

Shim node, npm and yarn binaries to use the correct version according to
`engines` field in `package.json`.

This app is a work in progress so a lot of features that you would expect are
missing. Some known issues are:

* No Windows support ([#4](https://github.com/Hilzu/node-shim/issues/4))
* No support for advanced semver ranges
  ([#7](https://github.com/Hilzu/node-shim/issues/7))
* Global node, npm and yarn binaries are only searched from `/usr/local/bin`
  ([#2](https://github.com/Hilzu/node-shim/issues/2))

That said I've been able to completely replace `nvm` on my machine with
node-shim. I hope you'll try it and tell me how it went!

## Installing

You can download the latest release from
[GitHub releases](https://github.com/Hilzu/node-shim/releases). Extract the file
and run the `install.sh` script. By default it copies the necessary files to
`~/bin`.

For the files to work you should have `~/bin` in your `$PATH` environment
variable before paths that might have global node, npm or yarn binaries.

After installation your node, npm and yarn binaries try to use the versions
defined in the `engines` field in a `package.json` file found by traversing up
in the file hierarchy. If no `package.json` with an `engines` field is found the
shims use global installation of the programs.

You can install new program versions with the `node-shim install` command:

```bash
node-shim install node 9.5.0
node-shim install yarn 1.3.2
```

## Environment variables

node-shim can be controlled with several environment variables.

### `NODE_SHIM_DEBUG`

To enable debug logging to `stderr` set this variable to `"true"`.

### `NODE_SHIM_ROOT`

Path where to look program versions from. Defaults to `~/.local/opt/node-shim`.

### `NODE_SHIM_$PROGRAM_VERSION`

Force `$PROGRAM` to resolve to certain version. For example to always use
version `1.3.2` of yarn set this environment variable:

```bash
export NODE_SHIM_YARN_VERSION=1.3.2
```

## Building

Source code is available at [GitHub](https://github.com/Hilzu/node-shim).

You need to install OPAM 2.0 using the instructions in the [documentation](https://opam.ocaml.org/doc/2.0/Install.html).

```bash
# Create a new local opam switch with the correct compiler
cd node-shim/
opam switch create . 4.07.0 --deps-only --with-test

# If you already have a local switch you can update it with
opam install . --deps-only --with-test

# Compile everything and run tests
make

# Run executable
./_build/install/default/bin/node-shim
```
