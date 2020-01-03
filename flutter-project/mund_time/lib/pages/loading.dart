import 'package:flutter/material.dart';
import 'package:mund_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String loading = "Loading...";
  String time;
  bool sucesso = true;
  final String error_message = "Yeah, something is messed up, Sorry";
  
  void setupWorldTime({String url = "America/Sao_Paulo", String flag = "brazil.png", String location = "São Paulo"}) async{
    World_Time timeWorld = World_Time(location: location, url: url, flag: flag);
    await timeWorld.getData();
    time = timeWorld.time;
    if(time == error_message){
      sucesso = false;
      loading = "Erro";
    }else{
      //print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
     // print(time);
      int halfTime = int.parse(time.substring(0,time.indexOf(":")-1));
      //print(halfTime);
      if(halfTime<12){
        time = "$time AM";
      }else{
        time = "${(halfTime - 12).toString()}:${time.substring(time.indexOf(":")+1)} PM";
        //print(time);
      }
    }
    Future.delayed(Duration(seconds: 5) , (){Navigator.pushReplacementNamed(context, "/home", arguments: {
      'url': url,
      'location' : timeWorld.location,
      'flag' : timeWorld.flag,
      'time' : time,
      'isDay': timeWorld.isDay
    });});
  }
  Map data;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if(data != null){
      setupWorldTime(url:data['url'], flag:data['flag'], location:data['location']);
    }else{
      setupWorldTime();
    }
    return Scaffold(
      body: Container(
        child: Center(
          child:SpinKitPouringHourglass(
            color:Colors.amber, size: 200,
          ),
        ),
      ),
      backgroundColor: Colors.teal[100],
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}