import 'package:flutter/material.dart';
import 'package:mund_time/services/world_time.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
String tempo;
bool start = true;
void update(data) async{
  World_Time instance = World_Time(url: data['url'], location: data['location'], flag: data['flag']);
  Future.delayed(Duration(minutes: 1),()async{
    await instance.getData();
    setState(() {
      tempo = instance.time;
      //print(tempo);
    });
  });
}

  Map data = {};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if(start){
      start = false;
      tempo = data['time'];
    }
    String bgImage = data['isDay'] ? 'day.jpg' : 'night.jpg';
    update(data);
    return Scaffold(
      body: 
      //SafeArea(
        //child:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
              colorFilter: data['isDay'] ? ColorFilter.mode(Colors.blue, BlendMode.color) : ColorFilter.mode(Colors.blue[900], BlendMode.softLight),
            )
          ),
          child: SingleChildScrollView(physics:MediaQuery.of(context).orientation == Orientation.landscape ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),child:Column( 
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                SizedBox( width: 50,
                  child: Image.asset('assets/${data['flag']}'),
                ),
                SizedBox(width: 20,),
                Text(data['location'], style: TextStyle(fontSize: 25, letterSpacing: 1.5),),
              ],),
              SizedBox(height: 150,),
              Center(
                child: Text(tempo, style:TextStyle(fontSize: 60, color: data['isDay'] ? Colors.indigo[900] : Colors.blueGrey[300])),
              ),
              FlatButton.icon(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/', arguments: {
                  'url':data['url'],
                  'flag':data['flag'],
                  'location':data['location']
                });},
                label: Text("Reload"),
                icon: Icon(Icons.replay),
                color: Colors.greenAccent[700],
              ),
              SizedBox(height: MediaQuery.of(context).orientation == Orientation.portrait ? 1000 : 0,)
            ],
          ),
          ),
        ),
      //),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/location');
        },
        child: Icon(Icons.location_on, color: Colors.red[900],),
        elevation: 10,
        backgroundColor: Colors.indigo[900],
      ),
      backgroundColor: data['isDay'] ?  Colors.lightGreen[100] : Colors.teal[900],
    );
  }
}