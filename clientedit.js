function selectClient(index){
    if(index < 0){
        tfLastName .text = "";
        tfName     .text = "";
        tfTelephone.text = "";
        bSave   .enabled = false;
        bRemove .enabled = false;
        return;
    }

    var client = clients[index];
    tfLastName .text = client.lastName;
    tfName     .text = client.name;
    tfTelephone.text = client.telephone;

    bSave  .enabled = true;
    bRemove.enabled = true;
}

function saveClient(index){
    if(index < 0){
        return;
    }

    clients[index].lastName  = tfLastName.text;
    clients[index].name      = tfName.text;
    clients[index].telephone = tfTelephone.text;

    close();
}

function removeClient(index){
    if(index < 0){
        return;
    }

    clients.splice(index, 1);

    main.tTotal = clients.length;
    close();
}

function restart(Screen, height, width){
    setX(Screen.width / 2 - width / 2);
    setY(Screen.height / 2 - height / 2);

    if(clients && clients.length){
        tbClients.forceActiveFocus();
        tbClients.selection.clear();
        tbClients.selection.select(0);
        tbClients.currentRow = 0;
    }

    selectClient(tbClients.currentRow);
}
