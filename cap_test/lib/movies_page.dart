import 'package:cap_test/my_drop_cap.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String text =
      ("Após Thanos eliminar metade das criaturas vivas, os Vingadores têm"
          " de lidar com a perda de amigos e entes queridos. Com Tony Stark vagando "
          "perdido no espaço sem água e comida, Steve Rogers e Natasha Romanov"
          " lideram a resistência contra o titã louco.");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.purple,
        ),
      ),
      body: Column(
        children: <Widget>[
          MyDropCapText(
            text,
            title: "Avengers",
            gender: "Aventura",
            classification: Image.network('https://logodownload.org/wp-content/uploads/2017/07/classificacao-livre-logo.png'),
            mode: DropCapMode.upwards,
            dropCapPadding: EdgeInsets.all(8),
            dropCap: MyDropCap(

              width: 150,
              height: 180,
              child: Image.network(
                  'https://img.elo7.com.br/product/original/2678F78/cartaz-poster-vingadores-4-ultimato-filme-marvel-avengers-colecionador.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
