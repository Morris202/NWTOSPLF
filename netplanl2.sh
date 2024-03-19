#!/bin/bash

# Überprüfen, ob die Anzahl der Argumente korrekt ist
if [ "$#" -ne 3 ]; then
    echo "Verwendung: $0 <LAN_MAC> <DMZ_MAC> <OUTSIDE_MAC>"
    exit 1
fi

CONFIG_FILE="/etc/netplan/00-installer-config.yaml"

# Backup der aktuellen Konfigurationsdatei erstellen
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# Netplan-Konfiguration erstellen
cat <<EOF > "$CONFIG_FILE"
network:
  version: 2
  ethernets:
    lan:
      addresses:
        - 10.0.0.254/24
      match:
        macaddress: $1
      set-name: lan
    dmz:
      addresses:
        - 192.168.30.254/24
      match:
        macaddress: $2
      set-name: dmz
    outside:
      dhcp4: true
      match:
        macaddress: $3
      set-name: outside
EOF

sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo sysctl -p

# Netplan anwenden
sudo netplan apply

echo "Netplan-Konfiguration wurde erfolgreich aktualisiert."
