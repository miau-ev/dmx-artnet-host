#!/usr/bin/env bash
set -e

echo [1/6] Installing Dependencies...
sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        git \
        build-essential \
        pigpio
echo Done

echo [2/6] Installing Node.JS...
current=$(pwd)
mkdir -p /tmp/nodejs
cd /tmp/nodejs
wget https://nodejs.org/dist/v8.11.1/node-v8.11.1-linux-armv6l.tar.xz
tar -xvf node-v8.11.1-linux-armv6l.tar.xz
cd node-v8.11.1-linux-armv6l
sudo cp -r bin /usr/local/
sudo cp -r include /usr/local/
sudo cp -r lib /usr/local/
sudo cp -r share /usr/local/
cd $current
echo Done

echo [3/6] Installing gpio-artnet-node...
git clone https://github.com/maxjoehnk/gpio-artnet-node.git
cd gpio-artnet-node
npm i
cd $current
echo Done

echo [4/6] Installing udmx-artnet-bridge...
npm i -g udmx-artnet-bridge
echo Done

echo [5/6] Setting up Systemd Services...
cp gpio-artnet-node.service /lib/systemd/system/
cp udmx-artnet-bridge.service /lib/systemd/system/
echo Done

echo [6/6] Activating Services...
sudo systemctl enable gpio-artnet-node
sudo systemctl enable udmx-artnet-bridge
sudo systemctl start gpio-artnet-node
sudo systemctl start udmx-artnet-bridge
echo Done
