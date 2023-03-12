#! /usr/bin/env bash

set -eu -o pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils.sh"

: "${RTX_NODEJS_NODEBUILD_HOME=$RTX_NODEJS_PLUGIN_DIR/.node-build}"
: "${RTX_NODEJS_CONCURRENCY=$(((${RTX_CONCURRENCY:-1} + 1) / 2))}"

# node-build environment variables being overriden by rtx-nodejs
export NODE_BUILD_CACHE_PATH="${NODE_BUILD_CACHE_PATH:-$RTX_NODEJS_CACHE_DIR/node-build}"

if [ "$NODEJS_ORG_MIRROR" ]; then
  export NODE_BUILD_MIRROR_URL="$NODEJS_ORG_MIRROR"
fi

if [[ "${RTX_NODEJS_CONCURRENCY-}" =~ ^[0-9]+$ ]]; then
  export MAKE_OPTS="${MAKE_OPTS:-} -j$RTX_NODEJS_CONCURRENCY"
  export NODE_MAKE_OPTS="${NODE_MAKE_OPTS:-} -j$RTX_NODEJS_CONCURRENCY"
fi

nodebuild="${RTX_NODEJS_NODEBUILD:-$RTX_NODEJS_NODEBUILD_HOME/bin/node-build}"
args=()

if ! [ -x "$nodebuild" ]; then
  printf "Binary for node-build not found\n"

  if ! [ "${RTX_NODEJS_NODEBUILD-}" ]; then
    printf "Are you sure it was installed? Try running \`rtx %s update-nodebuild\` to do a local update or install\n" "$(plugin_name)"
  fi

  exit 1
fi

if [ "${RTX_NODEJS_VERBOSE_INSTALL-}" ]; then
  args+=(-v)
fi

exec "$nodebuild" ${args+"${args[@]}"} "$@"
