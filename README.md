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

# Setup Instructions

## Install Dependencies
```bash
sudo apt update
sudo apt install dnsmasq hostapd net-tools -y
```

## Clone the PS5 exploit host repository.
```bash
git clone https://github.com/idlesauce/umtx2.git umtx2/
```
