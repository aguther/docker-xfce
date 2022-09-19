#!/usr/bin/env bash

# set version(s)
VERSION=centos-7-latest

# actions
SAVE=${SAVE:-0}
PUSH=${PUSH:-0}

# set container properties
IMAGE_NAME=docker-xfce
IMAGE_TAG="${VERSION}"
IMAGE=${IMAGE_NAME}:${IMAGE_TAG}
REGISTRY="${REGISTRY:-10.66.254.202:8084}"

# change to directory of this script
pushd $(cd -P -- "$(dirname -- "$0")" && pwd -P) 1>/dev/null

# restore directory on exit
trap "popd 1>/dev/null" EXIT

# clean up on error
trap "rm -rf *.tar.gz" SIGTERM SIGINT ERR

# start build of docker file
echo "Building docker image..."
docker build \
    --build-arg http_proxy="${http_proxy}" \
    --build-arg https_proxy="${https_proxy}" \
    --build-arg no_proxy="${no_proxy}" \
    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    --build-arg APPLICATION_VERSION=${VERSION_DEPENDENCY} \
    --file Dockerfile.centos.7 \
    --tag ${IMAGE} \
    .

# clean up files
rm -rf *.tar.gz *.zip

# save and compress docker image
if [ ${SAVE} -eq 1 ]; then
    docker save -o ${IMAGE_NAME}--"${IMAGE_TAG}".tar ${IMAGE}
    gzip -f ${IMAGE_NAME}--"${IMAGE_TAG}".tar
fi

# tag and push image
if [ ${PUSH} -eq 1 ]; then
    docker tag ${IMAGE} ${REGISTRY}/${IMAGE}
    docker push ${REGISTRY}/${IMAGE}
    docker rmi ${REGISTRY}/${IMAGE}
fi
