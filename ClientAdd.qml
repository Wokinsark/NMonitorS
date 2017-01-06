import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3

Window {
    visible: true
    title: "Добавить абонента"
    modality : Qt.ApplicationModal
    width: 300
    height: 130

    signal addClient(var client)

    Action{
        shortcut: "Esc"
        onTriggered: close()
    }

    Action{
        shortcut: "Ctrl+S"
        onTriggered: bAdd.clicked()
    }

    GridLayout{
        anchors.fill: parent
        anchors.margins: 5
        columns: 2
        rows: 4

        Text{
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment : Text.AlignVCenter
            horizontalAlignment : Text.AlignRight
            text:"Фамилия"
        }
        TextField{
            id: tfLastName
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: parent.width / 2
        }
        Text{
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment : Text.AlignVCenter
            horizontalAlignment : Text.AlignRight
            text:"Имя"
        }
        TextField{
            id: tfName
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: parent.width / 2
        }
        Text{
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment : Text.AlignVCenter
            horizontalAlignment : Text.AlignRight
            text:"Телефон"
        }
        TextField{
            id: tfTelephone
            Layout.fillWidth: true
            Layout.fillHeight: true            
            implicitWidth: parent.width / 2
        }
        Button{
            id: bAdd
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: parent.width / 2
            text:"Добавить (Ctrl+S)"
            Keys.onReturnPressed: clicked()
            Keys.onSpacePressed: clicked()
            onClicked: {
                addClient({lastName:tfLastName.text, name:tfName.text, telephone:tfTelephone.text})
                close();
            }
        }
        Button{
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: parent.width / 2
            text:"Отмена (Esc)"
            Keys.onReturnPressed: clicked()
            Keys.onSpacePressed: clicked()
            onClicked: close()
        }
    }

    Component.onCompleted: restart()
    onVisibleChanged: restart()

    function restart(){
        if(visible){
            width  = 300
            height = 130
            setX(Screen.width / 2 - width / 2);
            setY(Screen.height / 2 - height / 2);
            tfLastName.text  = "";
            tfName.text      = "";
            tfTelephone.text = "+380";
            tfLastName.forceActiveFocus();
        }
    }
}
