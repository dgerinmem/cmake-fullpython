FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
RUN adduser --disabled-password --home /home/docker-build --uid 10000 --gecos ",,," builder
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt -y update
RUN apt -y install vim
RUN apt -y install apt-utils

# various utils
RUN apt -y install net-tools
RUN apt -y install dvipng texlive-latex-extra texlive ncftp
RUN apt -y install chrpath graphviz
RUN apt -y install doxygen
RUN apt -y install curl
RUN apt -y install wget
RUN apt install -y cmake cmake-gui ninja-build libncurses-dev autoconf gperf bison flex texinfo help2man gawk libtool-bin git git-gui libconfig++-dev libz-dev valgrind cmake-curses-gui libboost-thread-dev libboost-system-dev 


# cmake 3.12.1
RUN wget http://www.cmake.org/files/v3.12/cmake-3.12.1.tar.gz && tar xvf cmake-3.12.1.tar.gz && rm cmake-3.12.1.tar.gz && cd cmake-3.12.1 && ./configure && make -j 12 &&  make install
RUN curl https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh -o script.deb.sh
RUN bash script.deb.sh

# basic python on system
RUN apt -y install python3 lsb-release unzip
RUN apt -y install python3-pip
RUN apt -y install python3-dev
RUN apt -y install python-dev
RUN apt -y install python-setuptools
RUN apt -y install python3-venv
# required python3.7 sytem alternative install 
RUN apt -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
RUN apt -y install libffi-dev
RUN apt -y install liblzma-dev lzma
# RUN wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tar.xz && tar -xvf Python-3.7.10.tar.xz && cd Python-3.7.10 && ./configure && make &&  make altinstall
RUN wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz && tar -xzf Python-3.9.6.tgz && cd Python-3.9.6 && ./configure && make &&  make altinstall

# build and install pybind11 (rc1402_000)
RUN pip3.9 install --user pytest
ENV PB11_SOURCE_DIR=/pybind11
RUN git clone https://github.com/pybind/pybind11 ${PB11_SOURCE_DIR}
ENV CROSS_COMPILATION_TARGET=${CROSS_COMPILATION_TARGET:-x86}
ENV PB11_BUILD_DIR=/build/pybind11-${CROSS_COMPILATION_TARGET}
ENV PB11_INSTALL_DIR=/install/
RUN mkdir -p ${PB11_INSTALL_DIR} && mkdir -p ${PB11_BUILD_DIR} && cd ${PB11_BUILD_DIR} && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PB11_INSTALL_DIR} ${PB11_SOURCE_DIR} && make install
