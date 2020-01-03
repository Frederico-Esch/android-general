import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';




class ChatPage extends StatefulWidget {
  final BluetoothDevice server;
  ChatPage({this.server});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double> animation;
  AnimationController _animationController2;
  Animation<double> animation2;
  AnimationController _animationController3;
  Animation<double> animation3;
  
  BluetoothConnection conexao;
  String msgBuffer;

  bool conectando = true;
  bool get conectado => conexao != null && conexao.isConnected;
  bool desconectando = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 1, end: 0.5).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut))..addListener((){
      setState((){});
    });

    _animationController2 = AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animation2 = Tween<double>(begin: 1, end: 0.5).animate(CurvedAnimation(parent: _animationController2, curve: Curves.easeOut))..addListener((){
      setState((){});
    });

    _animationController3 = AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animation3 = Tween<double>(begin: 1, end: 0.5).animate(CurvedAnimation(parent: _animationController3, curve: Curves.easeOut))..addListener((){
      setState((){});
    });

    BluetoothConnection.toAddress(widget.server.address).then((_conexao){
      Fluttertoast.showToast(msg: "Conectou no dispositivo");
      conexao = _conexao;
      setState(() {
        conectando = false;
        desconectando = false;
      });

      conexao.input.listen(_onDataReceived).onDone((){
        /*Por Exemplo detectar quem fechou a conexão
        Tem que haver uma 'flag' pra informar (localmente) se
        nós estamos no processo de desconexão, deve ser chamado
        antes de 'finish', 'dispose' ou 'close', os quais causam desconexão
        se desconectarmos o 'onDone' é disparado como consequencia
        se não colocássemos a 'flag', significa que a desconexão foi remota*/
        if(desconectando) Fluttertoast.showToast(msg: "Desconectando localmente");
        else Fluttertoast.showToast(msg: "Desconectado remotamente");
        if(this.mounted) setState((){});
      });
    }).catchError((e){
      Fluttertoast.showToast(msg:"Não foi conectado erro: ${e.toString()}");
    });

  }

  @override
  void dispose() {
    //Evitar memory leak
    if(conectado){
      desconectando = true;
      conexao.dispose();
      conexao = null;
    }

    super.dispose();
  }

  bool led1 = false;
  bool led2 = false;
  bool led3 = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: conectando ? Text('Conectando a ${widget.server.name} ...') :
        conectado ? Text('Conectado a ${widget.server.name}') : Text("Não está conectado"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Transform.scale(
                scale: animation.value,
                child: Container(
                height: 90,
                width: 90,
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.lightbulb_outline, color: led1 ? Colors.white : Colors.black),
                    color: Colors.green,
                    onPressed: conectado ? (){_enviaMensagem('a', 1); animate(1);} : null,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    color: Colors.yellow[600],
                  ),
              ),
            ),

            SizedBox(height: 25,),

            Transform.scale(
                scale:animation2.value ,
                child: Container(
                height: 90,
                width: 90,
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.lightbulb_outline, color: led2 ? Colors.white : Colors.black),
                    color: Colors.green,
                    onPressed: conectado ? (){_enviaMensagem('b', 2); animate(2);} : null,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    color: Colors.green,
                  ),
              ),
            ),

            SizedBox(height: 25,),

            Transform.scale(
                scale: animation3.value,
                child: Container(
                height: 90,
                width: 90,
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.lightbulb_outline, color: led3 ? Colors.white : Colors.black),
                    color: Colors.green,
                    onPressed: conectado ? () { _enviaMensagem('c', 3); animate(3);} : null,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    color: Colors.red,
                  ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List ondata){}
  void animate(int value)async{
    if(value == 1){
      await _animationController.forward();
    _animationController.reverse();
    }else if(value == 2){
      await _animationController2.forward();
    _animationController2.reverse();
    }else{
      await _animationController3.forward();
    _animationController3.reverse();
    }
  }
  
  void _enviaMensagem(String msg, int numero) async {
    msg = msg.trim();
    try{
      conexao.output.add(utf8.encode("$msg\r\n"));
      await conexao.output.allSent;
      if(numero == 1) setState((){led1 = !led1;});
      else if(numero == 2) setState((){led2 = !led2;});
      else setState((){led3 = !led3;});

      //TODO SetState pra altera o botão de liga e desliga o led para saber se o led está ligado ou desligado
    }catch(e){
      Fluttertoast.showToast(msg:"erro de envio ${e.toString()}");
      setState(() {});
    }

  }
}