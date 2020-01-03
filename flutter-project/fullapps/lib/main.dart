import 'package:flutter/material.dart';
List<Parametros> para = [Parametros(txt:"É 13", aut: "Monstro" ), Parametros(txt:"Brr brr", aut: "BanBan"), Parametros(txt: "Vish kk", aut: "Luba",)];

void main() => runApp(MyfulWidget());
class MyfulWidget extends StatefulWidget {
  
  @override
  _State createState() => _State();
}

class _State extends State<MyfulWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text("Citações", style: TextStyle(color: Colors.black),), centerTitle: true, backgroundColor: Colors.grey[50], elevation: 0,),
            body:Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:para.map((quote)=>Quote(
                    quoteText: quote.txt,
                    author: quote.aut, 
                    delete: (){setState(() {
                      para.remove(quote);
                    });},
                  )).toList(),
                ),
              ),
            ) ,
          backgroundColor: Colors.grey[300],
          ),
    );
  }
}
class Parametros{
  String txt;
  String aut;
  Parametros({this.txt, this.aut});
}
class Quote extends StatelessWidget {
  final String quoteText;
  final String author;
  final Function delete;
  Quote({this.quoteText, this.author, this.delete});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      elevation: 0,
      child:
      Container(
        child:Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: RaisedButton(
              onPressed: (){},
              color: Colors.white,
              elevation: 5,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  Text(
                    '$quoteText', style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$author'
                  )
                ]
              ),
              padding:EdgeInsets.all(5),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton.icon(
              icon: Icon(Icons.delete),
              label: Text("Delete"),
              onPressed: (){delete();},
              color: Colors.red[400],
            ),
          )
          ],
        ),
      ), 
    );
  }
}