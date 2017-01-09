var BUTTON_TEXT_START  = "НАЧАТЬ СБОР ИНФОРМАЦИИ ( Ctrl + F )"
var BUTTON_TEXT_WAIT   = "ОБРАБОТКА ИНФОРМАЦИИ"
var BUTTON_TEXT_STOP   = "ОСТАНОВИТЬ СБОР ИНФОРМАЦИИ ( Ctrl + Z )"
var BUTTON_COLOR_START = "green"
var BUTTON_COLOR_WAIT  = "magenta"
var BUTTON_COLOR_STOP  = "red"

function exit(close) {
    if(isScan){
        messageError.text = "Для закрытия программы остановите сканирование"
        messageError.open();
        close.accepted = false;
        return;
    }
    save();
}

function save(){
    if(file.clientsWrite(JSON.stringify(clients))){
        messageInformation.text = "Информация успешно сохранена"
        messageInformation.open();
    } else {
        messageError.text = "Ошибка сохранения информации"
        messageError.open();
    }
}

function completed(Screen, height, width){
    setX(Screen.width / 2 - width / 2);
    setY(Screen.height / 2 - height / 2);

    var data = file.clientsRead();
    clients = data ? JSON.parse(data) : [];
    updateTotal();
}

function updateTotal(){
    tTotal = getTotal();
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

    clientEdit.clients = clients;
    clientEdit.show();
}

function menuDeviceEdit(){
    if(!deviceEdit){
        deviceEdit = Qt.createComponent("DeviceEdit.qml").createObject(this);
    }

    deviceEdit.clients = clients;
    deviceEdit.show();
}

function onClientAdd(client){    
    clients.push(client);
    updateTotal();
}

function buttonClick(){
    if(isScan){
        bText  = BUTTON_TEXT_START;
        bColor = BUTTON_COLOR_START;

        model1F.clear();
        model2F.clear();
        model3F.clear();

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

    for(var index1F in mac1F){
        model1F.append({number:(+index1F + 1), name:getName(mac1F[index1F])});
    }

    for(var index2F in mac2F){
        model2F.append({number:(+index2F + 1), name:getName(mac2F[index2F])});
    }

    for(var index3F in mac3F){
        model3F.append({number:(+index3F + 1), name:getName(mac3F[index3F])});
    }

    tOnline = mac1F.length + mac2F.length + mac3F.length;

    bText    = BUTTON_TEXT_STOP;
    bColor   = BUTTON_COLOR_STOP;
    bEnabled = true;
}

function getName(mac){
    for(var i in clients){
        var client  = clients[i];
        var devices = client.devices;
        if(!devices){
            continue;
        }
        for(var j in devices){
            if(mac.trim() === devices[j].mac.trim()){
                return ("%1 %2").arg(client.lastName).arg(client.name);
            }
        }
    }
    return mac;
}

function getTotal(){
    var total = 0;
    for(var i in clients){
        var client  = clients[i];
        var devices = client.devices;
        if(!devices){
            continue;
        }
        total += devices.length;
    }
    return total;
}
