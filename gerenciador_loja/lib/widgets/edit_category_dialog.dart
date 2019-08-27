import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_loja/blocs/category_bloc.dart';
import 'package:gerenciador_loja/widgets/images_source_sheet.dart';


class CategoryDialog extends StatefulWidget {

  final DocumentSnapshot category;
  CategoryDialog({this.category});

  @override
  _CategoryDialogState createState() => _CategoryDialogState(
    category: category
  );
}

class _CategoryDialogState extends State<CategoryDialog> {

  final CategoryBloc _categoryBloc;

  final TextEditingController textController;

  _CategoryDialogState({DocumentSnapshot category}):
        _categoryBloc = CategoryBloc(category: category),
        textController = TextEditingController(text: category != null?category.data['title']: '' );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: (){
                  showModalBottomSheet(context: context,
                      builder: (context)=> ImageSourceSheet(
                        onImageSelected: (image){
                          Navigator.of(context).pop();
                          _categoryBloc.setImage(image);
                        },
                      ));
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if(snapshot.data!=null){
                        return CircleAvatar(
                          child: snapshot.data is File ?
                          Image.file(snapshot.data, fit: BoxFit.cover,):
                          Image.network(snapshot.data, fit: BoxFit.cover,),
                          backgroundColor: Colors.white,

                        );

                      }else {
                        return Icon(Icons.image);
                      }

                    }
                ),

              ),
              title: StreamBuilder<String>(
                stream: _categoryBloc.outTitle,
                builder: (context, snapshot) {
                  return TextField(
                    controller: textController,
                    onChanged: _categoryBloc.setTitle,
                    decoration: InputDecoration(
                      errorText:snapshot.hasError? snapshot.error: null
                    ),
                  );
                }
              ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) return Container();
                      return FlatButton(
                        child: Text("Excluir"),
                        textColor: Colors.red,
                        onPressed:snapshot.data?  (){
                          _categoryBloc.delete();
                          Navigator.of(context).pop();

                        }: null,
                      );
                    }
                ),
                StreamBuilder<bool>(
                  stream: _categoryBloc.submitValid,
                  builder: (context, snapshot) {
                    return FlatButton(
                      child: Text("Salvar"),
                      onPressed: snapshot.hasData?()async{
                       await _categoryBloc.saveData();
                        Navigator.of(context).pop();
                      }: null,
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


