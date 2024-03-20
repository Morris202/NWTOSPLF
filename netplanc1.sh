#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Verwendung: $0 <DMZ_MAC> <OUTSIDE_MAC>"
    exit 1
fi 
 
sudo hostnamectl set-hostname LinTichyC1


cat <<EOF | sudo tee /etc/netplan/00-installer-config.yaml > /dev/null
network:
  ethernets:
    dmz:
      dhcp4: true
      match:
        macaddress: $1
      set-name: dmz
    outside:
      dhcp4: true
      match:
        macaddress: $2
      set-name: outside
  version: 2
EOF

sudo netplan apply

echo "Konfiguration abgeschlossen."
