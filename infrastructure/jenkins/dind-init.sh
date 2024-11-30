#!/bin/sh
docker network create my_network
exec dockerd-entrypoint.sh "$@"
