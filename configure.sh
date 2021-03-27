set -ex

CWD=`realpath $(dirname $0)`
INSTALL=${CWD}/install
mkdir -p ${INSTALL}

# cmake 3.12.1
wget http://www.cmake.org/files/v3.12/cmake-3.12.1.tar.gz && tar xvf cmake-3.12.1.tar.gz && rm cmake-3.12.1.tar.gz && cd cmake-3.12.1 && ./configure && make -j 12 && make install
curl https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh -o script.deb.sh
bash script.deb.sh

# basic python on system
apt -y install python3 lsb-release unzip
apt -y install python3-pip
apt -y install python3-dev
apt -y install python-dev
apt -y install python-setuptools
apt -y install python3-venv

# required python3.7 sytem alternative install 
apt -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
apt -y install libffi-dev
apt -y install liblzma-dev lzma
wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tar.xz && tar -xvf Python-3.7.10.tar.xz && cd Python-3.7.10 && ./configure && make && make altinstall

# build and install pybind11 (rc1402_000)
pip3 install --user pytest

PB11_SOURCE_DIR=${CWD}/pybind11
[ ! -d ${PB11_SOURCE_DIR}] && git clone https://github.com/pybind/pybind11

CROSS_COMPILATION_TARGET=${CROSS_COMPILATION_TARGET:-x86}
PB11_BUILD_DIR=${CWD}/build/pybind11-${CROSS_COMPILATION_TARGET}
PB11_INSTALL_DIR=${INSTALL}/pybind11

mkdir -p ${PB11_INSTALL_DIR}
mkdir -p ${PB11_BUILD_DIR}
cd ${PB11_BUILD_DIR}

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${PB11_INSTALL_DIR} \
      ${PB11_SOURCE_DIR}

make install -j 8
