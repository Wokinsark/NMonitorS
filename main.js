var BUTTON_TEXT_START  = "НАЧАТЬ СБОР ИНФОРМАЦИИ ( Ctrl + F )"
var BUTTON_TEXT_WAIT   = "ОБРАБОТКА ИНФОРМАЦИИ"
var BUTTON_TEXT_STOP   = "ОСТАНОВИТЬ СБОР ИНФОРМАЦИИ ( Ctrl + Z )"
var BUTTON_COLOR_START = "green"
var BUTTON_COLOR_WAIT  = "magenta"
var BUTTON_COLOR_STOP  = "red"

function exit() {
    if(isScan){
        messageError.open();
        return;
    }
    Qt.quit();
}

function menuClientAdd(){
    if(clientAdd){
        clientAdd.show();
    } else {
        clientAdd = Qt.createComponent("ClientAdd.qml").createObject(this);
        clientAdd.addClient.connect(onClientAdd);
    }
}

function menuClientEdit(){
    if(!clientEdit){
        clientEdit = Qt.createComponent("ClientEdit.qml").createObject(this);
    }

    console.log("@@@", JSON.stringify(clients));
    clientEdit.clients = clients;
    clientEdit.show();
}

function onClientAdd(client){
    client.id = getClientId();
    clients.push(client);
    tTotal = clients.length;
}

function getClientId(){
    var next = 1;
    for(var i in clients){
        var client = clients[i];
        if(+client.id !== next){
            return next;
        }
        next++;
    }
    return next;
}

function buttonClick(){
    if(isScan){
        bText  = BUTTON_TEXT_START;
        bColor = BUTTON_COLOR_START;

        model1F.clear();
        model2F.clear();
        model3F.clear();
        modelOF.clear();

        tOnline = 0;
    } else {
        bText  = BUTTON_TEXT_STOP;
        bColor = BUTTON_COLOR_STOP;
    }
    isScan = !isScan;
}

function timerTriggered(){
    bEnabled = false;
    bText    = BUTTON_TEXT_WAIT;
    bColor   = BUTTON_COLOR_WAIT;

    var mac1F = hosts1F.getAllMAC();
    var mac2F = hosts2F.getAllMAC();
    var mac3F = hosts3F.getAllMAC();

    model1F.clear();
    model2F.clear();
    model3F.clear();
    modelOF.clear();

    for(var index1F in mac1F){
        model1F.append({number:(+index1F + 1), mac:mac1F[index1F], name:""});
    }

    for(var index2F in mac2F){
        model2F.append({number:(+index2F + 1), mac:mac2F[index2F], name:""});
    }

    for(var index3F in mac3F){
        model3F.append({number:(+index3F + 1), mac:mac3F[index3F], name:""});
    }

    tOnline = mac1F.length + mac2F.length + mac3F.length;

    bText    = BUTTON_TEXT_STOP;
    bColor   = BUTTON_COLOR_STOP;
    bEnabled = true;
}
