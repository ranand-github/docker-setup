#!/bin/bash
##
## Build and/or run a docker image.
## I have tested this for doing a Yocto builds on Ubuntu
##
## Author: Rahul Anand
## Copyright (c) 2024 rahul.anand@gmail.com
##

function printUsage() {
    cat <<EOF
Build an image by specifying the "-b" option. E.g.
$ ./dockerhelper.bash -b -i my_dev_image -f ubuntu-jammy.Dockerfile  

Run a docker container with the image built above, using the right options. E.g.
$ ./dockerhelper.bash -r -i my_dev_image -d /opt/data/workspace

Usage: $(basename $0) [OPTIONS]
OPTIONS:
  -h: Help
  -b: Build a docker image
  -r: Run a docker image
  -f <filename>: The dockerfile to build the image from. Use with -b
  -d <name>: The directory from host to mount inside the docker. Use with -r
               Example: 
               "-d /opt/data/workspace" makes "/opt/data/workspace" from the host file system 
               to "/opt/data/workspace" inside the docker. This enables host and guest to share
               files
  -i <name>: The name of the docker image to build or to run. Use with -b or -r
EOF
    exit 1
}

optDir=
optImg=
optBuild=
optRun=
optDockerFile=

while getopts 'hbrf:d:i:' opt
do
    case $opt in
	h)
	    printUsage
	    ;;
	b)
	    optBuild=1
	    ;;
	r)
	    optRun=1
	    ;;
	f)
	    optDockerFile="$OPTARG"
	    ;;
	d)
	    optDir="$OPTARG"
	    ;;
	i)
	    optImg="$OPTARG"
	    ;;
	*)
	    printUsage
	    ;;
    esac
done

function checkPermissions() {
    # Check if we're in the right group
    re=" docker(\s|$)"
    if [[ ! " $(groups)" =~ $re ]]
    then
	echo "[ERROR] You are not in right group to run docker commands without sudo"
	echo "        Please add yourself to the \"docker\" group (see below) and try again"
	echo "           > sudo usermod -aG docker ${USER}"
	echo "        Then log out and log back in and re-run"
	exit 1
    fi
}

function doDockerRun() {
    checkPermissions
    docker run \
	   -it \
	   --net=host \
	   --mount "type=bind,src=${optDir},dst=${optDir}" \
	   --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
	   --cap-add=SYS_ADMIN \
	   --security-opt apparmor:unconfined \
	   --env="DISPLAY" \
	   -u user \
	   -w ${optDir} ${optImg} /bin/bash 
    exit 0
}

function doDockerBuild() {
    checkPermissions
    docker build -t ${optImg} -f ${optDockerFile} .
    status=$?
    if [ ${status} == 0 ]
    then
	echo "[INFO] Built docker image with file: ${optDockerFile} and name: ${optImg}"
    fi
    exit 0
}

if [ -z ${optImg} ]
then
    echo "[ERROR] Required argument for docker image name: -i"
    exit 1
fi

if [ -z ${optBuild} ] && [ -z ${optRun} ]
then
    echo "[ERROR] Either -b (build docker image) or -r (run docker image) should be provided"
    exit 1
fi

if [ ! -z ${optBuild} ]
then
    if [ -z ${optDockerFile} ]
    then
	echo "[ERROR] No docker file specified (-f) for building (-b)"
	exit 1
    fi
    doDockerBuild
fi

if [ ${optRun} == 1 ]
then
    if [ -z ${optDir} ]
    then
	echo "[ERROR] Required argument for directory to mount: -d"
	exit 1
    fi
    doDockerRun
fi



