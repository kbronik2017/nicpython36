

FROM ubuntu:18.04

ENV TENSORFLOW_VERSION=2.1.0
ENV PYTORCH_VERSION=1.4.0
ENV TORCHVISION_VERSION=0.5.0
ENV MXNET_VERSION=1.6.0
MAINTAINER thisgithub
# Python 2.7 or 3.6 is supported by Ubuntu Bionic out of the box
ARG python=3.6
ENV PYTHON_VERSION=${python}

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-4.8 \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers

RUN if [[ "${PYTHON_VERSION}" == "3.6" ]]; then \
        apt-get install -y python${PYTHON_VERSION}-distutils; \
    fi
RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install TensorFlow, Keras, PyTorch and MXNet
RUN pip install future typing
RUN pip install numpy \
        tensorflow==${TENSORFLOW_VERSION} \
        keras \
        h5py
RUN pip install torch==${PYTORCH_VERSION} torchvision==${TORCHVISION_VERSION}
RUN pip install mxnet==${MXNET_VERSION}

# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-4.0.0.tar.gz && \
    tar zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi

# Install Horovod
RUN HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_MXNET=1 \
    pip install --no-cache-dir horovod

# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config


ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/${USER} 
    
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends sudo apt-utils && \
    apt-get install -y --no-install-recommends openssh-server \
        python3-tk python-dev python-numpy python-pip python-virtualenv python-scipy \
        bzip2 g++ git curl unzip graphviz libgl1-mesa-glx libhdf5-dev wget \
        libfreetype6-dev libhdf5-serial-dev libzmq3-dev pkg-config software-properties-common unzip \ 
        gcc gfortran libopenmpi-dev openmpi-bin openmpi-common openmpi-doc binutils && \
    apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER root

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda config --append channels conda-forge
   
ENV PATH /opt/conda/bin:$PATH
ENV PATH /opt/conda/envs/idp/bin:$PATH

RUN conda update conda

RUN conda config --append channels conda-forge
RUN conda install -y python=${python} && \
    # pip install --upgrade pip && \
    pip install \
      sklearn_pandas \
      h5py \
      MedPy \
      nibabel \
      Keras \
      numpy \
      scipy \
      Pillow \
      click \
      torch \
      mxnet \
      tensorflow && \
    conda install \
      bcolz \
      h5py \
      matplotlib \
      mkl \
      nose \
      notebook \
      pandas \
      pydot \
      pyyaml \
      scikit-learn \
      six \
      theano \
      mkdocs \
      && \
    git clone git://github.com/keras-team/keras.git /src && pip install -e /src[tests] && \
    pip install git+git://github.com/keras-team/keras.git && \
    conda clean -yt
    
  



# create a docker user
RUN useradd -ms /bin/bash docker
ENV HOME /home/docker

# copy necessary files to container
RUN mkdir $HOME/src
ENV PATH=/$HOME/src:${PATH}
ADD __init__.py $HOME/src/
ADD .theanorc $HOME/src/
# ADD .keras $HOME/src/
# RUN mkdir $HOME/src/.theanorc
# ENV PATH=/$HOME/src/.theanorc:${PATH}
# ADD .theanorc $HOME/src/.theanorc/
# RUN mkdir $HOME/src/.keras
# ENV PATH=/$HOME/src/.keras:${PATH}
# ADD .keras $HOME/src/.keras/
ADD app.py $HOME/src/
ADD cnn_scripts.py $HOME/src/
# ADD config $HOME/src/config
# ADD nets $HOME/src/nets
ADD libs $HOME/src/libs
ADD utils $HOME/src/utils
ADD ssh $HOME/src/ssh
ADD docker $HOME/src/docker
ADD logonic.png $HOME/src/
ADD nic_train_network_batch.py $HOME/src/
ADD nic_infer_segmentation_batch.py $HOME/src/
ADD tensorboardlogs $HOME/src/
# add permissions (odd)
# RUN chown docker -R nets
# RUN chown docker -R config 

USER docker
WORKDIR $HOME/src
