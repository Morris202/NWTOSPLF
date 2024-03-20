#!/bin/bash

sudo hostnamectl set-hostname LinTichyC2

if [ "$#" -ne 2 ]; then
    echo "Verwendung: $0 <LAN_MAC> <OUTSIDE_MAC>"
    exit 1
fi

cat <<EOF | sudo tee /etc/netplan/00-installer-config.yaml > /dev/null
network:
  ethernets:
    lan:
      dhcp4: true
      match:
        macaddress: $1
      set-name: lan
    outside:
      dhcp4: true
      match:
        macaddress: $2
      set-name: outside
  version: 2
EOF

sudo netplan apply

echo "Konfiguration abgeschlossen."
