Small build for FreeType, only including the essentials, available for linux.

Requires podman (although you can replace it with docker and alias it).

Run `./build.sh containers` to create the builder environments

You can then run `./build.sh musl` for the musl build or `./build.sh glibc` for
the glibc build.
