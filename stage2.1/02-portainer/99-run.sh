#!/bin/bash -e

echo Update paths in Docker config files
find ${ROOTFS_DIR}/var/lib/docker/containers -name config.v2.json -exec sed -i "s:${ROOTFS_DIR}/var/lib/docker:/var/lib/docker:g" {} \;
