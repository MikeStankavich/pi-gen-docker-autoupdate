#!/bin/bash -e

echo Reconfigure host system Docker data directory to /var/lib/docker in generated filesystem

# create runtime docker service override
mkdir -p /run/systemd/system/docker.service.d
cat <<EOF > /run/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -g ${ROOTFS_DIR}/var/lib/docker -H fd:// --containerd=/run/containerd/containerd.sock
EOF

# restart docker to apply override
systemctl daemon-reload
systemctl restart docker
