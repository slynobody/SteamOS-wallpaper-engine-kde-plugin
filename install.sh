#!/bin/sh
#wallpaper-engine alternative >> https://github.com/varietywalls/variety?tab=readme-ov-file
#installer for arch steam-deck, main location is /usr/lib/qt/qml/com/github/catsout/wallpaperEngineKde/
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman -Syu
sudo pacman -S gstreamer-vaapi gst-plugin-pipewire gst-plugins-bad-libs gst-plugins-good gst-plugins-ugly mpv python-websockets qt5-websockets --overwrite '*'
tar -xvzf binaries/arch/sd/com/github/catsout/wallpaperEngineKde/libWallpaperEngineKde.tar.gz
rm binaries/arch/sd/com/github/catsout/wallpaperEngineKde/libWallpaperEngineKde.tar.gz
cp -r kde/new/plasma/wallpapers/com.github.casout.wallpaperEngineKde /home/deck/.local/share/plasma/wallpapers
sudo cp -r binaries/arch/sd/com /usr/lib/qt/qml/com/
sudo steamos-readonly enable
