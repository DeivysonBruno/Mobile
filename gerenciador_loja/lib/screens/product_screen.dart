import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_loja/blocs/products_bloc.dart';
import 'package:gerenciador_loja/validators/product_validator.dart';
import 'package:gerenciador_loja/widgets/images_widget.dart';
import 'package:gerenciador_loja/widgets/product_sizes.dart';

class ProductScreen extends StatefulWidget {

 final String categoryId;
 final DocumentSnapshot product;


  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId,product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator{
final _formKey = GlobalKey<FormState>();
final ProductBloc _bloc;
final _scafoldKey = GlobalKey<ScaffoldState>();

_ProductScreenState(String categoryId, DocumentSnapshot product): _bloc = ProductBloc(
    categoryId: categoryId,
    product: product
);

  @override
  Widget build(BuildContext context) {


    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        labelText:  label
      );
    }

    final _fieldStyle = TextStyle(color: Colors.white,fontSize: 16);

    return Scaffold(
      key: _scafoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _bloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data? "editar Prpduto": "Criar Produto");
          }
        ),
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _bloc.outCreated,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data){
               return StreamBuilder<bool>(
                    stream: _bloc.outLoading,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data?null: (){
                          _bloc.delete();
                          Navigator.of(context).pop();
                        } ,
                      );
                    }
                );
              }else {
                return Container();
              }
            },
          ),
          StreamBuilder<bool>(
            stream: _bloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data? null: saveProduct,
              );
            }
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
              child:StreamBuilder<Map>(
                stream: _bloc.outData,
                builder: (context, snapshot) {


                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text("Images",style: TextStyle(color: Colors.grey),),

                      ImagesWidget(context: context,
                      initialValue: snapshot.data['images'],
                      onSaved: _bloc.saveImages,
                      validator: validateImages,),
                      TextFormField(
                        initialValue: snapshot.data['title'],
                        onSaved: _bloc.saveTitle,
                        validator: validateTitle,
                        style: _fieldStyle ,
                        decoration: _buildDecoration("Titulo"),
                      ),
                      TextFormField(
                        initialValue: snapshot.data['description'],
                        onSaved: _bloc.saveDescription,
                        validator: validateDescrpition,
                        style: _fieldStyle ,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                      ),
                      TextFormField(
                        initialValue: snapshot.data['price']?.toStringAsFixed(2),
                        onSaved:_bloc.savePrice,
                        validator: validatePrice,
                        style: _fieldStyle ,
                        decoration: _buildDecoration("Preço"),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Tamanhos",style: TextStyle(color: Colors.grey),),
                      ProductsSizes(
                        context: context,
                        initialValue: snapshot.data['sizes'],
                        onSaved:_bloc.saveSizes,
                        
                        validator: (s){
                          if(s.isEmpty) return "Adicione um tamanho";
                        },
                      )



                    ],
                  );
                }
              ) ),
          StreamBuilder<bool>(
              stream: _bloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data? Colors.black54: Colors.transparent,
                  ),
                );
              }
          )

        ],
      ),
    );
  }
  void saveProduct() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _scafoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Salvando Produto...", style: TextStyle(
          color: Colors.white,

        ),),
        duration: Duration(seconds: 30),)

      );
      bool sucess = await _bloc.saveProduct();

      _scafoldKey.currentState.removeCurrentSnackBar();

      _scafoldKey.currentState.showSnackBar(
          SnackBar(content: Text(sucess? "produto salvo": "Erro ao salvar", style: TextStyle(
            color: Colors.white,

          ),),
            )

      );


    }
  }
}
