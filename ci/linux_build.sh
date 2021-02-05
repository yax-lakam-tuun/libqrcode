#!/bin/bash

cd "${0%/*}"

container_name="libqrcode_ci_build"

docker build -t $container_name -f linux.Dockerfile ../
time docker run $container_name
