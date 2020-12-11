#!/bin/bash

container_name="libqrcode_ci_build"

docker build -t $container_name -f ci_build.Dockerfile .
time docker run $container_name
