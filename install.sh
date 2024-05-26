#!/bin/sh
#wallpaper-engine alternative >> https://github.com/varietywalls/variety?tab=readme-ov-file
#installer for arch steam-deck, main location is /usr/lib/qt/qml/com/github/catsout/wallpaperEngineKde/
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman -Syu
sudo pacman -S gstreamer-vaapi gst-plugin-pipewire gst-plugins-bad-libs gst-plugins-good gst-plugins-ugly mpv python-websockets qt5-websockets --overwrite '*'
cp -r kde/new/plasma/wallpapers/com.github.casout.wallpaperEngineKde /home/deck/.local/share/plasma/wallpapers
sudo cp -r binaries/arch/sd/com /usr/lib/qt/qml/com/
#for testing purposes
sudo cp -r SteamLibrary/steamapps/common/wallpaper_engine  /home/deck/.steam/steam/steamapps/common
sudo cp -r SteamLibrary/steamapps/workshop/content/431960 /home/deck/.steam/steam/steamapps/workshop/content
#Default Steam library path on Linux: ~/.local/share/Steam
#Default Steam library path on Linux (Flatpak): ~/.var/app/com.valvesoftware.Steam/data/Steam
#Default Steam Deck library path:/home/deck/.local/share/Steam
sudo steamos-readonly enable
