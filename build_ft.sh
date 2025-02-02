#!/usr/bin/env sh

OutputFile="$1"
[ -z "$OutputFile" ] && {
	echo 'You need to provide an output file'
	exit 1
}

set -eu

# Unzip freetype
rm -rf freetype
unzip FreeType-v2.13.3.zip
mv FreeType-v2.13.3 freetype
cd freetype

# Apply meson patch
Patcher="patch"

$Patcher --help ||
	Patcher='busybox patch'

$Patcher meson.build ../fix_meson.patch

# Patch wrap files
jmpBack="$(pwd)"

cd subprojects
sed "s,#(SUBPROJECT_DIR),file://$(pwd)," harfbuzz.wrap.template > harfbuzz.wrap
sed "s,#(SUBPROJECT_DIR),file://$(pwd)," zlib.wrap.template > zlib.wrap
cd "$jmpBack"

# Create build dir and compile
mkdir -p ./ft_install
mkdir -p ./ft_build

meson setup ft_build \
	--default-library static \
	--buildtype minsize \
	--prefix "$(pwd)/ft_install" \
	-Dharfbuzz=enabled \
	-Dbrotli=disabled \
	-Dbzip2=disabled \
	-Dmmap=disabled \
	-Dpng=disabled \
	-Dtests=disabled \
	-Dzlib=internal

ninja -v -j$(($(nproc) * 2)) -C ft_build install

# Package it out
mkdir ft_out
cp docs/FTL.TXT ft_out/LICENSE
cp -r ft_install/include/freetype2 ft_out

for lib in $(find ft_install -name '*.a'); do
	cp "$lib" ft_out
done

rm -f /build/$OutputFile.zip
mv ft_out $OutputFile
zip -r -9 $OutputFile.zip $OutputFile
mv $OutputFile.zip /build
rm -rf freetype

