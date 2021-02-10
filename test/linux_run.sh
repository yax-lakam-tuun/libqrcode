#!/bin/bash -ex

cd "${0%/*}"

container_name="libqrcode_test_build"
docker build -t $container_name -f linux.Dockerfile ../
time docker run --rm $container_name
