#!/bin/bash

apt update
apt install wget

chmod +x node_exporter.sh
chmod +x apache_exporter.sh

./node_exporter.sh
./apache_exporter.sh

systemctl daemon-reload
systemctl enable node_exporter
systemctl enable apache_exporter

systemctl start node_exporter
systemctl status node_exporter

systemctl start apache_exporter
systemctl status apache_exporter

ufw allow from 139.177.179.224 to any port 9100
ufw allow from 139.177.179.224 to any port 9117

echo "Node expoter is running on *:9100"
echo "Apache expoter is running on *:9117"