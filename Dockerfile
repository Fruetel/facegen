FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# install basic dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    sudo git wget cmake nano vim gcc g++ build-essential ca-certificates software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# install python
RUN add-apt-repository ppa:deadsnakes/ppa \
&& apt-get update \
&& apt-get install -y python3.6 \
&& wget -O ./get-pip.py https://bootstrap.pypa.io/get-pip.py \
&& python3.6 ./get-pip.py \
&& ln -s /usr/bin/python3.6 /usr/local/bin/python3 \
&& ln -s /usr/bin/python3.6 /usr/local/bin/python

# install common python packages
RUN pip install pip setuptools -U \
&& pip install tensorflow-gpu==1.10.0 pillow==5.4.1 requests==2.21.0

ENV PYTHONPATH "${PYTHONPATH}:/app/stylegan/"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/cuda/lib64"

ENV CUDA_HOME=/usr/local/cuda

RUN groupadd -r app -g 1000
RUN useradd -u 1000 -r -g app -m -s /sbin/nologin app

WORKDIR /app

RUN git clone https://github.com/NVlabs/stylegan.git

COPY requirements.txt /app/
RUN pip3 install -r requirements.txt

COPY --chown=app:app . /app
