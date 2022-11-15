FROM nvidia/cuda:11.3.1-devel-ubuntu18.04

ENV PYTHON_VERSION=3.8.15

RUN echo "Installing apt packages..." \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt -y update --no-install-recommends \
	&& apt -y install --no-install-recommends \
  wget \
  git \
  build-essential \
  checkinstall \
  libssl-dev \
  libffi-dev \
  libsqlite3-dev \
  libgdbm-dev \
  zlib1g-dev \
	libc6-dev \
	libbz2-dev \
  liblzma-dev \
  libglew-dev \
  libglfw3-dev \
  libeigen3-dev \
  tk-dev \
	&& apt autoremove -y \
	&& apt clean -y \
	&& export DEBIAN_FRONTEND=dialog

RUN echo "Installing Python ver. ${PYTHON_VERSION}..." \
	&& cd /opt \
	&& wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
	&& tar xzf Python-${PYTHON_VERSION}.tgz \
	&& cd ./Python-${PYTHON_VERSION} \
	&& ./configure --enable-optimizations \
	&& make \
	&& checkinstall

RUN echo "Installing torch packages..." \
  && python3 -m pip install -U pip setuptools \
  && pip3 --no-cache-dir install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

ENV TCNN_CUDA_ARCHITECTURES=61;86

RUN echo "Installing tiny-cuda-nn..." \
  && pip3 install git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch

RUN echo "Installing Nerfstudio..." \
  && cd /opt \
  && git clone https://github.com/nerfstudio-project/nerfstudio.git \
  && cd nerfstudio \
  && pip3 install -e .
