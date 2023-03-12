# rtx-nodejs [![Build](https://github.com/jdxcode/rtx-nodejs/actions/workflows/workflow.yml/badge.svg)](https://github.com/jdxcode/rtx-nodejs/actions/workflows/workflow.yml)

Node.js plugin for [rtx](https://rtx.pub) version manager

## Install

After installing [rtx](https://github.com/jdxcode/rtx), install the plugin by running:

```bash
rtx plugin install nodejs
```

## Use

Check [rtx](https://rtx.pub) readme for instructions on how to install & manage 
versions of Node.js at a system and project level.

Behind the scenes, `rtx-nodejs` utilizes [`node-build`](https://github.com/nodenv/node-build) to install pre-compiled binaries and compile from source if necessary. You can check its [README](https://github.com/nodenv/node-build/blob/master/README.md) for additional settings and some troubleshooting.

When compiling a version from source, you are going to need to install [all requirements for compiling Node.js](https://github.com/nodejs/node/blob/master/BUILDING.md#building-nodejs-on-supported-platforms) (be advised that different versions might require different configurations). That being said, `node-build` does a great job at handling edge cases and compilations rarely need a deep investigation.

### Configuration

`node-build` already has a [handful of settings](https://github.com/nodenv/node-build#custom-build-configuration), in additional to that `rtx-nodejs` has a few extra configuration variables:

- `RTX_NODEJS_VERBOSE_INSTALL`: Enables verbose output for downloading and building. Any value 
  different from empty is treated as enabled.
- `RTX_NODEJS_FORCE_COMPILE`: Forces compilation from source instead of preferring pre-compiled 
  binaries
- `RTX_NODEJS_NODEBUILD_HOME`: Home for the node-build installation, defaults to 
  `$RTX_DATA_DIR/plugins/nodejs/.node-build`, you can install it in another place or share it with 
  your system
- `RTX_NODEJS_NODEBUILD`: Path to the node-build executable, defaults to 
  `$RTX_NODEJS_NODEBUILD_HOME/bin/node-build`
- `RTX_NODEJS_CONCURRENCY`: How many jobs should be used in compilation. Defaults to half the computer cores
- `NODEJS_ORG_MIRROR`: (Legacy) overrides the default mirror used for downloading the distibutions, alternative to the `NODE_BUILD_MIRROR_URL` node-build env var

### Integrity/signature check

In the past `rtx-nodejs` checked for signatures and integrity by querying live keyservers. `node-build`, on the other hand, checks integrity by precomputing checksums ahead of time and versioning them together with the instructions for building them, making the process a lot more streamlined.

### `.nvmrc` and `.node-version` support

rtx uses a `.tool-versions` file for auto-switching between software versions. To ease migration, you can have it read an existing `.nvmrc` or `.node-version` file to find out what version of Node.js should be used. 

### Running the wrapped node-build command

We provide a command for running the installed `node-build` command:

```bash
rtx nodejs nodebuild --version
```

### node-build advanced variations

`node-build` has some additional variations aside from the versions listed in `rtx ls-remote 
nodejs` (chakracore/graalvm branches and some others). As of now, we weakly support these variations. In the sense that they are available for install and can be used in a `.tool-versions` file, but we don't list them as installation candidates nor give them full attention.

Some of them will work out of the box, and some will need a bit of investigation to get them built. We are planning in providing better support for these variations in the future.

To list all the available variations run:

```bash
rtx nodejs nodebuild --definitions
```

_Note that this command only lists the current `node-build` definitions. You might want to [update the local `node-build` repository](#updating-node-build-definitions) before listing them._

### Manually updating node-build definitions

Every new node version needs to have a definition file in the `node-build` repository. `rtx-nodejs` already tries to update `node-build` on every new version installation, but if you want to update `node-build` manually for some reason we provide a command just for that:

```bash
rtx nodejs update-nodebuild
```

## Default npm Packages

`rtx-nodejs` can automatically install a set of default set of npm package right after installing a Node.js version. To enable this feature, provide a `$HOME/.default-npm-packages` file that lists one package per line, for example:

```
lodash
request
express
```

You can specify a non-default location of this file by setting a `RTX_NPM_DEFAULT_PACKAGES_FILE` variable.
