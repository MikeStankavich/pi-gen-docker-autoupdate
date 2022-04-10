#!/bin/bash -e

on_chroot << EOF
if [[ ! -f /usr/bin/docker ]]; then
echo Install docker
curl -fsSL https://get.docker.com | sh
systemctl enable docker
usermod -aG docker "$FIRST_USER_NAME"
else
echo Docker already installed
fi
EOF
