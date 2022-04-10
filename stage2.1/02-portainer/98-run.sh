#!/bin/bash -e

echo Reconfigure host system Docker data directory back to host data directory

# remove runtime docker service override
rm /run/systemd/system/docker.service.d/override.conf

# restart docker to apply service change
systemctl daemon-reload
systemctl restart docker
