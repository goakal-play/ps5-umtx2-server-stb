# PS5 UMTX2 Exploit Host Server for STB/Armbian

This project provides a self-hosted exploit server for PS5, designed to run on STB devices or any system using Armbian. It includes support for DNS spoofing, rebind attacks, automatic caching, and serves the exploit through both HTTP and HTTPS.

## Based On

This project is originally based on the excellent work by [idlesauce](https://github.com/idlesauce/umtx2). All credits for the UMTX2 exploit core go to the original author.

This fork adapts the exploit for automated and persistent deployment on STB/Armbian environments, with systemd integration and Wi-Fi exploit hosting.

## Features

- Auto-start server on boot using systemd
- DNS spoofing and rebind attack handling
- Support HTTP for esphost app & HTTPS for user guide PS5 menu redirection
- Lightweight, optimized for STB devices

**Note:** This project requires the STB (Set-Top Box) to be rooted first. After rooting, Armbian must be successfully installed on the device before proceeding with the setup.

## Setup Instructions

### Install Dependencies
```bash
sudo apt update
sudo apt install dnsmasq hostapd net-tools -y
```

### Stop systemd-resolved to avoid conflicts with custom DNS.
```bash
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```

### Clone idlesauce PS5 UMTX2 Jailbreak repository.
```bash
git clone https://github.com/idlesauce/umtx2.git umtx2/
```

### Create a systemd service to assign a static IP.
```bash
cat << 'EOF' | sudo tee /etc/systemd/system/static-ip.service > /dev/null
[Unit]
Description=Set Static IP Address and restart services
After=network-online.target hostapd.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/set-static-ip.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
```

### Create static IP script executed by service above.
```bash
cat << 'EOF' | sudo tee nano /usr/local/bin/set-static-ip.sh > /dev/null
#!/bin/bash
for i in {1..10}; do
  if ip link show wlan0 > /dev/null 2>&1; then
    break
  fi
  sleep 1
done
ip link set wlan0 up
ifconfig wlan0 10.1.1.1 netmask 255.255.255.0 up
systemctl restart hostapd
systemctl restart dnsmasq
EOF
```

### Make it executable and enable the service.
```bash
sudo chmod +x /usr/local/bin/set-static-ip.sh
sudo systemctl daemon-reload
sudo systemctl enable static-ip.service
sudo systemctl start static-ip.service
```

### Hostapd Configuration (WiFi Access Point)
```bash
cat << 'EOF' | sudo tee nano /etc/hostapd/hostapd.conf > /dev/null
interface=wlan0
ssid=PS5_UMTX2
hw_mode=g
channel=6
auth_algs=1
wpa=2
wpa_passphrase=12345678
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF
```

### Link the config file Hostapd
```bash
cat <<EOF | sudo tee -a /etc/default/hostapd > /dev/null
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF
```

### Enable and start Hostapd
```bash
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl restart hostapd
```

### dnsmasq Configuration (DHCP & DNS)
```bash
cat << 'EOF' | sudo tee -a /etc/dnsmasq.conf > /dev/null
interface=wlan0
bind-interfaces
port=0
dhcp-range=10.1.1.2,10.1.1.9,7d
dhcp-option=3,10.1.1.1
dhcp-option=6,10.1.1.1
bogus-priv
no-resolv
no-hosts
no-poll
log-dhcp
log-queries
EOF
```

### Restart dnsmasq service
```bash
sudo systemctl restart dnsmasq
```

### Systemd Services for custom_host.py (Server)
```bash
cat << 'EOF' | sudo tee /etc/systemd/system/ps5-host.service > /dev/null
[Unit]
Description=PS5 Exploit Host
After=network.target

[Service]
ExecStart=/usr/bin/python3 /root/custom_host.py
WorkingDirectory=/root
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
```

### Systemd Services for FakeDNS
```bash
cat << 'EOF' | sudo tee /etc/systemd/system/fakedns.service
 > /dev/null
[Unit]
Description=Fake DNS Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /root/umtx2/fakedns.py -c /root/umtx2/dns.conf
WorkingDirectory=/root/umtx2
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```
### Change dns.conf default IP to static STB IP
```bash
cat << 'EOF' | sudo tee /root/umtx2/dns.conf
 > /dev/null
A manuals.playstation.net 10.1.1.1
EOF
```

### Enable and Start All Services
```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable ps5-host.service
sudo systemctl enable fakedns.service
sudo systemctl start ps5-host.service
sudo systemctl start fakedns.service
```

### Reboot System
```bash
sudo reboot
```

### Check Service Status
```bash
sudo systemctl status ps5-host.service
sudo systemctl status fakedns.service
sudo systemctl status dnsmasq.service
sudo systemctl status static-ip.service
```
