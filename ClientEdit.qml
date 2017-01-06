import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick 2.7

Window {
    visible: false
    width: 600
    height: 400
    title: "Редактировать абонентов"
    modality : Qt.ApplicationModal

    property var clients: null

    Action{
        shortcut: "Esc"
        onTriggered: close()
    }

    Action{
        shortcut: "Ctrl+S"
        enabled: bAdd.enabled
        onTriggered: close()
    }

    Action{
        shortcut: "Delete"
        enabled: bRemove.enabled
        onTriggered: close()
    }

    RowLayout{
        anchors.fill: parent
        TableView{
            id: tbClients
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            implicitWidth: parent.width / 2
            focus: true
            TableViewColumn {
                role: "id"
                title: "№"
                resizable: false
                movable: false
                width: tbClients.width * 0.1
            }
            TableViewColumn {
                role: "lastName"
                title: "Фамилия"
                width: tbClients.width * 0.8
            }
            model: clients
            onCurrentRowChanged: selectClient(currentRow);
        }

        GridLayout{
            anchors.margins: 5
            anchors.top: parent.top
            columns: 2
            rows: 4

            Text{
                Layout.fillWidth: true
                verticalAlignment : Text.AlignVCenter
                horizontalAlignment : Text.AlignRight
                text:"Фамилия"
            }
            TextField{
                id: tfLastName
                Layout.fillWidth: true
            }
            Text{
                Layout.fillWidth: true
                verticalAlignment : Text.AlignVCenter
                horizontalAlignment : Text.AlignRight
                text:"Имя"
            }
            TextField{
                id: tfName
                Layout.fillWidth: true
            }
            Text{
                Layout.fillWidth: true
                verticalAlignment : Text.AlignVCenter
                horizontalAlignment : Text.AlignRight
                text:"Телефон"
            }
            TextField{
                id: tfTelephone
                Layout.fillWidth: true
            }
            Button{
                id: bAdd
                Layout.fillWidth: true
                text:"Сохранить (Ctrl+S)"
                enabled: false
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                onClicked: {
//                    addClient({lastName:tfLastName.text, name:tfName.text, telephone:tfTelephone.text})
//                    close();
                }
            }
            Button{
                id: bRemove
                enabled: false
                Layout.fillWidth: true
                text:"Удалить (Delete)"
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                onClicked: close()
            }
        }
    }

    onVisibleChanged: restart()

    function restart(){
        if(visible){
            setX(Screen.width / 2 - width / 2);
            setY(Screen.height / 2 - height / 2);

            if(clients && clients.length){
                tbClients.forceActiveFocus();
                tbClients.selection.select(0);
                tbClients.currentRow = 0;
            }

            selectClient(tbClients.currentRow);
        }
    }

    function selectClient(index){
        if(index < 0){
            tfLastName.text  = "";
            tfName.text      = "";
            tfTelephone.text = "";
            bAdd.enabled    = false;
            bRemove.enabled = false;
            return;
        }

        var client = clients[index];
        tfLastName.text  = client.lastName;
        tfName.text      = client.name;
        tfTelephone.text = client.telephone;

        bAdd.enabled    = true;
        bRemove.enabled = true;
    }
}
