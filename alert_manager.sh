#!/usr/bin/env bash

read -p 'Installing node_exporter. Do you want to continue? [y/n] ' -n 1 -r
printf '\n'
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

VERSION=0.23.0

# Extract package and add binaries
cd /opt/ || exit
wget https://github.com/prometheus/alertmanager/releases/download/"v${VERSION}"/"alertmanager-${VERSION}.linux-amd64.tar.gz"
tar -xvzf "alertmanager-${VERSION}.linux-amd64.tar.gz"
mv "alertmanager-${VERSION}.linux-amd64"/alertmanager /usr/local/bin/

# Make configuration directories
mkdir /etc/alertmanager/

# Write configurations
echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: alertmanager-discord
spec:
  selector:
    matchLabels:
      app: alertmanager-discord
  replicas: 1
  template:
    metadata:
      labels:
        app: alertmanager-discord
    spec:
      containers:
      - name: alertmanager-discord
        image: benjojo/alertmanager-discord
        resources:
          limits:
            memory: \"128Mi\"
            cpu: \"500m\"
        ports:
        - containerPort: 9094
        env:
          - name: DISCORD_WEBHOOK
            value: {{ .Values.webhookURL }}
---
apiVersion: v1
kind: Service
metadata:
  name: alertmanager-discord
spec:
  selector:
    app: alertmanager-discord
  ports:
  - port: 9094
    targetPort: 9094
  type: ClusterIP
---
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: alertmanager
spec:
  receivers:
  - name: discord
    webhookConfigs:
    - url: 'http://alertmanager-discord:9094'
      sendResolved: true
" >/etc/alertmanager/alertmanager.yml
