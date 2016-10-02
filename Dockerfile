From centos:6

MAINTAINER shamaton

# define
ARG go_ver="1.7.1"

# root work
RUN yum update -y
RUN yum install -y sudo && \
    yum install -y git  && \
    yum install -y gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
RUN useradd -m -d /home/docker -s /bin/bash docker && echo "docker:docker" | chpasswd
RUN echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# update git
RUN cd /usr/local/src                                  && \
    git clone git://git.kernel.org/pub/scm/git/git.git && \
    cd git                                             && \
    make prefix=/usr/local all                         && \
    make prefix=/usr/local install                     && \
    yum remove -y git

# install golang
RUN curl -O https://storage.googleapis.com/golang/go${go_ver}.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go${go_ver}.linux-amd64.tar.gz

# change user docker
WORKDIR /home/docker
USER docker

# user work
ENV PATH $PATH:/usr/local/go/bin
RUN mkdir -p ${HOME}/.packages
ENV GOPATH /home/docker/.packages
