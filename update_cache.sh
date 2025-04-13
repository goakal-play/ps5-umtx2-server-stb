#!/bin/bash

# update_cache.sh
# Script to update the PS5 UMTX2 exploit and generate the appcache manifest

# Function to display the menu
show_menu() {
    clear
    echo "================================================"
    echo "         PS5 UMTX2 Cache Updater                "
    echo "================================================"
    echo "1) Update Exploit & Generate Appcache Manifest"
    echo "2) Generate Appcache Manifest only"
    echo "0) Exit"
    echo "------------------------------------------------"
    echo -n "Select an option [0-2]: "
}

# Function to update the exploit
update_exploit() {
    echo "[+] Removing existing 'umtx2' directory if it exists..."
    rm -rf umtx2
    echo "[+] Cloning the 'umtx2' repository..."
    git clone https://github.com/idlesauce/umtx2.git umtx2
    echo "[+] Running the appcache manifest generator..."
    python3 /root/umtx2/appcache_manifest_generator.py -d /root/umtx2/document/en/ps5
    echo "[✓] Update complete."
    echo "Press Enter to return to the menu..."
    read
}

# Function to generate the appcache manifest
generate_manifest() {
    echo "[+] Running the appcache manifest generator..."
    python3 /root/umtx2/appcache_manifest_generator.py -d /root/umtx2/document/en/ps5
    echo "[✓] Generation complete."
    echo "Press Enter to return to the menu..."
    read
}

# Main loop
while true; do
    show_menu
    read choice
    case $choice in
        1)
            update_exploit
            ;;
        2)
            generate_manifest
            ;;
        0)
            echo "Exiting the script."
            break
            ;;
        *)
            echo "Invalid option. Please select between 0 and 2."
            sleep 2
            ;;
    esac
done
