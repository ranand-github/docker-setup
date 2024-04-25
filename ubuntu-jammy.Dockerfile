##
## Dockerfile for building an image that can be used for Yocto builds
##
## Author: Rahul Anand
## Copyright (c) 2024 rahul.anand@gmail.com
##

FROM ubuntu:jammy
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
   && apt-get -y --quiet --no-install-recommends install software-properties-common

# Now install the packages
RUN apt-get update \
   && apt-get -y --quiet --no-install-recommends install \
      gawk \
      wget \
      git-core \
      diffstat \
      unzip \
      texinfo \
      gcc \
      build-essential \
      chrpath \
      socat \
      cpio \
      python3 \
      python3-pip \
      python3-pexpect \
      xz-utils \
      debianutils \
      iputils-ping \
      python3-git \
      python3-jinja2 \
      libegl1-mesa \
      libsdl1.2-dev \
      python3-subunit \
      mesa-common-dev \
      zstd \
      liblz4-tool \
      file \
      locales \
      bzip2 \
      zip \
      xz-utils \
      bc \
      libtool \
      wget \
      curl \
      sudo \
      vim \
      less \
      iputils-ping \
      ssh \
      gpg-agent \
   && apt-get clean autoclean \
   && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
   && chmod a+x /usr/bin/repo \
   && echo "dash dash/sh boolean false" | debconf-set-selections \
   && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Add a non-root user with the following details:
# username: user
# password: user
# Home dir: /home/user
# Groups   : sudo, user

RUN /usr/sbin/useradd -m -s /bin/bash -G sudo user \
  && echo user:user | /usr/sbin/chpasswd

# set defualt user to user when launch docker
USER user

