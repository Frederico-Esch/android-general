import 'dart:convert';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class World_Time{
  String location;
  String time;
  String flag; //url to an assets flag icon
  String url;
  bool isDay = true;
  Map resposta;
  String response;
  World_Time({this.location, this.flag, this.url});
  Future<void> getData() async{
    try{
      Response tempResponse = await get('http://worldtimeapi.org/api/timezone/$url');
      response = tempResponse.body;
      //print(tempResponse.body);
      Map tempresposta = jsonDecode(response);
      String tempHoraMin = tempresposta["datetime"].toString();
      tempHoraMin = tempHoraMin.substring(tempHoraMin.indexOf("T")+1,tempHoraMin.indexOf("T")+6); 
      time = tempHoraMin;
      //print(time.substring(0,2));
      if(int.parse(time.substring(0,2)) > 17 || int.parse(time.substring(0,2)) < 6){
        isDay = false;
      } 
      resposta = tempresposta;
    }catch(e){
      Fluttertoast.showToast(msg:"$e",toastLength: Toast.LENGTH_LONG);
      time = "Yeah, something is messed up, Sorry";
    }
   
  }
}

class World_TimePH{
  String location;
  String flag; 
  String url;
  World_TimePH({this.flag, this.url, this.location});
}