#!/bin/bash

cd "${0%/*}"

container_name="libqrcode_demo_build"
docker build -t $container_name -f Dockerfile ../ >&2
time docker run -i $container_name "$@"
