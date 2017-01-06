#ifndef IO_H
#define IO_H

#include <QObject>
#include <QVariantMap>
#include <QDir>
#include <QFile>
#include <QTextStream>

class IO : public QObject
{
    Q_OBJECT
public:
    explicit IO(QObject *parent = 0);    
    Q_INVOKABLE QString clientsRead();
    Q_INVOKABLE QString settingsRead();
    Q_INVOKABLE bool clientsWrite(const QString & data);
    Q_INVOKABLE bool settingsWrite(const QString & data);

private:
    QString m_clients;
    QString m_settings;
};

#endif // IO_H
