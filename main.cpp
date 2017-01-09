#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QPixmap>
#include <QFile>
#include <QDebug>

#include "io.h"
#include "wifihosts.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qDebug() << "###" << QFile::exists("/home/wokinsark/PROJECT/NMonitorS/icon.ico");
    app.setWindowIcon(QIcon("/home/wokinsark/PROJECT/NMonitorS/icon.ico"));

    qmlRegisterType<IO>("io", 1, 0, "IO");
    qmlRegisterType<WiFiHosts>("wifi.tplink", 1, 0, "WifiHosts");

    QQmlApplicationEngine engine;    
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));    

    return app.exec();
}
