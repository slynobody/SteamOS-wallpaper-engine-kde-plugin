import QtQuick 2.0
import com.github.catsout.wallpaperEngineKde 1.2

// FileHelper wrapper with Promise-like API for backwards compatibility
Item {
    id: root

    // Always ready (no Python startup delay)
    readonly property bool ok: true
    readonly property string log: ""
    readonly property string version: "native"

    // Internal C++ FileHelper instance
    FileHelper {
        id: fileHelper
    }

    // Promise-like wrapper for synchronous calls
    function _makePromise(value) {
        return {
            result: value,
            then: function(callback) {
                const res = callback(value);
                // Return chainable promise
                return _makePromise(res !== undefined ? res : value);
            },
            catch: function(callback) {
                // No-op for synchronous calls (errors would throw immediately)
                return _makePromise(value);
            }
        };
    }

    function readfile(path) {
        const data = fileHelper.readFile(path);
        // Return as string (QML handles QByteArray to string conversion)
        return _makePromise(data);
    }

    function get_dir_size(path, depth) {
        if (depth === undefined) depth = 3;
        const size = fileHelper.getDirSize(path, depth);
        return _makePromise(size);
    }

    function get_folder_list(path, opt) {
        if (opt === undefined) opt = {};
        const result = fileHelper.getFolderList(path, opt);
        return _makePromise(result);
    }

    function read_wallpaper_config(id) {
        const config = fileHelper.readWallpaperConfig(id);
        return _makePromise(config);
    }

    function write_wallpaper_config(id, changed) {
        fileHelper.writeWallpaperConfig(id, changed);
        return _makePromise(null);
    }

    function reset_wallpaper_config(id) {
        fileHelper.resetWallpaperConfig(id);
        return _makePromise(null);
    }
}
