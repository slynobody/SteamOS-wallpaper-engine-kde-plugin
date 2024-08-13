# kde-plugin wallpaper-engine (SteamOS / arch + Debian)

* lets you use wallpaper-engine-files natively 
* KDE-Plasma Plugin (Desktop-Mode),
* Steam deck (Desktop-Mode, right-click, background ...): v.0.5.5 (for kde 5.27, feel free to supply working files for plasma 6)
* debian: v.0.5.5 (seperate deb-file) for kde 5.27, feel free to supply working files for plasma 6)

> partially precompiled (through limitations of the compilation-capabilities of steamdecks, f.e. see https://github.com/catsout/wallpaper-engine-kde-plugin/issues/177)

<img src="https://images.pling.com/img/00/00/78/78/79/2160403/screenshot-20240602-192228.png"/>

# installation (steam deck / arch)

> git clone https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin
> 
> cd SteamOS-wallpaper-engine-kde-plugin
>
> chmod +x ./install.sh
>
> ./install.sh

# installation (Debian, Plasma 5)
> apt install int_wallpaper_engine_1-1_amd64.deb
> 
> (dependencies: gstreamer1.0-libav qml-module-qtwebchannel qml-module-qtwebsockets libgstreamer-plugins-bad1.0-0 gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gir1.2-gst-plugins-bad-1.0 python3-websockets libmpv2)

# installation (Debian, Plasma 6)
> apt install int_wallpaper_engine_qt6-1-1_amd64.deb
> 
> (dependencies: gstreamer1.0-libav qml-module-qtwebchannel qml-module-qtwebsockets libgstreamer-plugins-bad1.0-0 gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gir1.2-gst-plugins-bad-1.0 python3-websockets libmpv2 libqt6websockets6 qml6-module-qtwebsockets)

# after installation
* sometimes a reboot is needed
* simply choose the folder where steam installed wallpaper-engine (usually /home/deck/.steam/steam > paste it into the file-chooser)
* enjoy

# usual Steam Deck library path: /home/deck/.steam/steam (steam-deck) or /home/deck/.local/share/Steam
> 
> Default Steam library path on Linux: ~/.local/share/Steam
> 
> Default Steam library path on Linux (Flatpak): ~/.var/app/com.valvesoftware.Steam/data/Steam
>
<a href="https://artsandculture.google.com/experiment/viola-the-bird/nAEJVwNkp-FnrQ?cp=e30."><img src="https://images.pling.com/img/00/00/78/78/79/2160403/proxy-image1.jpeg"/></a>
