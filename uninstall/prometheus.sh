#!/bin/bash


systemctl stop prometheus.service
systemctl status prometheus.service

rm /usr/local/bin/prometheus
rm /usr/local/bin/promtool
rm -rf /etc/prometheus
rm -rf /etc/prometheus/{rules,rules.d,files_sd}  /var/lib/prometheus