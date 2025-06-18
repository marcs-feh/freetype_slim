#!/usr/bin/env sh

build_mode="$1"

set -eu

Help(){
	echo "$0: [musl|glibc|containers]"
}

BuildMusl(){
	podman run --replace --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-musl:latest
	podman rm freetype_slim_builder
	podman unshare rm -rf freetype
}

BuildGlibc(){
	podman run --replace --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-glibc:latest
	podman rm freetype_slim_builder
	podman unshare rm -rf freetype
}

SetupContainers(){
	podman build -f Containerfile_linux_musl -t freetype-slim-linux-musl
	podman build -f Containerfile_linux_glibc -t freetype-slim-linux-glibc
}

case "$build_mode" in
	"musl") BuildMusl ;;
	"glibc") BuildGlibc ;;
	"containers") SetupContainers ;;
	*) Help && exit 1 ;;
esac
