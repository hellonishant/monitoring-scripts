#!/usr/bin/env bash

read -p 'Installing apache_exporter. Do you want to continue? [y/n] ' -n 1 -r
printf '\n'
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

VERSION=0.11.0
APACHE_EXPORTER="apache_exporter-${VERSION}.linux-amd64"

# Download apache exporter
cd /tmp || exit
wget https://github.com/Lusitaniae/apache_exporter/releases/download/"v${VERSION}"/"${APACHE_EXPORTER}.tar.gz"
tar xzf "$APACHE_EXPORTER.tar.gz"
cd "$APACHE_EXPORTER" || exit
cp apache_exporter /usr/local/bin/
chmod +x /usr/local/bin/apache_exporter

# Create a service file
useradd -rs /bin/false apache_exporter
echo "[Unit]
Description=Prometheus
Documentation=https://github.com/Lusitaniae/apache_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=apache_exporter
Group=apache_exporter
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/apache_exporter \\
  --insecure \\
  --scrape_uri=http://localhost/server-status/?auto \\
  --telemetry.address=0.0.0.0:9117 \\
  --telemetry.endpoint=/metrics

SyslogIdentifier=apache_exporter
Restart=always

[Install]
WantedBy=multi-user.target
" >/etc/systemd/system/apache_exporter.service
