import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
void main() => runApp(MaterialApp(home: Home()));
class Home extends StatelessWidget {
  final String cod = "Lone Wolf";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: 
        PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: AppBar(
            title: Text("Pass", style: TextStyle(color: Colors.black,),),centerTitle: true, backgroundColor: Colors.grey[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      
      body:SingleChildScrollView(
        physics: MediaQuery.of(context).orientation == Orientation.portrait ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/bafo.jpg'),
                  radius: 50,                  
                ),
              ),
              Divider(
                thickness: 0.6,
                height: 50,
                color: Colors.amber[600],
              ),
              Text(
                'Name:',
                style: TextStyle(color: Colors.grey[300], fontSize: 20,fontWeight: FontWeight.w600),
              ),
              Text(
                'Frederico',
                style: TextStyle(color: Colors.amber, fontSize: 30, fontFamily: 'Exo', letterSpacing:1.5),
              ),
              Text(
                'Surname:',
                style: TextStyle(color: Colors.grey[300], fontSize: 20,fontWeight: FontWeight.w600),
              ),
              Text(
                'Esch',
                style:TextStyle(color: Colors.amber.withAlpha(100), fontSize: 30, fontFamily: 'Exo', letterSpacing:1.5),
              ),
              SizedBox(
                height:  MediaQuery.of(context).orientation == Orientation.portrait ? 150 : 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Cod:',
                    style: TextStyle(color: Colors.amberAccent[700], fontSize: 40,fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration:BoxDecoration(gradient: LinearGradient(colors:<Color> [Colors.red[400], Colors.red[900], Colors.red[900]])),
                    child: FlatButton(
                    onPressed: (){Fluttertoast.showToast(msg: 'Seu codinome é: $cod', textColor: Colors.grey[400], backgroundColor: Colors.amber[900]);},
                    color: Colors.transparent,
                    child: Text("Press", style: TextStyle(color: Colors.white),),
                    padding: EdgeInsets.symmetric(vertical:16),
                    ),
                  )
                ],
            ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:<BottomNavigationBarItem> [
          BottomNavigationBarItem(title:Text('Card', style: TextStyle(color: Colors.white),), icon: Icon(Icons.credit_card, color: Colors.white,)),
          BottomNavigationBarItem(title:Text('Mail', style: TextStyle(color: Colors.amber[900]),) ,icon: Icon(Icons.mail,color: Colors.amber[900],))
        ],
        backgroundColor: Colors.deepOrange[900],
        elevation: 5,
        ),
    );
  }
}