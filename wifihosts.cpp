#include <QProcess>

#include "wifihosts.h"

WiFiHosts::WiFiHosts(QObject *parent) : QObject(parent), m_ip(""), m_port(0), m_login(""), m_pass("")
{

}

QString WiFiHosts::ip()
{
    return m_ip;
}

void WiFiHosts::setIp(const QString &ip)
{
    m_ip = ip;
    emit ipChanged(ip);
}

int WiFiHosts::port()
{
    return m_port;
}

void WiFiHosts::setPort(const int &port)
{
    m_port = port;
    emit portChanged(port);
}

QString WiFiHosts::login()
{
    return m_login;
}

void WiFiHosts::setLogin(const QString &login)
{
    m_login = login;
    emit loginChanged(login);
}

QString WiFiHosts::password()
{
    return m_pass;
}

void WiFiHosts::setPassword(const QString &password)
{
    m_pass = password;
    emit passwordChanged(password);
}

QStringList WiFiHosts::getAllMAC()
{
    QString answer = getAnswer(m_ip, m_port, m_login, m_pass);
    if(answer.isEmpty()){
        return QStringList();
    }

    return getHosts(answer);
}

QString WiFiHosts::getAnswer(const QString &ip, const int &port, const QString &login, const QString &pass)
{
    QStringList params;
    params << "-D"
           << "-s"
           << "--header"
           << QString("Referer: http://%1:%2/userRpm/WlanStationRpm.htm").arg(ip).arg(port)
           << "-u"
           << QString("%1:%2").arg(login).arg(pass)
           << QString("http://%1:%2/userRpm/WlanStationRpm.htm").arg(ip).arg(port);

    QProcess pro;
    pro.start("curl", params);
    pro.waitForFinished();
    return pro.readAllStandardOutput();
}

QStringList WiFiHosts::getHosts(const QString &answer)
{
    int start = answer.indexOf("var hostList = new Array(");
    int end   = answer.indexOf(";", start);
    if(start == -1 || end == -1){
        return QStringList();
    }

    QString array = answer.mid(start, end - start);
    QRegExp rx("(([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))");
    QStringList list;
    int pos = 0;
    while ((pos = rx.indexIn(array, pos)) != -1) {
        list << rx.cap(1);
        pos += rx.matchedLength();
    }
    return list;
}
