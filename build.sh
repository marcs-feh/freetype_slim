#!/usr/bin/env sh
set -eu

# musl (nice)
podman build -f Containerfile_linux_musl -t freetype-slim-linux-musl
podman run --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-musl:latest
podman rm freetype_slim_builder
mv freetype_slim.zip freetype_slim_linux_musl.zip

# glibc (eww)
podman build -f Containerfile_linux_glibc -t freetype-slim-linux-glibc
podman run --name freetype_slim_builder -v $(pwd):/build freetype-slim-linux-glibc:latest
podman rm freetype_slim_builder
mv freetype_slim.zip freetype_slim_linux_glibc.zip


