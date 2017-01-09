import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "main.js" as Main

Window {
    visible: false   
    title: "Редактировать устройства"
    modality : Qt.ApplicationModal

    property var clients: null
    property var deviceAdd: null

    property var devices: ListModel {}

    Action{
        shortcut: "Esc"
        onTriggered: close()
    }

    Action{
        shortcut: "Alt+A"
        enabled: bAdd.enabled
        onTriggered: bAdd.clicked()
    }

    Action{
        shortcut: "Delete"
        enabled: bRemove.enabled
        onTriggered: bRemove.clicked()
    }

    ComboBox{
        id: cbNames
        anchors.margins: 5
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        textRole: "lastName"
        model: clients
        onCurrentIndexChanged: updateDevices()
    }

    TableView{
        id: tbDevices
        anchors.top: cbNames.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: rl.top
        anchors.margins: 5

        TableViewColumn {
            role: "id"
            title: "№"
            resizable: false
            movable: false
            width: tbDevices.width * 0.1
        }
        TableViewColumn {
            role: "ip"
            title: "IP"
            width: tbDevices.width * 0.44
        }
        TableViewColumn {
            role: "mac"
            title: "MAC"
            width: tbDevices.width * 0.44
        }        
        model: devices
        onFocusChanged: {
            if(focus && tbDevices.rowCount){
                if(currentRow === -1){
                    currentRow = 0;
                }
                tbDevices.selection.clear();
                tbDevices.selection.select(currentRow);
            }
        }
    }

    RowLayout{
        id:rl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
        Button{
            id: bAdd
            Layout.fillWidth: true
            text: "Добавить устройство (Alt+A)"
            onClicked: buttonAddClick()
        }

        Button{
            id: bRemove
            Layout.fillWidth: true
            text: "Удалить устройство (Delete)"
            onClicked: buttonRemoveClick()
        }
    }

    onVisibleChanged:{
        if(visible){
            width  = 450;
            height = 220;
            setX(Screen.width / 2 - width / 2);
            setY(Screen.height / 2 - height / 2);
            bAdd.enabled = false;
            bRemove.enabled = false;
            cbNames.currentIndex = -1;
            cbNames.forceActiveFocus();
        }
    }

    function buttonAddClick(){
        if(!deviceAdd){
            deviceAdd = Qt.createComponent("DeviceAdd.qml").createObject(this);
            deviceAdd.addDevice.connect(onDeviceAdd);
        }

        deviceAdd.occupiedIP = getOccupiedIP();        
        deviceAdd.show();
    }

    function buttonRemoveClick(){
        if(tbDevices.currentRow === -1){
            messageError.text = "Для удаления выберите устройство";
            messageError.open();
            return;
        }

        messageQuestion.open();
    }

    function onDeviceAdd(device){
        var client = clients[cbNames.currentIndex];
        if(!client){
            return;
        }

        if(!client.devices){
            client.devices = [];
        }

        client.devices.push(device);
        Main.updateTotal();
        updateDevices();
    }


    function updateDevices(){
        devices.clear();

        if(cbNames.currentIndex === -1 || !clients){
            return;
        }

        var client = clients[cbNames.currentIndex];
        if(!client){
            return;
        }

        for(var i in client.devices){
            devices.append({id:(+i + 1), ip:client.devices[i].ip, mac:client.devices[i].mac});
        }

        bAdd.enabled = true;
        bRemove.enabled = true;

        tbDevices.forceActiveFocus();       
    }

    function getOccupiedIP(){
        var occupiedIP = [];
        for(var i in clients){
            var client = clients[i];
            for(var j in client.devices){
                occupiedIP.push(client.devices[j].ip);
            }
        }
        return occupiedIP;
    }

    function removeDevice(index){
        if(index < 0){
            return;
        }

        var client = clients[cbNames.currentIndex];
        client.devices.splice(index, 1);
        Main.updateTotal();
        updateDevices();
    }

    MessageDialog {
        id: messageError
        standardButtons : StandardButton.Ok
        icon : StandardIcon.Warning
        title: "Внимание"
        text: "Важная информация"
    }


    MessageDialog {
        id: messageQuestion
        standardButtons :  StandardButton.Cancel | StandardButton.Yes
        icon : StandardIcon.Question
        title: "Вопрос"
        text: "Удалить выбранное устройство?"
        onYes: removeDevice(tbDevices.currentRow)
    }
}
