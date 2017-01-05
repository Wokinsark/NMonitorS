import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import wifi.tplink 1.0

import "main.js" as Main

ApplicationWindow {
    id : main
    visible: true
    width: 640
    height: 480
    title: qsTr("Мониторинг сети")

    property bool   isScan: false
    property bool bEnabled: true
    property string  bText: Main.BUTTON_TEXT_START
    property string bColor: Main.BUTTON_COLOR_START
    property int    tTotal: 0
    property int   tOnline: 0

    property var model1F: ListModel {}
    property var model2F: ListModel {}
    property var model3F: ListModel {}
    property var modelOF: ListModel {}

    menuBar: MenuBar {
        Menu {
            title: "Программа"
            MenuItem {
                text: "Выход"
                shortcut: "Esc"
                onTriggered: close();
            }
        }

        Menu {
            title: "Пользователи"
            MenuItem { text: "Добавить" }
            MenuItem { text: "Редактировать" }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        RowLayout{
            id: rl
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            GroupBox{
                id : gbTotal
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: gbProgress.left
                anchors.bottom: parent.bottom
                Layout.fillWidth: true
                GridLayout{
                    anchors.fill: parent
                    columns: 2
                    rows: 2
                    Text {
                        color: "blue"
                        text: "Всего"
                    }
                    Text {
                        text: tTotal
                    }
                    Text {
                        color: "blue"
                        text: "В сети"
                    }
                    Text {
                        text: tOnline
                    }
                }
            }
            GroupBox{
                id: gbProgress
                anchors.top: parent.top
                anchors.left: gbTotal.right
                anchors.right: gbStart.left
                anchors.bottom: parent.bottom
                Layout.fillWidth: true
                ProgressBar{
                    id: progress
                    minimumValue: 0
                    maximumValue: 5000
                    value: 0
                    anchors.horizontalCenter : parent.horizontalCenter
                    anchors.verticalCenter : parent.verticalCenter
                    width: parent.width
                    Layout.fillWidth: true

                    Timer{
                        interval: 100
                        repeat: true
                        triggeredOnStart : true
                        running: isScan
                        onTriggered: progress.value = progress.value === 5000 ? 0 : progress.value += 100
                        onRunningChanged: progress.value = 0
                    }
                }
            }
            GroupBox{
                id : gbStart
                anchors.top: parent.top
                anchors.left: gbProgress.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                Layout.fillWidth: true

                Button{
                    anchors.fill: parent
                    enabled: bEnabled
                    style: ButtonStyle {
                        background: Rectangle {
                            color: bColor
                            radius: 4
                        }
                    }
                    Text{
                        anchors.fill: parent
                        color: "white"
                        verticalAlignment :Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter
                        text:bText
                    }
                    onClicked: Main.buttonClick()
                }
            }
        }

        GridLayout{
            id: gl
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rl.bottom
            anchors.bottom: parent.bottom
            columns: 2
            rows: 2

            GroupBox {
                id : gb1F
                title: "1 ЭТАЖ"
                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitWidth: gl.width / 2 - 10
                TableView{
                    id: table1F
                    anchors.fill: parent
                    implicitWidth: parent.width
                    TableViewColumn {
                        role: "number"
                        title: "№"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.1
                    }
                    TableViewColumn {
                        role: "mac"
                        title: "MAC"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.5
                    }
                    TableViewColumn {
                        role: "name"
                        title: "Фамилия Имя"
                        width: table1F.width * 0.7
                    }
                    model: model1F
                }


            }
            GroupBox {
                id : gb2F
                title: "2 ЭТАЖ"
                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitWidth: gl.width / 2 - 10

                TableView{
                    id: table2F
                    anchors.fill: parent
                    implicitWidth: parent.width
                    TableViewColumn {
                        role: "number"
                        title: "№"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.1
                    }
                    TableViewColumn {
                        role: "mac"
                        title: "MAC"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.5
                    }
                    TableViewColumn {
                        role: "name"
                        title: "Фамилия Имя"
                        width: table1F.width * 0.7
                    }
                    model: model2F
                }
            }
            GroupBox {
                id : gb3F
                title: "3 ЭТАЖ"

                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitWidth: gl.width / 2 - 10

                TableView{
                    id: table3F
                    anchors.fill: parent
                    implicitWidth: parent.width
                    TableViewColumn {
                        role: "number"
                        title: "№"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.1
                    }
                    TableViewColumn {
                        role: "mac"
                        title: "MAC"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.5
                    }
                    TableViewColumn {
                        role: "name"
                        title: "Фамилия Имя"
                        width: table1F.width * 0.7
                    }
                    model: model3F
                }
            }
            GroupBox {
                id : gbOF
                title: "ТРЕБУЮЩИЕ ВНИМАНИЕ"

                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitWidth: gl.width / 2 - 10

                TableView{
                    id: tableOF
                    anchors.fill: parent
                    implicitWidth: parent.width
                    TableViewColumn {
                        role: "number"
                        title: "№"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.1
                    }
                    TableViewColumn {
                        role: "mac"
                        title: "MAC"
                        resizable: false
                        movable: false
                        width: table1F.width * 0.5
                    }
                    TableViewColumn {
                        role: "name"
                        title: "Фамилия Имя"
                        width: table1F.width * 0.7
                    }
                    model: modelOF
                }
            }
        }
    }

    WifiHosts{
        id: hosts1F
        ip: "192.168.247.3"
        port: 80
        login: "Wokinsark"
        password: "LvfVwy0DPoijGL"
    }

    WifiHosts{
        id: hosts2F
        ip: "192.168.247.6"
        port: 80
        login: "Wokinsark"
        password: "es8aIXnDAET2Od"
    }

    WifiHosts{
        id: hosts3F
        ip: "192.168.247.1"
        port: 81
        login: "Wokinsark"
        password: "tD1VWkgGJVHLlw"
    }

    Timer{
        interval: 5 * 1000
        repeat: true
        triggeredOnStart : true
        running: isScan
        onTriggered: Main.timerTriggered()
    }

    onClosing: {
        close.accepted = false;
        Main.exit();
    }

    MessageDialog {
        id: messageError
        standardButtons : StandardButton.Ok
        icon : StandardIcon.Warning
        title: "Внимание"
        text: "Для закрытия программы остановите сканирование"
    }
}
