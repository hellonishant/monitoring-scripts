#!/bin/bash

# Added system groups for prometheus
groupadd --system prometheus
useradd -s /sbin/nologin -r -g prometheus prometheus

# Download Prometheus in tmp
VERSION=2.33.1
PROMETHEUS="prometheus-${VERSION}.linux-amd64"

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/"v${VERSION}"/${PROMETHEUS}.tar.gz
tar xvzf "${PROMETHEUS}.tar.gz"

# Make directories for prometheus
mkdir -p /etc/prometheus/{rules,rules.d,files_sd} /var/lib/prometheus
cd ${PROMETHEUS}

# Copy binaries to bin
cp prometheus promtool /usr/local/bin/
cp -r consoles/ console_libraries/ /etc/prometheus/
chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
chmod -R 775 /etc/prometheus/ /var/lib/prometheus/
cp prometheus.yml /etc/prometheus/

# Make service file
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

" >/etc/systemd/system/prometheus.service

# Reload system services
systemctl daemon-reload

# Start prometheus
systemctl restart prometheus.service
systemctl status prometheus.service
