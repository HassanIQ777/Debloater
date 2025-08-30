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
echo "2) Enable (reactivate disabled package like : com.google.android.gms)"
echo "3) Uninstall for user 0 (safe, reversible with reinstall)"
echo "4) Full uninstall (root required, PERMANENT)"
echo "5) Disable google services (include : google play , google maps , google play store , google framework , google login)"
read -p "Choose [1-5]: " choice

case $choice in
  1)
    adb shell pm disable-user --user 0 "$pkg"
    echo "✅ $pkg disabled."
    ;;
  2)
	adb shell pm enable --user 0 "$pkg"
	echo "✅ $pkg enabled."
;;

  3)
    	adb shell pm uninstall -k --user 0 "$pkg"
    	echo "✅ $pkg uninstalled for user 0."
    ;;
  4)
    	adb shell su -c "pm uninstall $pkg"
    	echo "💀 $pkg nuked PERMANENTLY."
    ;;
  5)
	adb shell pm disable-user --user 0 com.google.android.gms # google play
	adb shell pm disable-user --user 0 com.google.android.gsf # framework
	adb shell pm disable-user --user 0 com.google.android.gsf.login # login service
	adb shell pm disable-user --user 0 com.google.android.apps.maps # maps
	adb shell pm disable-user --user 0 com.android.vending # play store
	echo "✅ Google services disabled."
;;
  *)
    	echo "❌ Invalid choice."
    ;;
esac
