#!/bin/bash

container_name="libqrcode_demo_build"

docker build -t $container_name -f conan_demo.Dockerfile . >&2
time docker run -i $container_name "$@"
