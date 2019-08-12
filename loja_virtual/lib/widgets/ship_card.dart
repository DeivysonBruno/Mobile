import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Icon(Icons.location_on),
        title: Text(
          "Calcular frete",
          textAlign: TextAlign.center,
          style:
          TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),

        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu CEP"),
              initialValue:  "",
              onFieldSubmitted: (text) {

              },
            ),
          )
        ],
      ),
    );
  }
}
