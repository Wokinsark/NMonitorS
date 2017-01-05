#ifndef WIFIHOSTS_H
#define WIFIHOSTS_H

#include <QObject>

class WiFiHosts : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ip READ ip WRITE setIp NOTIFY ipChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(QString login READ login WRITE setLogin NOTIFY loginChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)

public:
    explicit WiFiHosts(QObject *parent = 0);

    QString ip();
    void setIp(const QString & ip);

    int port();
    void setPort(const int & port);

    QString login();
    void setLogin(const QString & login);

    QString password();
    void setPassword(const QString & password);

    Q_INVOKABLE QStringList getAllMAC();

signals:
    void ipChanged(const QString & ip);
    void portChanged(const int & port);
    void loginChanged(const QString & login);
    void passwordChanged(const QString & password);

public slots:

private:
    QString getAnswer(const QString & ip, const int & port, const QString & login, const QString & pass);
    QStringList getHosts(const QString & answer);

    QString m_ip;
    int     m_port;
    QString m_login;
    QString m_pass;
};

#endif // WIFIHOSTS_H
