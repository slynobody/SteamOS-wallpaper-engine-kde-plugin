# kde-plugin wallpaper-engine (SteamOS / arch + Debian / ubuntu)

* use wallpaper-engine-files natively (linux, precompiled)
* KDE-Plasma Plugin (Desktop-Mode: right-click, background ...)

<sub> ** for Steam Deck: v.0.5.5 (for *kde 5.27* + for *kde 6.2+*)  & for debian / ubuntu: v.0.5.5 (deb for *kde 5.27* + deb for *kde 6.1+*)</sub>

<sub> ** precompiled for simple use (& through limitations of the compilation-capabilities of steamdecks, f.e. <a href="https://github.com/catsout/wallpaper-engine-kde-plugin/issues/177">see</a>; *no need to install the plugin through discover*, gets installed system-wide through packages here)</sub>

<img src="https://images.pling.com/img/00/00/78/78/79/2160403/screenshot-20240602-192228.png"/>

# Arch-installation (Debian / Ubuntu: see below)
plasma 5? same as SteamOS 3.6

plasma 6? same as SteamOS 3.7

(both: just the download & pacman-command)

# SteamOS 3.6 installation

> sudo steamos-readonly disable
>
> sudo pacman-key --init
>
> sudo pacman-key --populate archlinux
>
> sudo pacman-key --populate holo
>
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5_arch/WallpaperEngine_kde-1_1-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde-1_1-1-x86_64.pkg.tar.zst --overwrite '*'
> 
> plasmapkg2 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde && qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}' & plasmashell --replace &
> 
> sudo steamos-readonly enable

# SteamOS 3.7 installation
> sudo steamos-readonly disable
>
> sudo pacman-key --init
>
> sudo pacman-key --populate archlinux
>
> sudo pacman-key --populate holo
>
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5_qt6_arch/WallpaperEngine_kde6-1.1a-1-x86_64.pkg.tar.zst
>
> udo pacman -U ./WallpaperEngine_kde6-1.1a-1-x86_64.pkg.tar.zst --overwrite '*'
> 
> kpackagetool6 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde && qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}' & plasmashell --replace &
>
> sudo steamos-readonly enable

# installation through apt ((*.deb, *Plasma 5/ qt5*)
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5/int_wallpaper_engine_1-1_amd64.deb
>
> sudo apt install ./int_wallpaper_engine_1-1_amd64.deb

# installation through apt (*.deb, *Plasma 6/ qt6*)
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5a/int_wallpaper_engine_qt6-1-1_amd64.deb
> 
> sudo apt install int_wallpaper_engine_qt6-1-1_amd64.deb

# after installation
* reboot
* choose the folder where steam has installed wallpaper-engine (usually /home/deck/.steam/steam > paste it into the file-chooser)
* enjoy

# usual Steam Deck library path: /home/deck/.steam/steam (steam-deck) or /home/deck/.local/share/Steam
> 
> Default Steam library path on Linux: ~/.local/share/Steam
> 
> Default Steam library path on Linux (Flatpak): ~/.var/app/com.valvesoftware.Steam/data/Steam
>

# it does not work!?!
* WPE needs to be installed through steam before usage (main source of 'scene'-errors because of missing 'assets'-folder)

# how do i get SteamOS 3.7?
> gamemode, settings-tab left: scroll down, tap 'enter developer mode'
> 
> in the new developer-tab on the left: enable 'extended update-channels'
> 
> go back to system-tab left: enable new OS-Update-Channel 'Main', check for updates

# i want to remove this!
> cd SteamOS-wallpaper-engine-kde-plugin
>
> ./remove.sh
> 
<a href="https://artsandculture.google.com/experiment/viola-the-bird/nAEJVwNkp-FnrQ?cp=e30."><img src="https://images.pling.com/img/00/00/78/78/79/2160403/proxy-image1.jpeg"/></a>
