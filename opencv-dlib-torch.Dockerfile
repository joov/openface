# Note from Brandon on 2015-01-13:
#
#   Always push this from an OSX Docker machine.
#
#   If I build this on my Arch Linux desktop it works fine locally,
#   but dlib gives an `Illegal Instruction (core dumped)` error in
#   dlib.get_frontal_face_detector() when running on OSX in a Docker machine.
#   Building in a Docker machine on OSX fixes this issue and the built
#   container successfully deploys on my Arch Linux desktop.
#
# Building and pushing:
#   docker build -f opencv-dlib-torch.Dockerfile -t opencv-dlib-torch .
#   docker tag -f <tag of last container> bamos/ubuntu-opencv-dlib-torch:ubuntu_14.04-opencv_2.4.11-dlib_18.16-torch_2016.03.19
#   docker push bamos/ubuntu-opencv-dlib-torch:ubuntu_14.04-opencv_2.4.11-dlib_18.16-torch_2016.03.19

# does not currently work with ubuntu 16...
FROM joov/docker-rpi-ubuntu


MAINTAINER Johannes Wenzel <johannes.wenzel@web.de>

#RUN [ "cross-build-start" ]

RUN apt-get  --no-install-recommends update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    gfortran \
    git \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python-dev \
    python-numpy \
    python-protobuf\
    software-properties-common \
    sudo \
    zip \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install dependencies
#ADD install-deps.sh .
#ADD install-torch.sh .
#RUN ./install-deps.sh && \
#    ./install-torch.sh

RUN git clone https://github.com/torch/distro.git /torch --recursive
WORKDIR /torch
COPY simd.h pkg/torch/lib/TH/generic/simd/simd.h
RUN ./install-deps && \
    ./install.sh
WORKDIR ..


RUN cd ~ && \
    mkdir -p ocv-tmp && \
    cd ocv-tmp && \
    curl -L https://github.com/Itseez/opencv/archive/2.4.11.zip -o ocv.zip && \
    unzip ocv.zip && \
    cd opencv-2.4.11 && \
    mkdir release && \
    cd release && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_PYTHON_SUPPORT=ON \
          .. && \
   make -j8 && \
   make install && \
   rm -rf ~/ocv-tmp

RUN cd ~ && \
    mkdir -p dlib-tmp && \
    cd dlib-tmp && \
    curl -L \
         https://github.com/davisking/dlib/archive/v19.0.tar.gz \
         -o dlib.tar.bz2 && \
    tar xf dlib.tar.bz2 && \
    cd dlib-19.0/python_examples && \
    mkdir build && \
    cd build && \
    cmake ../../tools/python && \
   cmake --build . --config Release && \
   cp dlib.so /usr/local/lib/python2.7/dist-packages && \
   rm -rf ~/dlib-tmp
   
    
#RUN [ "cross-build-end" ]
