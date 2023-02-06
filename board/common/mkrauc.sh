#!/bin/sh

set -e

GIT_VERSION=$(git -C $BR2_EXTERNAL_INFIX_PATH describe --always --dirty --tags)

arch=$1
sign=$2

crt=$(ls $sign/*.crt)
key=$(ls $sign/*.key)

common=$(dirname $(readlink -f "$0"))

work=$BUILD_DIR/mkrauc
mkdir -p $work

cp -f $common/rauc-hooks.sh $work/hooks.sh

# RAUC internally uses the file extension to find a suitable install
# handler, hence the name must be .img
cp -f $BINARIES_DIR/rootfs.squashfs $work/rootfs.img
cp -f $BINARIES_DIR/rootfs.itbh $work/rootfs.itbh

cat >$work/manifest.raucm <<EOF
[update]
compatible=infix-${arch}
version=${GIT_VERSION}

[bundle]
format=verity

[hooks]
filename=hooks.sh

[image.rootfs]
filename=rootfs.img
hooks=post-install
EOF

rm -f $BINARIES_DIR/infix-$arch.pkg

rauc --cert=$crt --key=$key \
    bundle $work $BINARIES_DIR/infix-$arch.pkg
