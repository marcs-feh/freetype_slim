#!/usr/bin/env sh

mkdir -p ./FreeType

mason setup --wipe ft_build \
	--default-library static \
	--prefix "$(pwd)/FreeType" \
	-Dharfbuzz=disabled \
	-Dbrotli=disabled \
	-Dbzip2=disabled \
	-Dmmap=disabled \
	-Dpng=disabled \
	-Dtests=disabled \
	-Dzlib=internal

ninja -j$(($(nproc) * 2)) -C ft_build install

