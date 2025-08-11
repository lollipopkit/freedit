#!/bin/sh

set -e

BIN_NAME="freedit"

cargo build --release

docker compose down --remove-orphans

image_id=$(docker images -q ${BIN_NAME})
if [ ! -z "$image_id" ]; then
  docker image rm -f $image_id
fi

docker build -t ${BIN_NAME}:latest --rm --force-rm .
docker compose up -d
