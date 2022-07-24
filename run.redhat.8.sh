#!/usr/bin/env bash

docker run \
    --detach \
    --rm \
    --env http_proxy=$http_proxy \
    --env https_proxy=$https_proxy \
    --env no_proxy="$no_proxy" \
    --publish 6080:6080 \
    --name docker-xfce \
    docker-xfce:redhat-8-latest
