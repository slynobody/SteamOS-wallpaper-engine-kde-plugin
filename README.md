# kde-plugin wallpaper-engine (SteamOS / arch + Debian / ubuntu)

* lets you use wallpaper-engine-files natively (precompiled)
* KDE-Plasma Plugin (Desktop-Mode: right-click, background ...)

<sub> ** for Steam Deck: v.0.5.5 (for *kde 5.27*)  & for debian / ubuntu: v.0.5.5 (deb for *kde 5.27* + deb for *kde 6.1+*)</sub>

<sub> ** precompiled for simple use & through limitations of the compilation-capabilities of steamdecks, f.e. see https://github.com/catsout/wallpaper-engine-kde-plugin/issues/177)</sub>

<img src="https://images.pling.com/img/00/00/78/78/79/2160403/screenshot-20240602-192228.png"/>

# installation through pacman (steam deck, *Plasma 5/qt5*)

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
> plasmapkg2 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde && qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}'
>
> sudo pacman -U ./WallpaperEngine_kde-1_1-1-x86_64.pkg.tar.zst --overwrite '*'
>
> sudo steamos-readonly enable

# installation through git (steamdeck, *Plasma 5/qt5*)
> git clone https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin
> 
> cd SteamOS-wallpaper-engine-kde-plugin
>
> chmod +x ./install.sh
>
> ./install.sh

>> if you already installed (through discover or outdated git), first run './remove.sh'

# installation through apt (Debian, *Plasma 5/qt5*)
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5/int_wallpaper_engine_1-1_amd64.deb
>
> sudo apt install ./int_wallpaper_engine_1-1_amd64.deb

<sub> (no need to install the plugin through discover, gets installed system-wide)</sub>

# installation through apt (Debian, *Plasma 6/qt6*)
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5a/int_wallpaper_engine_qt6-1-1_amd64.deb
> 
> sudo apt install int_wallpaper_engine_qt6-1-1_amd64.deb
> 
<sub>(no need to install the plugin through discover, gets installed system-wide)</sub>

# after installation
* * sometimes a reboot is needed (if you dont temporary revert to another plugin to let it be configured)
* * simply choose the folder where steam installed wallpaper-engine (usually /home/deck/.steam/steam > paste it into the file-chooser)
* * enjoy

# usual Steam Deck library path: /home/deck/.steam/steam (steam-deck) or /home/deck/.local/share/Steam
> 
> Default Steam library path on Linux: ~/.local/share/Steam
> 
> Default Steam library path on Linux (Flatpak): ~/.var/app/com.valvesoftware.Steam/data/Steam
>

# i want to remove this!
> cd SteamOS-wallpaper-engine-kde-plugin
>
> ./remove.sh
> 
<a href="https://artsandculture.google.com/experiment/viola-the-bird/nAEJVwNkp-FnrQ?cp=e30."><img src="https://images.pling.com/img/00/00/78/78/79/2160403/proxy-image1.jpeg"/></a>
