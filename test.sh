#!/usr/bin/env bash

#
read -p 'Installing node_exporter and apache_exporter. Do you want to continue? [y/n] ' -n 1 -r
printf '\n'
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

USER_ID=$(id -u)

if [[ $USER_ID -ne 0 ]]; then
    echo "The script must be run as root"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
