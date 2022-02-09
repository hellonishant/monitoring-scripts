#!/usr/bin/env bash

read -p 'Installing node_exporter. Do you want to continue? [y/n] ' -n 1 -r
printf '\n'
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

VERSION=1.3.1
cd /tmp || exit
NODE_EXPORTER="node_exporter-${VERSION}.linux-amd64"
wget "https://github.com/prometheus/node_exporter/releases/download/"v${VERSION}"/${NODE_EXPORTER}.tar.gz"

tar -xvf ${NODE_EXPORTER}.tar.gz
mv ${NODE_EXPORTER}/node_exporter /usr/local/bin/

useradd -rs /bin/false node_exporter
echo "[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl status node_exporter
systemctl enable node_exporter

echo "Node expoter is running on *:9100"
