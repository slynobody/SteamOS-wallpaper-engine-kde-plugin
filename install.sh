#!/bin/sh
# wallpaper-engine alternative >> https://github.com/varietywalls/variety?tab=readme-ov-file
# installer for arch (steam-deck), main lib-location is /usr/lib/qt/qml/com/github/catsout/wallpaperEngineKde/
echo ">>> copying the wpe-library needs privileges >>> no password set yet? >>> simply enter 'passwd'" 
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman -Syu
sudo pacman -S gstreamer-vaapi gst-plugin-pipewire gst-plugins-bad-libs gst-plugins-good gst-plugins-ugly mpv python-websockets qt5-websockets --overwrite '*'
plasmapkg2 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde && qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}'
tar -xvzf binaries/arch/sd/com/github/catsout/wallpaperEngineKde/libWallpaperEngineKde.tar.gz -C binaries/arch/sd/com/github/catsout/wallpaperEngineKde/
rm binaries/arch/sd/com/github/catsout/wallpaperEngineKde/libWallpaperEngineKde.tar.gz 
mkdir  ~/.local/share/plasma/
mkdir  ~/.local/share/plasma/wallpapers
cp -r kde/new/plasma/wallpapers/com.github.casout.wallpaperEngineKde ~/.local/share/plasma/wallpapers
sudo cp -r binaries/arch/sd/com /usr/lib/qt/qml/
sudo steamos-readonly enable
