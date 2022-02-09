#!/usr/bin/env bash

#
USER_ID=$(id -u)

if [[ $USER_ID -ne 0 ]]; then
    echo "The script must be run as root"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

apt update
apt install wget ufw

chmod +x node_exporter.sh
chmod +x apache_exporter.sh

./node_exporter.sh
./apache_exporter.sh

systemctl daemon-reload

service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}
if service_exists apache_exporter; then
    systemctl enable apache_exporter
    systemctl start apache_exporter
fi

if service_exists node_exporter; then
    systemctl enable node_exporter
    systemctl start node_exporter
fi

ufw allow from 139.177.179.224 to any port 9100
ufw allow from 139.177.179.224 to any port 9117

echo "Node expoter is running on *:9100"
echo "Apache expoter is running on *:9117"
