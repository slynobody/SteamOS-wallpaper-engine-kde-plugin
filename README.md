 [![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://ko-fi.com/integr)
# wallpaper-engine (kde-/plasma-plugin)
## <a href="https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/#arch-installation-debian--ubuntu-see-below">arch</a> (+ SteamOS) + <a href="https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/#apt--debian--ubuntu">Debian</a> (+ Ubuntu, Kali, Deepin, Elementary, Mint etc.), <a href="https://copr.fedorainfracloud.org/coprs/kylegospo/wallpaper-engine-kde-plugin">Fedora</a>, <a href="https://github.com/slynobody/linux_wallpaper_engine__precompiled/tree/main">other (f.e. hyprland)</a>

* use wallpaper-engine-files natively (linux, precompiled
* KDE-Plasma Plugin (Desktop-Mode: right-click, background ...)

<sub> ** precompiled for simple use (f.e. through limits of steam-decks-compilation-capabilities, <a href="https://github.com/catsout/wallpaper-engine-kde-plugin/issues/177">see</a>

<img src="https://images.pling.com/img/00/00/78/78/79/2160403/screenshot-20240602-192228.png"/>

# installation
*no need to install the plugin through discover*, everything gets installed system-wide through packages here</sub>

# Arch
plasma 6.5.4+
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.55d_arch/WallpaperEngine_kde6-1.1d-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde6-1.1d-1-x86_64.pkg.tar.zst --overwrite '*'

plasma 6.3 (-6.5.4)
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5c_arch/WallpaperEngine_kde6-3_1c-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde6-3_1c-1-x86_64.pkg.tar.zst --overwrite '*'

Legacy: plasma 6 (-6.2)
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5_qt6_arch/WallpaperEngine_kde6-1.1a-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde6-1.1a-1-x86_64.pkg.tar.zst --overwrite '*'

Legacy: plasma 5
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5_arch/WallpaperEngine_kde-1_1-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde-1_1-1-x86_64.pkg.tar.zst --overwrite '*'


# SteamOS 
SteamOS 3.7 (stable / beta)
> sudo steamos-devmode enable --no-prompt
>
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5c_arch/WallpaperEngine_kde6-3_1c-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde6-3_1c-1-x86_64.pkg.tar.zst --overwrite '*'
> > 
> plasmapkg2 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde && qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}' & plasmashell --replace &
> 
> sudo steamos-readonly enable

SteamOS 3.9 (dev-Channel / 'main')
> sudo steamos-devmode enable --no-prompt
>
> sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.55d_arch/WallpaperEngine_kde6-1.1d-1-x86_64.pkg.tar.zst
>
> sudo pacman -U ./WallpaperEngine_kde6-1.1d-1-x86_64.pkg.tar.zst --overwrite '*'
> 
> kpackagetool6 -r ~/.local/share/plasma/wallpapers/com.github.casout.wallpaperEngineKde && qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file:///media/sda2/Background/SpaceWall/Escape_Function.jpg")}' & plasmashell --replace &
>
> sudo steamos-readonly enable

# apt  (Debian / Ubuntu)
Plasma 6.3 (-6.5) / qt 6.8.2 (-6.9.2)
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.55d/int_wallpaper_engine_qt6-1-1_amd64.deb
> 
> sudo apt install ./int_wallpaper_engine_qt6-1-1_amd64.deb

Legacy: Plasma 6 (6.1-6.2)
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5a/int_wallpaper_engine_qt6-1-1_amd64.deb
> 
> sudo apt install ./int_wallpaper_engine_qt6-1-1_amd64.deb

Legacy: Plasma 5 / qt5*
> wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.5.5/int_wallpaper_engine_1-1_amd64.deb
>
> sudo apt install ./int_wallpaper_engine_1-1_amd64.deb

# after installation
* reboot
* choose the folder where steam has installed wallpaper-engine (usually ~/.steam/steam > copy/paste it into the file-chooser)
* enjoy

# usual library path: ~/.local/share/Steam
## or ~/.steam/steam (steam-deck)
> 
> Default Steam library path (Flatpak): ~/.var/app/com.valvesoftware.Steam/data/Steam

# crashes!
* CTRL+ALT+T (Terminal) -- or boot into konsole -- then type:
> sed -i '/wallpaperEngineKde/d' ~/.config/plasma-org.kde.plasma.desktop-appletsrc & qdbus6 org.kde.Shutdown /Shutdown logout

* WPE needs to be installed through steam before usage (main source of 'scene'-errors because of missing 'assets'-folder)
```diff
- choose WPE-version in steam: 'windows 7 compatibility' (esp. when 'scenes' crash that formerly worked)
```
* also try <a href="https://github.com/slynobody/linux_wallpaper_engine__precompiled/tree/main">this.</a>

no responsibility taken for usage.

# how do i get SteamOS 3.9?
> gamemode, settings-tab left: scroll down, tap 'enter developer mode'
> 
> in the new developer-tab on the left: enable 'extended update-channels'
> 
> go back to system-tab left: enable new OS-Update-Channel 'Main', check for updates>

# i dont use kde! (but gnome, lxqt, hyprland etc.)
* try <a href="https://github.com/slynobody/linux_wallpaper_engine__precompiled/tree/main">this.</a>

# i want to remove this!
> cd SteamOS-wallpaper-engine-kde-plugin
>
> ./remove.sh

# Disclaimer
1. Use at your own risk!
2. This is for educational and research purposes only!
3. No responsibility taken for any local customizations of the git!
> 
<a href="https://artsandculture.google.com/experiment/viola-the-bird/nAEJVwNkp-FnrQ?cp=e30."><img src="https://images.pling.com/img/00/00/78/78/79/2160403/proxy-image1.jpeg"/></a>
