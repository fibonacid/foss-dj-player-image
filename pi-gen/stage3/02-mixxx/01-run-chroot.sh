#!/usr/bin/env bash

echo ""
echo "=========================="
echo "Building mixxx from source"
echo "=========================="
echo ""

git clone --branch 2.5.4 --depth 1 https://github.com/mixxxdj/mixxx.git
cd mixxx
tools/debian_buildenv.sh setup
mkdir build
cd build
cmake ..
cmake --build . --target install --parallel `nproc`

echo ""
echo "=========================="
echo "Finished Building mixxx   "
echo "=========================="
echo ""
