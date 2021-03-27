#!/bin/bash
set -ex
TOP=`realpath $(dirname $0)`
build=${TOP}/testsbuild

[ ! -d ${build}  ] && mkdir -p ${build}
cd ${build}

# build tests
cmake ${TOP}/tests
mkdir -p ${TOP}/tests/install
make
cd ${TOP}

# test tests : perform basic execution of python
# to check installed packages defined in requirements.txt, 
# cmakeHook.py installation and cpython *.so installation

# test cmakeHook
./tests/install/venv-main/bin/python -c "import cmakeHook;print(cmakeHook.hello)"

# test requirements
./tests/install/venv-main/bin/python -c "import tensorflow"
./tests/install/venv-main/bin/python -c "import onnx"
./tests/install/venv-main/bin/python -c "import torch"

# test cpython test case (pybind11)
./tests/install/venv-main/bin/python -c 'import mainCpython;print(mainCpython.hello)'
