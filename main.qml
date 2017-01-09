import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import wifi.tplink 1.0
import io 1.0
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

    property var clients: []
    property var clientAdd: null
    property var clientEdit: null
    property var deviceEdit: null

    property var model1F: ListModel {}
    property var model2F: ListModel {}
    property var model3F: ListModel {}

    Action{
        shortcut: "Ctrl+F"
        enabled: bStart.enabled && !isScan
        onTriggered: Main.buttonClick()
    }

    Action{
        shortcut: "Ctrl+Z"
        enabled: bStart.enabled && isScan
        onTriggered: Main.buttonClick()
    }

    menuBar: MenuBar {
        Menu {
            title: "Программа"
            MenuItem {
                text: "Сохранить всё"
                shortcut: "Ctrl+S"
                onTriggered: Main.save()
            }
            MenuItem {
                text: "Выход"
                shortcut: "Esc"
                onTriggered: close();
            }
        }

        Menu {
            title: "Пользователи"
            MenuItem {
                text: "Добавить"
                shortcut: "Ctrl+A"
                onTriggered: Main.menuClientAdd()
            }
            MenuItem {
                text: "Редактировать"
                shortcut: "Ctrl+E"
                onTriggered: Main.menuClientEdit()
            }
        }

        Menu {
            title: "Устройства"
            MenuItem {
                text: "Редактировать"
                shortcut: "Alt+E"
                onTriggered: Main.menuDeviceEdit()
            }
        }
    }

    IO{ id: file }

    GridLayout{
        id: gl
        anchors.fill: parent
        columns: 2
        rows: 2
        anchors.margins: 10
        GroupBox {
            id : gb1F
            title: "1 ЭТАЖ"
            Layout.fillHeight: true
            Layout.fillWidth: true
            TableView{
                id: table1F
                anchors.fill: parent
                TableViewColumn {
                    role: "number"
                    title: "№"
                    resizable: false
                    movable: false
                    width: table1F.width * 0.1
                }
                TableViewColumn {
                    role: "name"
                    title: "Абонент"
                    width: table1F.width * 0.85
                }
                model: model1F
            }
        }

        Item{
            id : gbStart
            Layout.fillHeight: true
            Layout.fillWidth: true
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 5
                Button{
                    id: bStart
                    implicitHeight: 50
                    Layout.fillWidth: true
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

                ProgressBar{
                    id: progress
                    minimumValue: 0
                    maximumValue: 5000
                    value: 0
                    Layout.fillWidth: true

                    Timer{
                        interval: 100
                        repeat: true
                        triggeredOnStart : true
                        running: isScan
                        onTriggered: progress.value += 100
                        onRunningChanged: progress.value = 0
                    }
                }

                GridLayout{
                    Layout.fillWidth: true
                    columns: 2
                    rows: 5
                    Text {
                        color: "darkBlue"
                        Layout.fillWidth: true
                        horizontalAlignment : Text.AlignRight
                        text: "1 Этаж"
                    }
                    Text {
                        id: tIndication1F
                        color: Main.TEXT_COLOR_NO_INFO
                        text: Main.TEXT_TEXT_NO_INFO
                    }
                    Text {
                        color: "darkBlue"
                        Layout.fillWidth: true
                        horizontalAlignment : Text.AlignRight
                        text: "2 Этаж"
                    }
                    Text {
                        id: tIndication2F
                        color: Main.TEXT_COLOR_NO_INFO
                        text: Main.TEXT_TEXT_NO_INFO
                    }
                    Text {
                        color: "darkBlue"
                        Layout.fillWidth: true
                        horizontalAlignment : Text.AlignRight
                        text: "3 Этаж"
                    }
                    Text {
                        id: tIndication3F
                        color: Main.TEXT_COLOR_NO_INFO
                        text: Main.TEXT_TEXT_NO_INFO
                    }
                    Text {
                        color: "blue"
                        Layout.fillWidth: true
                        horizontalAlignment : Text.AlignRight
                        text: "Абонентов всего"
                    }
                    Text {
                        text: tTotal
                    }
                    Text {
                        color: "blue"
                        Layout.fillWidth: true
                        horizontalAlignment : Text.AlignRight
                        text: "Абонентов в сети"
                    }
                    Text {
                        text: tOnline
                    }                    
                }
            }
        }

        GroupBox {
            id : gb2F
            title: "2 ЭТАЖ"
            Layout.fillHeight: true
            Layout.fillWidth: true

            TableView{
                id: table2F                 
                anchors.fill: parent
                TableViewColumn {
                    role: "number"
                    title: "№"
                    resizable: false
                    movable: false
                    width: table1F.width * 0.1
                }
                TableViewColumn {
                    role: "name"
                    title: "Абонент"
                    width: table1F.width * 0.85
                }
                model: model2F
            }
        }
        GroupBox {
            id : gb3F
            title: "3 ЭТАЖ"

            Layout.fillHeight: true
            Layout.fillWidth: true

            TableView{
                id: table3F
                anchors.fill: parent
                TableViewColumn {
                    role: "number"
                    title: "№"
                    resizable: false
                    movable: false
                    width: table1F.width * 0.1
                }
                TableViewColumn {
                    role: "name"
                    title: "Абонент"
                    width: table1F.width * 0.85
                }
                model: model3F
            }
        }
    }

    WifiHosts{
        id: hosts1F
        ip: "192.168.247.3"
        port: 80
        login: "Wokinsark"
        password: "LvfVwy0DPoijGL"
        onScanResult: Main.onScanResult1F(isPing, hostsMAC)
    }

    WifiHosts{
        id: hosts2F
        ip: "192.168.247.6"
        port: 80
        login: "Wokinsark"
        password: "es8aIXnDAET2Od"
        onScanResult: Main.onScanResult2F(isPing, hostsMAC)
    }

    WifiHosts{
        id: hosts3F
        ip: "192.168.247.1"
        port: 81
        login: "Wokinsark"
        password: "tD1VWkgGJVHLlw"
        onScanResult: Main.onScanResult3F(isPing, hostsMAC)
    }

    Timer{
        id: timer
        interval: 5 * 1000
//        triggeredOnStart : true
        running: isScan
        onTriggered: Main.timerTriggered()
    }

    onClosing: Main.exit(close)
    Component.onCompleted: Main.completed(Screen, height, width)

    MessageDialog {
        id: messageError
        standardButtons : StandardButton.Ok
        icon : StandardIcon.Warning
        title: "Внимание"
        text: "Важная информация"
    }

    MessageDialog {
        id: messageInformation
        standardButtons : StandardButton.Ok
        icon : StandardIcon.Information
        title: "Информация"
        text: "Важная информация"
    }
}
