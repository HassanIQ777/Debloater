#!/usr/bin/env bash

check_device() {
    if ! adb devices | grep -w device > /dev/null; then
        echo "No devices/emulators found."
        echo "please connect your device and enable USB debugging"
        return 1
    fi
    return 0
}

if ! check_device; then
    exit 1
fi

while true; do
    clear
    
    if ! check_device; then
        echo "Device disconnected. exiting..."
        exit 1
    fi
    
    echo "
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  ██████╗ ███████╗██████╗ ██╗      ██████╗  █████╗ ████████╗  ║
║  ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗██╔══██╗╚══██╔══╝  ║
║  ██║  ██║█████╗  ██████╔╝██║     ██║   ██║███████║   ██║     ║
║  ██║  ██║██╔══╝  ██╔══██╗██║     ██║   ██║██╔══██║   ██║     ║
║  ██████╔╝███████╗██████╔╝███████╗╚██████╔╝██║  ██║   ██║     ║
║  ╚═════╝ ╚══════╝╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝     ║
║                                                              ║
║                 by HassanIQ777 & Unknown                     ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
"

    echo "welcome to debloater, suckless tool for android"
    echo ""
    echo "1) Search for a package"
    echo "2) Disable package (safe, reversible)"
    echo "3) Enable package (reactivate disabled package)"
    echo "4) Uninstall for user 0 (safe, reversible with reinstall)"
    echo "5) Full uninstall (root required, PERMANENT)"
    echo "6) Disable google services"
    echo "7) Enable google services"
    echo "8) Check device connection"
    echo "9) Exit"

    read -p "👉 Choose an option [1-9]: " main_choice

    case $main_choice in
        1)
            read -p "Enter package name to search: " search_term
            echo "Searching for packages: $search_term"
            echo "────────────────────────────────────"
            adb shell pm list packages | sed 's/package://g' | sort | grep -i "$search_term" || echo "❌ No packages found matching: $search_term"
            ;;
        2)
            read -p "👉 Enter the package name: " pkg
            if [ -z "$pkg" ]; then
                echo "⚠️ No package entered."
            else
                echo "Disabling $pkg..."
                if adb shell pm disable-user --user 0 "$pkg"; then
                    echo "✅ $pkg disabled successfully."
                else
                    echo "Failed to disable $pkg"
                fi
            fi
            ;;
        3)
            read -p "👉 Enter the package name: " pkg
            if [ -z "$pkg" ]; then
                echo "⚠️ No package entered."
            else
                echo "Enabling $pkg..."
                if adb shell pm enable --user 0 "$pkg"; then
                    echo "✅ $pkg enabled successfully."
                else
                    echo "❌ Failed to enable $pkg"
                fi
            fi
            ;;
        4)
            read -p "👉 Enter the package name: " pkg
            if [ -z "$pkg" ]; then
                echo "⚠️ No package entered."
            else
                echo "Uninstalling $pkg for user 0..."
                if adb shell pm uninstall -k --user 0 "$pkg"; then
                    echo "✅ $pkg uninstalled for user 0."
                else
                    echo "❌ Failed to uninstall $pkg"
                fi
            fi
            ;;
        5)
            read -p "👉 Enter the package name: " pkg
            if [ -z "$pkg" ]; then
                echo "⚠️ No package entered."
            else
                echo "💀 PERMANENTLY uninstalling $pkg (root required)..."
                if adb shell su -c "pm uninstall $pkg"; then
                    echo "💀 $pkg nuked PERMANENTLY."
                else
                    echo "❌ Failed to uninstall $pkg (may need root)"
                fi
            fi
            ;;
        6)
            echo "disabling google services..."
            for google_pkg in com.google.android.gms com.google.android.gsf com.google.android.gsf.login com.google.android.apps.maps com.android.vending; do
                if adb shell pm disable-user --user 0 "$google_pkg"; then
                    echo "✅ $google_pkg disabled"
                else
                    echo "❌ failed to disable $google_pkg"
                fi
            done
            echo "google services disabled successfully."
            ;;
        7)
            echo "enabling google services..."
            for google_pkg in com.google.android.gms com.google.android.gsf com.google.android.gsf.login com.google.android.apps.maps com.android.vending; do
                if adb shell pm enable --user 0 "$google_pkg"; then
                    echo "✅ $google_pkg enabled"
                else
                    echo "❌ failed to enable $google_pkg"
                fi
            done
            echo "google services enabled successfully."
            ;;
        8)
            echo "device is connected and ready!"
            echo "Connected devices:"
            adb devices
            ;;
        9)
            echo "exiting debloater... goodbye"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please select 1-9."
            ;;
    esac

    echo ""
    echo "────────────────────────────────────"
    read -p "Press Enter to continue or 'q' to quit: " continue_choice
    if [ "$continue_choice" = "q" ] || [ "$continue_choice" = "Q" ]; then
        echo "exiting debloater... goodbye"
        exit 0
    fi
done
