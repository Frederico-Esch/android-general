import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import "package:blue/services/Bluetooth_Device_List_Entry.dart";


class DiscoveryPage extends StatefulWidget {
  // se for true a descoberta começa no que a pagina abrir, do contrário user precisa pressiona um botão
  final bool start;
  DiscoveryPage({this.start = true});
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {

  StreamSubscription<BluetoothDiscoveryResult> _streamResultados;
  List<BluetoothDiscoveryResult> resultados = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  _DiscoveryPageState();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if(isDiscovering){
      _startDiscovery(); 
    }

  }

  void _restartDiscovery(){
    
    setState(() {
      resultados.clear();
      isDiscovering = true;
    });
    _startDiscovery();

  }

  void _startDiscovery(){

    _streamResultados = FlutterBluetoothSerial.instance.startDiscovery().listen((r){
      setState(() { resultados.add(r); });
    });

    _streamResultados.onDone((){
      setState(() { isDiscovering = false; });
    });

  }

  


  @override
  void dispose() {

    //Evitar Memory Leaks
    _streamResultados?.cancel();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(


      appBar: AppBar(title: isDiscovering ? Text('Proucurando dispositivos') : Text("Dispositivos Descobertos"), centerTitle: true,
        actions: <Widget>[
          isDiscovering
          ? FittedBox(child: Container(margin: EdgeInsets.all(16), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent[400]),),))
          : IconButton(icon: Icon(Icons.replay), onPressed: _restartDiscovery),
        ],
      ),


      body: ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (BuildContext context, index){
          BluetoothDiscoveryResult resultado = resultados[index];
          return BluetoothDeviceListEntry(
            device: resultado.device,
            rssi: resultado.rssi,
            onTap: () {Navigator.of(context).pop(resultado.device);},
            onLongPress: () async {
              try{
                bool pareado = false;
                if(resultado.device.isBonded){
                  Fluttertoast.showToast(msg: "Despareando ${resultado.device.name}");
                  await FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(resultado.device.address);
                  Fluttertoast.showToast(msg: "Sucesso!");
                }else{
                  Fluttertoast.showToast(msg: "Pareando ${resultado.device.name}");
                  pareado = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(resultado.device.address);
                  Fluttertoast.showToast(msg: "A tentativa de pareamento ${pareado ? 'funcionou' : 'falhou'}");
                }
                setState(() {
                  resultados[resultados.indexOf(resultado)] = BluetoothDiscoveryResult(
                    device: BluetoothDevice(
                      name: resultado.device.name ?? '',
                      address: resultado.device.address,
                      type: resultado.device.type,
                      bondState: pareado ? BluetoothBondState.bonded : BluetoothBondState.none
                    ),
                    rssi: resultado.rssi
                  );
                });
              }catch(e){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("Um erro ocorreu durante o (Des)Pareamento"),
                      content: Text("${e.toString()}"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: (){Navigator.of(context).pop();}
                        )
                      ],
                    );
                  }
                );
              }
            }       
          ); 
        },
      ),
    );
  }
}