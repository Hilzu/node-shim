# node-shim

Shim node, npm and yarn binaries to use the correct version according to `engines` field in `package.json`. The file is found by traversing the current directory hierarchy up and the first one found is used. If no `package.json` is found or it doesn't have a version for the program the shims default to the global node, npm or yarn.

This app is a work in progress so a lot of features that you would expect are missing. Some known issues are:

- Has only been tested on macOS (might work on Linux)
- Semver ranges aren't supported (range is discarded and the exact version specified is used)
- node, npm and yarn have to be downloaded manually and be put to the correct location like `~/.local/opt/node-shim/yarn/1.1.0`
- Global node, npm and yarn binaries are only searched from `/usr/local/bin`

That said it works pretty well for me right now but might not work for you yet.

To enable debug logging to `stderr` you can set `NODE_SHIM_DEBUG` environment variable to `"true"`.

## Installing

You can download the latest release from [GitHub releases](https://github.com/Hilzu/node-shim/releases). Extract the file and run the `install.sh` script. By default it copies the necessary files to `~/bin`. You can also install the app by running `make && make install`.

For the files to work you should have `~/bin` in your `$PATH` environment variable before paths that might have global node, npm or yarn binaries.

## Building

Source code is available at [GitHub](https://github.com/Hilzu/node-shim). To build it you need:

- OCaml 4.05.0
- Make 3.81
- OCamlbuild 0.11.0
- OPAM 1.2.2
    - yojson 1.4.0

Other versions of the dependencies might work but the app has been developed with the ones above.

With all of the above installed you can build the app by running `make` in the app root directory. An executable called `main` should be created in the root.

Building might be possible on Linux but it has only been tested on macOS for now.
