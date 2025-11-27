#!/bin/bash

set -e

if [ -f ./.env ]; then
    echo "Loading environment variables from .env file"
    set -a
    source .env
    set +a
    env | grep 'HTTP_PROXY\|HTTPS_PROXY|TAG'  # Avoid printing sensitive info
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

# platformに載っている物をコンパイルできる
docker buildx ls --no-trunc
# NAME/NODE       DRIVER/ENDPOINT   STATUS    BUILDKIT   PLATFORMS
# default*        docker
#  \_ default      \_ default       running   v0.25.2    linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/arm/v7, linux/arm/v6
# Docker Host上で ```ls -l /proc/sys/fs/binfmt_misc```を実行すると```aarch64```があるはずとかなんとか
# WSL2@DockerDesktop > wsl -d docker-desktop ls -l /proc/sys/fs/binfmt_misc
# total 0
# -rw-r--r--    1 root     root             0 Nov 27 01:01 WSLInterop-late
# -rw-r--r--    1 root     root             0 Nov 27 01:01 aarch64
# -rw-r--r--    1 root     root             0 Nov 27 01:01 arm
# -rw-r--r--    1 root     root             0 Nov 27 01:01 mips64
# -rw-r--r--    1 root     root             0 Nov 27 01:01 mips64le
# -rw-r--r--    1 root     root             0 Nov 27 01:01 ppc64le
# -rw-r--r--    1 root     root             0 Nov 27 01:01 python3.12
# --w-------    1 root     root             0 Nov 27 01:01 register
# -rw-r--r--    1 root     root             0 Nov 27 01:01 riscv64
# -rw-r--r--    1 root     root             0 Nov 27 01:01 s390x
# -rw-r--r--    1 root     root             0 Nov 27 01:01 status
# WSL2@DockerDesktop > wsl -d docker-desktop cat /proc/sys/fs/binfmt_misc/aarch64
# docker-desktop:~# cat /proc/sys/fs/binfmt_misc/aarch64
# enabled
# interpreter /usr/bin/qemu-aarch64
# flags: POCF
# offset 0
# magic 7f454c460201010000000000000000000200b700
# mask ffffffffffffff00fffffffffffffffffeffffff
# ほんとだ！qemuだ！

docker buildx bake --print

# buildx bake (read from docker-bake.hcl , then build "default" target)
docker buildx bake --no-cache --progress=plain
# docker buildx bake --no-cache --progress=plain
# TAG=$TAGを指定しても良いが空文字ならエラーになる

docker image ls --tree

# これだと全部でる
docker buildx imagetools inspect mydebian:latest
docker image inspect mydebian:latest --platform arm64

echo run: docker run --rm -it mydebian:latest
echo run: docker run --rm -it --platform linux/amd64 mydebian:latest
echo run: docker run --rm -it --platform linux/arm64 mydebian:latest

# arm64を実行してみると。。。
# $ docker run --rm -it --platform linux/arm64 mydebian:latest
# Architecture: aarch64
# Platform: Linux