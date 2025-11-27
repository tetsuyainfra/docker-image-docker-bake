#!/bin/bash

set -e

if [ -f ./.env ]; then
    echo "Loading environment variables from .env file"
    set -a
    source .env
    set +a
fi
if [ $DEBUG == "1" ]; then
    set -x
fi

read -p "This script will DELETE ALL Docker images. Do you want to continue? (y/n): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Build process aborted."
    exit 1
fi

docker image prune -f -a

# normaly build
docker build -t docker-bake-example:latest \
    --build-arg HTTP_PROXY=${kHTTP_PROXY} \
    --build-arg HTTPS_PROXY=${HTTPS_PROXY} \
    -f src/Dockerfile \
    ./src

docker image ls