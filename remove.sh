#!/bin/sh
sudo steamos-readonly disable
sudo pacman -R gstreamer-vaapi gst-plugin-pipewire gst-plugins-bad-libs gst-plugins-good gst-plugins-ugly mpv python-websockets qt5-websockets
plasmapkg2 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}'
sudo rm -r /usr/lib/qt/qml/com/github/catsout/wallpaperEngineKde
cd ..
sudo rm -r SteamOS-wallpaper-engine-kde-plugin 
