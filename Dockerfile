FROM joov/rpi-opencv-dlib-torch
MAINTAINER Johannes Wenzel <johannes.wenzel@web.de>

# TODO: Should be added to opencv-dlib-torch image.
RUN ln -s /root/torch/install/bin/* /usr/local/bin

RUN apt-get install -y \
    curl \
    git \
    graphicsmagick \
    python-dev \
    python-pip \
    python-numpy \
    python-nose \
    python-scipy \
    python-pandas \
    python-protobuf\
    wget \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /root/openface
RUN cd ~/openface && \
    ./models/get-models.sh && \
    pip2 install -r requirements.txt && \
    python2 setup.py install && \
    pip2 install -r demos/web/requirements.txt && \
    pip2 install -r training/requirements.txt


# Post installation tasks to make it run on rpi

COPY convert.lua .
RUN /torch/install/bin/luarocks install dpnn && \
    wget http://openface-models.storage.cmusatyalab.org/nn4.small2.v1.ascii.t7.xz && \
   unxz nn4.small2.v1.ascii.t7.xz && \
   /torch/install/bin/th convert.lua nn4.small2.v1.ascii.t7 nn4.small2.v1.t7 && \
   mv nn4.small2.v1.t7 /root/openface/models/openface/ && \
   rm nn4.small2.v1.ascii.t7 


EXPOSE 8000 9000
CMD /bin/bash -l -c '/root/openface/demos/web/start-servers.sh'
