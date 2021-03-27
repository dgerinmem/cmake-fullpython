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

