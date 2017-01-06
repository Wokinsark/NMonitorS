#include "io.h"

IO::IO(QObject *parent) : QObject(parent), m_clients(QDir::currentPath() + "/clients.json"), m_settings(QDir::currentPath() + "/settings.json")
{

}

QString IO::settingsRead()
{
    return QString();
}

bool IO::settingsWrite(const QString &data)
{
    return true;
}

QString IO::clientsRead()
{
    QFile file(m_clients);
    if(!file.open(QIODevice::ReadOnly)){
        return QString();
    }

    QString data = file.readAll();
    file.close();
    return data;
}

bool IO::clientsWrite(const QString &data)
{
    QFile file(m_clients);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Truncate)){
        return false;
    }

    QTextStream out(&file);
    out.setCodec("UTF-8");
    out << data;

    file.close();

    return true;
}
