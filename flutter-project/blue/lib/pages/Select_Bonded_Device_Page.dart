import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:blue/services/Bluetooth_Device_List_Entry.dart';


class SelectBondedDevicePage extends StatefulWidget {
  final bool checkAvailability;
  SelectBondedDevicePage({this.checkAvailability = true});
  @override
  _SelectBondedDevicePageState createState() => _SelectBondedDevicePageState();
}

//é fora mesmo
enum _Disponibilidade{
  no,
  maybe,
  yes
}
//é fora mesmo

class _DispositivoComDisponibilidade extends BluetoothDevice{
  BluetoothDevice dispositivo;
  _Disponibilidade dispo;
  int rssi;
  _DispositivoComDisponibilidade(this.dispositivo, this.dispo, [this.rssi]);
}


class _SelectBondedDevicePageState extends State<SelectBondedDevicePage> {

  List<_DispositivoComDisponibilidade> dispositivos = List<_DispositivoComDisponibilidade>();

  //disponibilidade
  StreamSubscription<BluetoothDiscoveryResult> _streamDescoberta;
  bool isDiscovering;

  _SelectBondedDevicePageState();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.checkAvailability;

    if(isDiscovering){
      startDiscovery();
    }

    //Preparar uma lista dos dispositivos pareados
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> pareados){
      setState(() {
        dispositivos = pareados.map((dispositivo) => _DispositivoComDisponibilidade(dispositivo, widget.checkAvailability ? _Disponibilidade.maybe : _Disponibilidade.yes)).toList();
      });
    });
  }
  
  void _restartDiscovery(){
    setState(() {
      isDiscovering = true;
    });

    startDiscovery();
  }

  void startDiscovery(){
    _streamDescoberta = FlutterBluetoothSerial.instance.startDiscovery().listen((r){
      setState(() {
        Iterator i = dispositivos.iterator;
        while(i.moveNext()){
          var _dispositivo = i.current;
          if(_dispositivo.dispositivo == r.device){
            _dispositivo.dispo = _Disponibilidade.yes;
            _dispositivo.rssi = r.rssi;
          }
        }
      });
    });

    _streamDescoberta.onDone((){
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    //impedir vazamento de memoria (memory leak)
    _streamDescoberta?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> lista = dispositivos.map((_dispositivo) => BluetoothDeviceListEntry(
      device: _dispositivo.dispositivo,
      rssi: _dispositivo.rssi,
      enabled: _dispositivo.dispo == _Disponibilidade.yes,
      onTap: (){
        Navigator.of(context).pop(_dispositivo.dispositivo);
      },
    )).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione um dispositivo"), centerTitle: true,
        actions: <Widget>[
          (
            isDiscovering 
            ?FittedBox(child:Container(
              margin: EdgeInsets.all(16),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent[400]),
              )))
            :IconButton(
              icon: Icon(Icons.replay),
              onPressed: _restartDiscovery,
            )
          )
        ],
      ),
      body: ListView(children: lista)
    );
  }
}