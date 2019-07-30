import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

TextEditingController wightControler = TextEditingController();
TextEditingController heightControler = TextEditingController();
GlobalKey<FormState> _formkey = GlobalKey<FormState>();

String _infoText = "Informe seus dados";
void _resetFild(){
  wightControler.text="";
  heightControler.text= "";
  setState(() {
      _infoText = "Informe seus dados";

  });
}

void calculate(){
setState(() {
  double wight = double.parse(wightControler.text);
  double height = double.parse(heightControler.text)/100;

  double imc = wight/(height*height);

  if(imc < 18.6){
    _infoText = "abaixo do peso (${imc.toStringAsPrecision(3)})";
  } else if(imc >= 18.6 && imc < 24){
    _infoText = 'Peso ideal (${imc.toStringAsPrecision(3)}' ;
  }else if(imc >= 24.9 && imc < 29.9){
    _infoText = 'levemente acima do peso (${imc.toStringAsPrecision(3)})';
  }else if(imc >= 29.9 && imc < 34.9){
    _infoText = 'Obesidade grau I (${imc.toStringAsPrecision(3)})';
  }else if(imc >= 34.9 && imc < 39.9){
    _infoText = 'Obesidade grau II (${imc.toStringAsPrecision(3)})';
  }else if(imc >= 40){
    _infoText = 'Obesidade grau III (${imc.toStringAsPrecision(3)})';
  }

  
});
  
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFild,
          ),
        ],
      ), //app bar
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child:Form(
          key: _formkey,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.person_outline,
            size: 120.0,
            color: Colors.green,
          ),
          TextFormField(
            validator: (value){
              if(value.isEmpty){
                return 'Insira seu peso';
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Peso em KG',
                labelStyle: TextStyle(color: Colors.green)),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green, fontSize: 25.0),
            controller: wightControler ,
          ),
          TextFormField(
            validator: (value){
              if(value.isEmpty){
                return 'Insira sua altura';
              }
              }
              ,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Altura',
                labelStyle: TextStyle(color: Colors.green)),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green, fontSize: 25.0),
            controller: heightControler,
          ),
         Padding(
           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Container(
            height: 50.0,
            child: RaisedButton(
              onPressed: (){
                if(_formkey.currentState.validate()){
                  calculate();
                }
              },
              child: Text('Calcular',
                style: TextStyle(color: Colors.white, fontSize: 25.0),),
              color: Colors.green,
            ),
          ),
         ),
          Text( '$_infoText', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green, fontSize: 25.0),

          ),

        ],
      ),
        )
      )
    );
  }
}
