#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "wifihosts.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<WiFiHosts>("wifi.tplink", 1, 0, "WifiHosts");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
