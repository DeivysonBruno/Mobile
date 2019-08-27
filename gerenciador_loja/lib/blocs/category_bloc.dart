import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase{

  final _titleControler = BehaviorSubject<String>();
  final _imageControler =BehaviorSubject();
  final _deleteControler = BehaviorSubject<bool>();

  Stream<String> get outTitle =>_titleControler.stream.transform(
      StreamTransformer<String, String>.fromHandlers(
        handleData: (title, sink){
          if(title.isEmpty)
            sink.addError("Insira um titulo");
          else
            sink.add(title);
        }
      ));
  Stream get outImage => _imageControler.stream;
  Stream<bool> get outDelete=> _deleteControler.stream;

  Stream<bool> get submitValid => Observable.combineLatest2(outTitle, outImage, (a,b)=> true);

  File image;
  String title;
  DocumentSnapshot category;
  CategoryBloc({this.category}){
    if(category!= null){
      title = category.data['title'];
      _titleControler.add(category.data['title']);
      _imageControler.add(category.data['icon']);
      _deleteControler.add(true);
    }else{
      _deleteControler.add(false);
    }
  }

  void setImage(File file){
    image = file;
    _imageControler.add(file);
  }

  void setTitle(String title){
    this.title = title;
    _titleControler.add(title);
  }

  Future saveData()async{
    if(image == null && category != null && title == category.data['title']) return;

    Map<String, dynamic> dataToUpdate = {};

    if(image != null){
      StorageUploadTask task= FirebaseStorage.instance.ref().child('icons')
          .child(title).putFile(image);

      StorageTaskSnapshot snap = await task.onComplete;
      dataToUpdate['icon'] = await snap.ref.getDownloadURL();
    }
    if(category == null|| title != category.data['title']){
      dataToUpdate['title'] = title;
    }
    if(category == null){
      await Firestore.instance.collection('products')
          .document(title.toLowerCase()).setData(dataToUpdate);
    }else{
      await category.reference.updateData(dataToUpdate);

    }

  }

  void delete(){
    category.reference.delete();
  }

  @override
  void dispose() {
    _titleControler.close();
    _imageControler.close();
    _deleteControler.close();
    // TODO: implement dispose
  }


}