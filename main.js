var BUTTON_TEXT_START  = "НАЧАТЬ ( Ctrl + F )"
var BUTTON_TEXT_WAIT   = "ОЖИДАЙТЕ"
var BUTTON_TEXT_STOP   = "ОСТАНОВИТЬ ( Ctrl + Z )"

var BUTTON_COLOR_START = "red"
var BUTTON_COLOR_WAIT  = "darkBlue"
var BUTTON_COLOR_STOP  = "green"

var TEXT_COLOR_CONNECTION   = "darkGreen"
var TEXT_COLOR_NOCONNECTION = "red"
var TEXT_COLOR_NO_INFO      = "darkBlue"

var TEXT_TEXT_CONNECTION   = "ЕСТЬ СВЯЗЬ"
var TEXT_TEXT_NOCONNECTION = "НЕТ СВЯЗИ"
var TEXT_TEXT_NO_INFO      = "НЕТ ИНФОРМАЦИИ"

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

        tIndication1F.text  = TEXT_TEXT_NO_INFO;
        tIndication1F.color = TEXT_COLOR_NO_INFO;

        tIndication2F.text  = TEXT_TEXT_NO_INFO;
        tIndication2F.color = TEXT_COLOR_NO_INFO;

        tIndication3F.text  = TEXT_TEXT_NO_INFO;
        tIndication3F.color = TEXT_COLOR_NO_INFO;

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

function onScanResult1F(ping, hosts){
    if(ping){
        tIndication1F.text  = TEXT_TEXT_CONNECTION;
        tIndication1F.color = TEXT_COLOR_CONNECTION;

        for(var index1F in hosts){
            model1F.append({number:(+index1F + 1), name:getName(hosts[index1F])});
        }
    } else {
        tIndication1F.text  = TEXT_TEXT_NOCONNECTION;
        tIndication1F.color = TEXT_COLOR_NOCONNECTION;
    }

    hosts2F.start();
}

function onScanResult2F(ping, hosts){
    if(ping){
        tIndication2F.text  = TEXT_TEXT_CONNECTION;
        tIndication2F.color = TEXT_COLOR_CONNECTION;

        for(var index2F in hosts){
            model2F.append({number:(+index2F + 1), name:getName(hosts[index2F])});
        }
    } else {
        tIndication2F.text  = TEXT_TEXT_NOCONNECTION;
        tIndication2F.color = TEXT_COLOR_NOCONNECTION;
    }

    hosts3F.start();
}

function onScanResult3F(ping, hosts){
    if(ping){
        tIndication3F.text  = TEXT_TEXT_CONNECTION;
        tIndication3F.color = TEXT_COLOR_CONNECTION;

        for(var index3F in hosts){
            model3F.append({number:(+index3F + 1), name:getName(hosts[index3F])});
        }
    } else {
        tIndication3F.text  = TEXT_TEXT_NOCONNECTION;
        tIndication3F.color = TEXT_COLOR_NOCONNECTION;
    }

    tOnline = table1F.rowCount + table2F.rowCount + hosts.length;

    progress.value = 0;
    timer.restart();

    bText    = BUTTON_TEXT_STOP;
    bColor   = BUTTON_COLOR_STOP;
    bEnabled = true;
}

function timerTriggered(){
    bEnabled = false;
    bText    = BUTTON_TEXT_WAIT;
    bColor   = BUTTON_COLOR_WAIT;

    model1F.clear();
    model2F.clear();
    model3F.clear();

//    hosts1F.startScan();
    hosts1F.start();
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
