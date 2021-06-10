#!/bin/bash


cd /tmp
APACHE_EXPORTER=apache_exporter-0.8.0.linux-amd64
wget https://github.com/Lusitaniae/apache_exporter/releases/download/v0.8.0/${APACHE_EXPORTER}.tar.gz
tar xzf apache_exporter-0.8.0.linux-amd64.tar.gz
cd apache_exporter-0.8.0.linux-amd64/
cp apache_exporter /usr/local/bin/
chmod +x /usr/local/bin/apache_exporter

echo "[Unit]
Description=Prometheus
Documentation=https://github.com/Lusitaniae/apache_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/apache_exporter \
  --insecure \
  --scrape_uri=http://localhost/server-status/?auto \
  --telemetry.address=0.0.0.0:9117 \
  --telemetry.endpoint=/metrics

SyslogIdentifier=apache_exporter
Restart=always

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/apache_exporter.service
