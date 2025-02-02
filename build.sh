#!/usr/bin/env sh
set -eu

# musl (nice)
# podman build -f Containerfile_linux_musl -t freetype-slim-linux-musl
# podman run --replace --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-musl:latest
# podman rm freetype_slim_builder
# podman unshare rm -rf freetype

# glibc (eww)
podman build -f Containerfile_linux_glibc -t freetype-slim-linux-glibc
podman run --replace --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-glibc:latest
podman rm freetype_slim_builder
podman unshare rm -rf freetype

