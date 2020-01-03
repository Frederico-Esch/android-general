import 'package:flutter/material.dart';
import 'package:mund_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}
class _ChooseLocationState extends State<ChooseLocation> {

List<World_TimePH> lista = [
World_TimePH(url: "Africa/Cairo", location: "Cairo", flag: "egypt.png"),
World_TimePH(url: "Africa/Johannesburg", location: "Johannesburg", flag: "southafrica.jpg"),
World_TimePH(url: "America/Sao_Paulo", location: "São Paulo", flag: "brazil.png"),
World_TimePH(url: "America/Argentina/Buenos_Aires", location: "Buenos Aires", flag: "argentina.png"),
World_TimePH(url: "America/Anchorage", location: "Anchorage", flag: "alaska.jpg"),
World_TimePH(url: "America/Detroit", location: "Detroit", flag: "usa.png"),
World_TimePH(url: "America/Cancun", location: "Cancun", flag: "mexico.png"),
World_TimePH(url: "America/Guatemala", location: "Guatemala", flag: "guatemala.jpg"),
World_TimePH(url: "America/Indiana/Indianapolis", location: "Indianapolis", flag: "usa.png"),
World_TimePH(url: "America/Jamaica", location: "Jamaica", flag: "jamaica.png"),
World_TimePH(url: "America/La_Paz", location: "La Paz", flag: "bolivia.png"),
World_TimePH(url: "America/Mexico_City", location: "Mexico City", flag: "mexico.png"),
World_TimePH(url: "America/Panama", location: "Panama", flag: "panama.png"),
World_TimePH(url: "Antarctica/Troll", location: "Troll(Antarctica)", flag: "antartica.png"),
World_TimePH(url: "Asia/Baghdad", location: "Baghdad", flag: "iraque.jpg"),
World_TimePH(url: "Asia/Pyongyang", location: "Pyongyang", flag: "northkorea.png"),
World_TimePH(url: "Asia/Seoul", location: "Seoul", flag: "southkorea.png"),
World_TimePH(url: "Asia/Tokyo", location: "Tokyo", flag: "japan.png"),
World_TimePH(url: "Atlantic/Cape_Verde", location: "Cape Verde", flag: "capeverde.png"),
World_TimePH(url: "Australia/Brisbane", location: "Brisbane", flag: "australia.png"),
World_TimePH(url: "Australia/Sydney", location: "Sydney", flag: "australia.png"),
World_TimePH(url: "Europe/Amsterdam", location: "Amsterdam", flag: "netherlands.png"),
World_TimePH(url: "Europe/Berlin", location: "Berlin", flag: "germany.png"),
World_TimePH(url: "Europe/Athens", location: "Athens", flag: "greece.png"),
World_TimePH(url: "Europe/Dublin", location: "Dublin", flag: "ireland.jpg"),
World_TimePH(url: "Europe/London", location: "London", flag: "england.png"),
World_TimePH(url: "Europe/Madrid", location: "Madrid", flag: "spain.png"),
World_TimePH(url: "Europe/Moscow", location: "Moscow", flag: "russia.png"),
World_TimePH(url: "Europe/Paris", location: "Paris", flag: "france.png"),
World_TimePH(url: "Europe/Prague", location: "Prague", flag: "prague.png"),
World_TimePH(url: "Europe/Rome", location: "Rome", flag: "italy.jpg"),
World_TimePH(url: "Indian/Maldives", location: "Maldives", flag: "maldives.png"),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your location'),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
      ),
      body: 
      ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index){
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: ListTile(
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/', (Route route) => false, arguments: {
                    'url' : lista[index].url,
                    'flag' : lista[index].flag,
                    'location': lista[index].location
                  });
                },
                title: Text(lista[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${lista[index].flag}'),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}