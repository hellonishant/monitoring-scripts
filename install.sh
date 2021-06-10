#!/bin/bash

apt update
apt install wget

./node_exporter
./apache_exporter

systemctl daemon-reload
systemctl enable node_exporter
systemctl enable apache_exporter

systemctl start node_exporter
systemctl status node_exporter

systemctl start apache_exporter
systemctl status apache_exporter

echo "Node expoter is running on *:9100"
echo "Apache expoter is running on *:9104"