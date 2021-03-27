#!/bin/bash
set -ex
TOP=`realpath $(dirname $0)`
build=${TOP}/testsbuild

[ ! -d ${build}  ] && mkdir -p ${build}
cd ${build}
cmake ${TOP}/tests
mkdir -p ${TOP}/tests/install
make
cd ${TOP}
