#!/usr/bin/env sh

WorkerCount=$(($(nproc) * 2))

export NINJA_OPTIONS="-j=$WorkerCount"

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

# Patch wrap files
jmpBack="$(pwd)"

cd subprojects
# NOTE: Not used, but useful if you enabled harfbuzz support
sed "s,#(SUBPROJECT_DIR),file://$(pwd)," harfbuzz.wrap.template > harfbuzz.wrap
sed "s,#(SUBPROJECT_DIR),file://$(pwd)," zlib.wrap.template > zlib.wrap
cd "$jmpBack"

# Create build dir and compile
mkdir -p ./ft_install
mkdir -p ./ft_build

# meson setup ft_build \
# 	--default-library static \
# 	--buildtype minsize \
# 	--prefix "$(pwd)/ft_install" \
# 	-Dharfbuzz=disabled \
# 	-Dbrotli=disabled \
# 	-Dbzip2=disabled \
# 	-Dmmap=disabled \
# 	-Dpng=disabled \
# 	-Dtests=disabled \
# 	-Dzlib=internal

cmake -B ft_build -GNinja \
	-D CMAKE_INSTALL_PREFIX=$(pwd)/ft_install \
	-D CMAKE_BUILD_TYPE=MinSizeRel \
	-D CMAKE_BUILD_SHARED_LIBS=false \
	-D FT_DISABLE_ZLIB=TRUE \
	-D FT_DISABLE_BZIP2=TRUE \
	-D FT_DISABLE_PNG=TRUE \
	-D FT_DISABLE_HARFBUZZ=TRUE \
	-D FT_DISABLE_BROTLI=TRUE \

ninja -v -j$WorkerCount -C ft_build install

# Package it out
mkdir ft_out
cp docs/FTL.TXT ft_out/LICENSE
cp -r ft_install/include/freetype2 ft_out

for lib in $(find ft_install -name '*.a'); do
	strip "$lib"
	cp "$lib" ft_out
done

rm -f /build/$OutputFile.zip
mv ft_out $OutputFile
zip -r -9 $OutputFile.zip $OutputFile
mv $OutputFile.zip /build
rm -rf freetype

