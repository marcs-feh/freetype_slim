#!/usr/bin/env sh

build_mode="$1"

set -eu

Help(){
	echo "$0: [musl|glibc]"
}

BuildMusl(){
	podman build -f Containerfile_linux_musl -t freetype-slim-linux-musl
	podman run --replace --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-musl:latest
	podman rm freetype_slim_builder
	podman unshare rm -rf freetype
}

BuildGlibc(){
	podman build -f Containerfile_linux_glibc -t freetype-slim-linux-glibc
	podman run --replace --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-glibc:latest
	podman rm freetype_slim_builder
	podman unshare rm -rf freetype
}

case "$build_mode" in
	"musl") BuildMusl ;;
	"glibc") BuildGlibc ;;
	*) Help && exit 1 ;;
esac
