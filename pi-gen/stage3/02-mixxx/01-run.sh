#!/bin/bash -e

BUILD_DIR="${STAGE_WORK_DIR}/mixxx-build"
SRC_DIR="${STAGE_WORK_DIR}/mixxx-src"
MIXXX_VERSION="2.5.4"

apt install git -y
rm -rf $SRC_DIR || true
git clone --depth=1 --branch "$MIXXX_VERSION" https://github.com/mixxxdj/mixxx.git "$SRC_DIR"

# Install build dependencies
cd "$SRC_DIR"
sed -i 's/^[[:space:]]*sudo[[:space:]]\+//' tools/debian_buildenv.sh
tools/debian_buildenv.sh setup

# https://github.com/mixxxdj/mixxx/wiki/Compiling%20on%20Linux#ccache
ccache --set-config=max_size=20.0G
ccache -s

# Build the mixxx binary
mkdir -p "$BUILD_DIR"
cmake -DCMAKE_INSTALL_PREFIX="/usr/local" -S "$SRC_DIR" -B "$BUILD_DIR"
DESTDIR="$ROOTFS_DIR" cmake --build "$BUILD_DIR" --target install --parallel `nproc`

ccache -s
