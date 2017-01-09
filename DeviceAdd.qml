import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

Window {
    visible: false
    title: "Добавить устройство"
    modality : Qt.ApplicationModal

    property var occupiedIP: []
    property var freeIP: []

    signal addDevice(var device)

    Action{
        shortcut: "Esc"
        onTriggered: bCancel.clicked()
    }

    Action{
        shortcut: "Ctrl+S"
        onTriggered: bSave.clicked()
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 5

    TableView{
        id: tableIP
        Layout.fillHeight: true
        Layout.fillWidth: true
        TableViewColumn {
            role: "ip"
            title: "Свободные IP адреса"
            resizable: false
            movable: false
        }
        onCurrentRowChanged: tfIP.text = currentRow < 0 ? "192.168.247." : freeIP[currentRow].ip;
        model: freeIP
    }

    GridLayout{
        id:gl
        columns: 2
        rows: 3
        Layout.fillHeight: true
        Layout.fillWidth: true
        Text{
            Layout.fillWidth: true
            verticalAlignment : Text.AlignVCenter
            horizontalAlignment : Text.AlignRight
            text:"IP"
        }
        TextField{
            id: tfIP
            Layout.fillWidth: true
        }
        Text{
            Layout.fillWidth: true
            verticalAlignment : Text.AlignVCenter
            horizontalAlignment : Text.AlignRight
            text:"MAC"
        }
        TextField{
            id: tfMAC
            Layout.fillWidth: true
        }
        Button{
            id: bSave
            Layout.fillWidth: true
            text:"Сохранить (Ctrl+S)"
            Keys.onReturnPressed: clicked()
            Keys.onSpacePressed: clicked()
            onClicked: {
                addDevice({ip:tfIP.text,mac:tfMAC.text})
                close()
            }
        }
        Button{
            id: bCancel
            Layout.fillWidth: true
            text:"Отмена (Esc)"
            Keys.onReturnPressed: clicked()
            Keys.onSpacePressed: clicked()
            onClicked: close()
        }
    }
    }

    onVisibleChanged:{
        if(visible){
            width  = 300;
            height = 220;
            setX(Screen.width / 2 - width / 2);
            setY(Screen.height / 2 - height / 2);
            tfIP.text = "192.168.247.";
            freeIP = getFreeIP();
            tfMAC.text = "";
            tfIP.forceActiveFocus();
            if(freeIP.length){
                tableIP.selection.clear();
                tableIP.selection.select(0);
                tableIP.currentRow = 0;
                tableIP.forceActiveFocus();
            }
        }
    }

    function getFreeIP(){
        var freeIP = [];
        for(var i = 2; i < 255; i++){
            var ip = "192.168.247.%1".arg(i);
            if(occupiedIP.indexOf(ip) !== -1){
                continue;
            }
            freeIP.push({ip:ip});
        }
        return freeIP;
    }

}
