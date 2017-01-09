import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick 2.7
import QtQuick.Dialogs 1.2
import "clientedit.js" as ClientEdit

Window {
    visible: false
    width: 600
    height: 400
    title: "Редактировать абонентов"
    modality : Qt.ApplicationModal

    property var clients: []

    Action{
        shortcut: "Esc"
        onTriggered: close()
    }

    Action{
        shortcut: "Ctrl+S"
        enabled: bSave.enabled
        onTriggered: bSave.clicked()
    }

    Action{
        shortcut: "Delete"
        enabled: bRemove.enabled
        onTriggered: bRemove.clicked()
    }

    RowLayout{
        anchors.fill: parent
        TableView{
            id: tbClients
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: gl.left
            anchors.margins: 5
            implicitWidth: parent.width / 2 - 10
            focus: true
            TableViewColumn {
                role: "lastName"
                title: "Фамилия"               
            }
            model: clients
            onCurrentRowChanged: ClientEdit.selectClient(currentRow);
        }

        GridLayout{
            id:gl
            anchors.margins: 5
            anchors.top: parent.top
            anchors.right: parent.right
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
                id: bSave
                Layout.fillWidth: true
                text:"Сохранить (Ctrl+S)"
                enabled: false
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                onClicked: ClientEdit.saveClient(tbClients.currentRow)
            }
            Button{
                id: bRemove
                enabled: false
                Layout.fillWidth: true
                text:"Удалить (Delete)"
                Keys.onReturnPressed: clicked()
                Keys.onSpacePressed: clicked()
                onClicked: messageQuestion.open()
            }
        }
    }

    MessageDialog {
        id: messageQuestion
        standardButtons :  StandardButton.Cancel | StandardButton.Yes
        icon : StandardIcon.Question
        title: "Вопрос"
        text: "Удалить выбранного абонента?"
        onYes: ClientEdit.removeClient(tbClients.currentRow)
    }

    onVisibleChanged:{
        if(visible){
            width  = 600;
            height = 400;
            ClientEdit.restart(Screen, height, width);
        }
    }
}
