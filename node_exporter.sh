#!/bin/bash


cd /tmp
NODE_EXPORTER=node_exporter-1.1.2.linux-amd64
wget "https://github.com/prometheus/node_exporter/releases/download/v1.1.2/${NODE_EXPORTER}.tar.gz"

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
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl status node_exporter
systemctl enable node_exporter

echo "Node expoter is running on *:9100"