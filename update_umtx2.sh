#!/bin/bash

echo "[+] Backing up existing dns.conf..."
if [ -f umtx2/dns.conf ]; then
    cp umtx2/dns.conf dns.conf.bak
else
    echo "[!] dns.conf not found, continuing without backup."
fi

echo "[+] Removing old umtx2 directory..."
rm -rf umtx2

echo "[+] Cloning fresh copy of umtx2 repository..."
git clone https://github.com/idlesauce/umtx2.git umtx2

echo "[+] Restoring dns.conf..."
if [ -f dns.conf.bak ]; then
    mv dns.conf.bak umtx2/dns.conf
    echo "[+] dns.conf restored successfully."
fi

echo "[+] Running appcache_mainfest_generator.py..."
cd umtx2
python3 appcache_mainfest_generator.py
