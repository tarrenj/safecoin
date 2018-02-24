#!/bin/sh

binaries=("safecoin-cli" "safecoind")

for binary in "${binaries[@]}";
do
    # find the dylibs to copy for safecoind
    DYLIBS=`otool -L src/$binary | grep "/usr/local" | awk -F' ' '{ print $1 }'`
    echo "copying $DYLIBS to $src"
    # copy the dylibs to the srcdir
    for dylib in $DYLIBS; do cp -rf $dylib src/; done

    # modify safecoind to point to dylibs
    echo "modifying $binary to use local libraries"
    for dylib in $DYLIBS; do install_name_tool -change $dylib @executable_path/`basename $dylib` src/$binary; done;
    chmod +x src/$binary
done
