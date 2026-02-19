#include "FileHelper.hpp"
#include <QFile>
#include <QDir>
#include <QDirIterator>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDateTime>

namespace wekde {

FileHelper::FileHelper(QObject* parent) : QObject(parent) {
    // Ensure config directory exists
    QDir dir(wallpaperConfigDir());
    if (!dir.exists()) {
        dir.mkpath(".");
    }
}

FileHelper::~FileHelper() {}

QString FileHelper::configDir() const {
    QString xdgConfig = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation);
    return xdgConfig + "/wekde";
}

QString FileHelper::wallpaperConfigDir() const {
    return configDir() + "/wallpaper";
}

QString FileHelper::wallpaperConfigFile(const QString& id) const {
    return wallpaperConfigDir() + "/" + id + ".json";
}

QByteArray FileHelper::readFile(const QString& path) {
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "FileHelper: Cannot open file:" << path;
        return QByteArray();
    }
    return file.readAll();
}

qint64 FileHelper::getDirSize(const QString& path, int depth) {
    qint64 totalSize = 0;
    QDir dir(path);

    if (!dir.exists()) {
        return 0;
    }

    if (depth <= 0) {
        // Recursive with no depth limit
        QDirIterator it(path, QDir::Files, QDirIterator::Subdirectories);
        while (it.hasNext()) {
            it.next();
            totalSize += it.fileInfo().size();
        }
    } else {
        // Limited depth iteration
        for (int d = 1; d <= depth; ++d) {
            QString pattern;
            for (int i = 0; i < d; ++i) {
                pattern += "*/";
            }
            pattern.chop(1); // Remove trailing /

            QDirIterator it(path, QStringList() << "*", QDir::Files);
            if (d == 1) {
                while (it.hasNext()) {
                    it.next();
                    totalSize += it.fileInfo().size();
                }
            }
        }

        // Simpler approach: just iterate with depth limit
        std::function<qint64(const QString&, int)> calcSize = [&](const QString& dirPath, int currentDepth) -> qint64 {
            if (currentDepth > depth) return 0;

            qint64 size = 0;
            QDir d(dirPath);

            for (const QFileInfo& info : d.entryInfoList(QDir::Files | QDir::NoDotAndDotDot)) {
                size += info.size();
            }

            if (currentDepth < depth) {
                for (const QFileInfo& info : d.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot)) {
                    size += calcSize(info.absoluteFilePath(), currentDepth + 1);
                }
            }

            return size;
        };

        totalSize = calcSize(path, 1);
    }

    return totalSize;
}

QVariantMap FileHelper::getFolderList(const QString& path, const QVariantMap& opt) {
    QVariantMap result;

    bool onlyDir = opt.value("only_dir", true).toBool();
    QStringList fallbacks = opt.value("fallbacks", QStringList()).toStringList();

    // Find first existing directory
    QString folder = path;
    QDir dir(folder);

    if (!dir.exists()) {
        for (const QString& fb : fallbacks) {
            QDir fbDir(fb);
            if (fbDir.exists()) {
                folder = fb;
                dir = fbDir;
                break;
            }
        }
    }

    if (!dir.exists()) {
        return QVariantMap(); // Return null/empty
    }

    result["folder"] = folder;

    QVariantList items;
    QDir::Filters filters = onlyDir ? QDir::Dirs : (QDir::Dirs | QDir::Files);
    filters |= QDir::NoDotAndDotDot;

    for (const QFileInfo& info : dir.entryInfoList(filters)) {
        QVariantMap item;
        item["name"] = info.fileName();
        item["mtime"] = static_cast<qint64>(info.lastModified().toSecsSinceEpoch());
        items.append(item);
    }

    result["items"] = items;
    return result;
}

QVariantMap FileHelper::readWallpaperConfig(const QString& id) {
    QString filePath = wallpaperConfigFile(id);
    QFile file(filePath);

    if (!file.exists()) {
        return QVariantMap();
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "FileHelper: Cannot read config:" << filePath;
        return QVariantMap();
    }

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    if (doc.isNull() || !doc.isObject()) {
        return QVariantMap();
    }

    return doc.object().toVariantMap();
}

void FileHelper::writeWallpaperConfig(const QString& id, const QVariantMap& changed) {
    // Read existing config
    QVariantMap config = readWallpaperConfig(id);

    // Merge changes
    for (auto it = changed.constBegin(); it != changed.constEnd(); ++it) {
        config[it.key()] = it.value();
    }

    // Write back
    QString filePath = wallpaperConfigFile(id);
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "FileHelper: Cannot write config:" << filePath;
        return;
    }

    QJsonDocument doc(QJsonObject::fromVariantMap(config));
    file.write(doc.toJson());
}

void FileHelper::resetWallpaperConfig(const QString& id) {
    QString filePath = wallpaperConfigFile(id);
    QFile::remove(filePath);
}

} // namespace wekde
