#!/usr/bin/env sh

set -eu

mkdir -p ./ft_install
mkdir -p ./ft_build

meson setup ft_build \
	--default-library static \
	--prefix "$(pwd)/ft_install" \
	-Dharfbuzz=disabled \
	-Dbrotli=disabled \
	-Dbzip2=disabled \
	-Dmmap=disabled \
	-Dpng=disabled \
	-Dtests=disabled \
	-Dzlib=internal

ninja -v -j$(($(nproc) * 2)) -C ft_build install

mkdir ft_out
cp docs/FTL.TXT ft_out/LICENSE
cp -r ft_install/include/freetype2 ft_out

for lib in $(find ft_install -name '*.a'); do
	cp "$lib" ft_out
done

rm -f /build/freetype_slim.zip
mv ft_out freetype_slim
zip -r -9 freetype_slim.zip freetype_slim
mv freetype_slim.zip /build

