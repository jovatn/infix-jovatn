#!/bin/sh

GIT_VERSION=$(git -C $BR2_EXTERNAL_INFIX_PATH describe --always --dirty --tags)

# This is a symlink to /usr/lib/os-release, so we remove this to keep
# original Buildroot information.
rm "$TARGET_DIR/etc/os-release"
{
	echo "NAME=\"Inf/IX\""
	echo "VERSION=${GIT_VERSION}"
	echo "ID=infix"
	echo "VERSION_ID=${GIT_VERSION}"
	echo "PRETTY_NAME=\"Inf/IX by KernelKit\""
	echo "HOME_URL=https://github.com/KernelKit"
} > "$TARGET_DIR/etc/os-release"

echo "Inf/IX by KernelKit $GIT_VERSION -- $(date +"%b %e %H:%M %Z %Y")" > "$TARGET_DIR/etc/version"
