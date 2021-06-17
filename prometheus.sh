#!/bin/bash

groupadd --system prometheus
useradd -s /sbin/nologin -r -g prometheus prometheus

VERSION=prometheus-2.26.0.linux-amd64
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/${VERSION}.tar.gz
tar xvzf prometheus-2.26.0.linux-amd64.tar.gz

mkdir -p /etc/prometheus/{rules,rules.d,files_sd}  /var/lib/prometheus
cd ${VERSION}

cp prometheus promtool /usr/local/bin/
cp -r consoles/ console_libraries/ /etc/prometheus/
chown -R prometheus:prometheus /etc/prometheus/  /var/lib/prometheus/
chmod -R 775 /etc/prometheus/ /var/lib/prometheus/
cp prometheus.yml /etc/prometheus/

echo "[Unit]
Description=Prometheus systemd service unit
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/prometheus \\
--config.file=/etc/prometheus/prometheus.yml \\
--storage.tsdb.path=/var/lib/prometheus \\
--web.console.templates=/etc/prometheus/consoles \\
--web.console.libraries=/etc/prometheus/console_libraries \\
--web.listen-address=0.0.0.0:9090

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target

" > /etc/systemd/system/prometheus.service

systemctl daemon-reload

systemctl restart prometheus.service
systemctl status prometheus.service