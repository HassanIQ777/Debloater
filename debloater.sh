#!/data/data/com.termux/files/usr/bin/bash
# By HassanIQ777

echo "📦 Listing installed packages..."
adb shell pm list packages | sed 's/package://g' | sort | grep "$1"

echo ""
read -p "👉 Enter the package name you want to remove/disable: " pkg

if [ -z "$pkg" ]; then
    echo "⚠️ No package entered. Exiting."
    exit 1
fi

echo ""
echo "What do you want to do with $pkg?"
echo "1) Disable (safe, reversible)"
echo "2) Uninstall for user 0 (safe, reversible with reinstall)"
echo "3) Full uninstall (root required, PERMANENT)"
read -p "Choose [1-3]: " choice

case $choice in
  1)
    adb shell pm disable-user --user 0 "$pkg"
    echo "✅ $pkg disabled."
    ;;
  2)
    adb shell pm uninstall -k --user 0 "$pkg"
    echo "✅ $pkg uninstalled for user 0."
    ;;
  3)
    adb shell su -c "pm uninstall $pkg"
    echo "💀 $pkg nuked PERMANENTLY."
    ;;
  *)
    echo "❌ Invalid choice."
    ;;
esac
