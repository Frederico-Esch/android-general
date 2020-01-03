import 'dart:async';
import 'package:blue/pages/Discovery_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blue/pages/Chat_Page.dart';
import 'package:blue/pages/Select_Bonded_Device_Page.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  BluetoothState  _estado = BluetoothState.UNKNOWN;
  String _name = "";
  String _address = "";
  Timer _tempoDescoberta;
  int _temporestante = 0;
  bool _autoAcceptPairingRequests = false;



  @override
  void initState() {
    super.initState();
    //pega o estado
    FlutterBluetoothSerial.instance.state.then((state){
      setState(() { _estado = state; });
    });
    
    Future.doWhile(() async {
      //espera se o adaptador não estiver abilitado
      if(await FlutterBluetoothSerial.instance.isEnabled){
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_){
      // atualiza o address endereço
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() { _address = address; });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() { _name = name; });
    });

    //escuta mudanças de estado futuras
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state){
      setState(() {
        _estado = state;

        //modo de descoberta fica desabilitado quando bluetooth é desabilitado
        _tempoDescoberta = null;
        _temporestante = 0;

      });
    });
  }


  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    //_collectingTask?.dispose();
    _tempoDescoberta?.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[

              ListTile(
                title: const Text('General', textAlign: TextAlign.center,),
              ),

              Divider(),

              SwitchListTile(
                title: const Text('Habilitar Bluetooth',),
                value: _estado.isEnabled,
                activeColor: Colors.red,
                inactiveThumbColor: Colors.redAccent[100],
                onChanged: (bool valor){
                  // faz o request e atualiza com o valor true, então
                  future()async{
                    if(valor) await FlutterBluetoothSerial.instance.requestEnable();
                    else await FlutterBluetoothSerial.instance.requestDisable();
                  }
                  future().then((_){
                    setState((){});
                  });
                },
              ),
              
              ListTile(
                title: const Text('Estado Bluetoot'),
                subtitle: Text(_estado.toString()),
                trailing: RaisedButton(
                  child: const Text('Config'),
                  onPressed: () { 
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                ),
              ),

              Divider(
                thickness: 4, color:Colors.black, height: 2,
              ),

              ListTile(
                title: const Text("Adaptador Local Endereço/Nome"),
                subtitle: Text("$_address/$_name"),
              ),

              Divider(
                thickness: 4, color:Colors.black, height: 2,
              ),
              
              SwitchListTile(
                activeColor: Colors.red,
                inactiveThumbColor: Colors.amber,
                title: const Text('Auto-try specific pin when pairing'),
                subtitle: const Text('Pin 1234'),
                value: _autoAcceptPairingRequests,
                onChanged: (bool value) {
                  setState(() {
                    _autoAcceptPairingRequests = value;
                  });
                  if (value) {
                    FlutterBluetoothSerial.instance.setPairingRequestHandler((BluetoothPairingRequest request) {
                      print("Trying to auto-pair with Pin 1234");
                      if (request.pairingVariant == PairingVariant.Pin) {
                        return Future.value("1234");
                      }
                      return null;
                    });
                  }
                  else {
                    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
                  }
                },
              ),

              ListTile(
                title: RaisedButton(
                  child: const Text('Dispositivos Descobertos'),
                  onPressed: () async {
                    final BluetoothDevice deviceSelecionado = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){return DiscoveryPage();}) 
                    );

                    if(deviceSelecionado != null) Fluttertoast.showToast(msg:'Discovery -> selecionado ${deviceSelecionado.address}', toastLength: Toast.LENGTH_LONG);
                    else Fluttertoast.showToast(msg:'Discovery -> nenhum device selecionado', toastLength: Toast.LENGTH_LONG,  ) ;


                  },
                )
              ),

              ListTile(
                title: RaisedButton(
                  child: Text("Conecte para entrar no chat (devices pariados)"), //TODO CHANGE FROM CHAT TO SEND MESSAGE TO HC-06
                  onPressed: ()async{
                    final BluetoothDevice deviceSelecionado = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){return SelectBondedDevicePage(checkAvailability : false);}) 
                    );
                    if(deviceSelecionado != null) {
                      Fluttertoast.showToast(msg:"Conectar -> selecionado: ${deviceSelecionado.address}");
                      _startChat(context, deviceSelecionado);
                    }else Fluttertoast.showToast(msg: "Conectar -> nenhum device selecionado");
                  },
                ),
              )



            ],
          ),
        ),
      )
    );
  }
  void _startChat(BuildContext context, BluetoothDevice blueDevice){ 
    Navigator.of(context).push(MaterialPageRoute(builder: (context) { return ChatPage(server: blueDevice); })); //TODO REALLY IMPLEMENT
  }
}