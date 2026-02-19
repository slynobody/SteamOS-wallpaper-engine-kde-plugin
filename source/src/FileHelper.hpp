#pragma once
#include <QObject>
#include <QString>
#include <QUrl>
#include <QVariantMap>
#include <QVariantList>

namespace wekde {

class FileHelper : public QObject {
    Q_OBJECT

public:
    explicit FileHelper(QObject* parent = nullptr);
    virtual ~FileHelper();

    // File operations
    Q_INVOKABLE QByteArray readFile(const QString& path);
    Q_INVOKABLE qint64 getDirSize(const QString& path, int depth = 3);
    Q_INVOKABLE QVariantMap getFolderList(const QString& path, const QVariantMap& opt = {});

    // Wallpaper config operations
    Q_INVOKABLE QVariantMap readWallpaperConfig(const QString& id);
    Q_INVOKABLE void writeWallpaperConfig(const QString& id, const QVariantMap& changed);
    Q_INVOKABLE void resetWallpaperConfig(const QString& id);

private:
    QString configDir() const;
    QString wallpaperConfigDir() const;
    QString wallpaperConfigFile(const QString& id) const;
};

} // namespace wekde
