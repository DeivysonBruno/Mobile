import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Contador de pessoas',
      home: Home()));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _people= 0;
  String infotext="Pode Entrar!";

  void _changePeople(int delta){
    setState(() {
      _people+=delta;
      if(_people <0){
        infotext="Mundo invertido?";

      }else if(_people >10){
        infotext = "Restaurante lotado";
      }else {
        infotext="Pode Entrar!";
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset('images/restaurant.jpg', fit: BoxFit.cover, height: 1000,
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Pessoas: $_people",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      '+1',
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {_changePeople(1);},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      '-1',
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {_changePeople(-1);},
                  ),
                ),
              ]),
              // text
              Text(
                '$infotext',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 30.0),
              )
            ] // children
        )
      ],
    );


  }
}

