# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Обзор проекта

Wallpaper Engine KDE Plugin — плагин для KDE Plasma 6, интегрирующий обои из Wallpaper Engine (Steam) в рабочий стол Linux. Поддерживает Scene (2D), Web и Video обои.

## Сборка

```bash
# Инициализация субмодулей (обязательно)
git submodule update --init --force --recursive

# Сборка
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build

# Установка
sudo cmake --install build

# Перезапуск plasmashell
systemctl --user restart plasma-plasmashell.service
```

### Standalone viewer для отладки

```bash
# В директории src/backend_scene/standalone_view/
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# Запуск с Vulkan validation layers
./sceneviewer --valid-layer <steamapps>/common/wallpaper_engine/assets <steamapps>/workshop/content/431960/<id>/scene.pkg
```

## Архитектура

### Основные компоненты

- **src/** — C++ код QML-плагина
  - `plugin.cpp` — точка входа QML-плагина
  - `FileHelper.cpp` — нативный C++ хелпер для файловых операций (замена Python)
  - `MouseGrabber` — перехват событий мыши
  - `TTYSwitchMonitor` — мониторинг переключения TTY через D-Bus

- **src/backend_mpv/** — MPV бэкенд для видео-обоев
  - Использует libmpv для воспроизведения
  - Статическая библиотека `mpvbackend`

- **src/backend_scene/** — Vulkan рендерер для Scene обоев
  - `wescene-renderer` — основная библиотека рендеринга
  - `wescene-renderer-qml` — Qt/QML обвязка
  - Требует Vulkan 1.1+

### Подсистемы backend_scene

- **VulkanRender/** — Vulkan рендеринг и управление ресурсами
- **RenderGraph/** — автоматические зависимости между проходами
- **Scene/** — парсинг и представление сцен
- **Particle/** — система частиц
- **Audio/** — аудио через miniaudio
- **Vulkan/** — базовая Vulkan абстракция
- **WP*Parser.cpp** — парсеры форматов Wallpaper Engine (JSON, MDL, шейдеры, текстуры)

### QML UI

- **plugin/contents/ui/** — QML интерфейс настроек
  - `main.qml` — главное окно плагина
  - `config.qml` — страница конфигурации
  - `WallpaperListModel.qml` — модель списка обоев

### Сторонние библиотеки (в src/backend_scene/third_party/)

- Eigen — линейная алгебра
- glslang — компиляция GLSL в SPIR-V
- SPIRV-Reflect — рефлексия SPIR-V шейдеров
- nlohmann/json — парсинг JSON
- miniaudio — кроссплатформенное аудио

## Зависимости

### Arch Linux
```bash
sudo pacman -S extra-cmake-modules plasma-framework gst-libav ninja \
base-devel mpv qt6-declarative qt6-websockets qt6-webchannel vulkan-headers cmake lz4
```

### Fedora
```bash
sudo dnf install vulkan-headers plasma-workspace-devel kf6-plasma-devel gstreamer1-libav \
lz4-devel mpv-libs-devel qt6-qtbase-private-devel libplasma-devel \
qt6-qtwebchannel-devel qt6-qtwebsockets-devel cmake extra-cmake-modules
```

## Отладка

Логи plasmashell:
```bash
journalctl /usr/bin/plasmashell -f
# или
plasmashell --replace
```

Установить `vulkan-validation-layers` для отладки Vulkan.

## Стиль кода

- C++20
- Форматирование: `.clang-format` (4 пробела, 100 символов в строке)
- Qt6 / KF6 / Plasma 6
