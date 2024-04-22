##
## Dockerfile for building an image that can be used for Yocto builds
##
## Author: Rahul Anand
## Copyright (c) 2023 rahul.anand@gmail.com
##

FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

# Add repo for the right gcc
RUN apt-get update \
   && apt-get -y --quiet --no-install-recommends install software-properties-common

RUN add-apt-repository ppa:ubuntu-toolchain-r/test

# Now install the packages
RUN apt-get update \
   && apt-get -y --quiet --no-install-recommends install \
      automake \
      bison \
      build-essential \
      ccache \
      cpp-aarch64-linux-gnu \
      curl \
      dos2unix \
      flex \
      fontconfig \
      g++ \
      gcc \
      git \
      git-core \
      gitk \
      gnupg \
      gperf \
      lib32ncurses5-dev \
      lib32z1 \
      lib32z1-dev \
      lib32z-dev \
      libc6-dev-i386 \
      libgl1-mesa-dev \
      libncurses5 \
      libssl-dev \
      libx11-dev \
      libxml2-utils \
      make \
      openjdk-8-jdk \
      perl \
      pkg-config \
      tig \
      unzip \
      x11proto-core-dev \
      xsltproc \
      zip \
      zlib1g-dev \
      gawk \
      ssh \
      wget \
      python \
      diffstat \
      unzip \
      texinfo \
      chrpath \
      bzip2 \
      zip \
      cpio \
      bc \
      autoconf \
      libtool \
      curl \
      sudo \
      libxml-simple-perl \
      doxygen \
      vim \
      less \
      iputils-ping \
      cpp-aarch64-linux-gnu \
      gcc-aarch64-linux-gnu \
      git-lfs \
      net-tools \
      rsync \
      gpg-agent \
      lib32stdc++6 \
   && apt-get clean autoclean \
   && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
   && chmod a+x /usr/bin/repo \
   && echo "dash dash/sh boolean false" | debconf-set-selections \
   && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#      xmllint \

# Add a non-root user with the following details:
# username: user
# password: user
# Home dir: /home/user
# Groups   : sudo, user

RUN /usr/sbin/useradd -m -s /bin/bash -G sudo user \
  && echo user:user | /usr/sbin/chpasswd

# set default user to user when launch docker
USER user

