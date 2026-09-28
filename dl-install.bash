#!/bin/bash
set -e
SYS_ARCH=$(uname -m)
echo "=== Initializing Workspace ==="
mkdir -p /tmp/zram-install
cd /tmp/zram-install
echo "=== Downloading Latest overlayfs-tools ==="
curl -s https://api.github.com/repos/reukiodo/overlayfs-tools/releases/latest | grep "browser_download_url.*${SYS_ARCH}*deb" | cut -d '"' -f 4 | grep -v -E "tar|dbg" | wget -qi -
echo "=== Downloading Latest zram-config ==="
curl -s https://api.github.com/repos/reukiodo/zram-config/releases/latest | grep "browser_download_url.*deb" | cut -d '"' -f 4 | grep -v  -E "tar|dbg" | wget -qi -
echo "=== Executing Parallel APT Package Installation ==="
sudo apt-get update
sudo apt-get install -y ./*.deb
echo "=== Installation Completed Successfully! ==="
