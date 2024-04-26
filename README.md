Build an image by specifying the "-b" option. E.g.
$ ./dockerhelper.bash -b -i my_dev_image -f ubuntu-jammy.Dockerfile  

Run a docker container with the image built above, using the right options. E.g.
```
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
```
