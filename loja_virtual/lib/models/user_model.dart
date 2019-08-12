import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void singUp({@required Map<String,dynamic> userData, @required String pass, @required VoidCallback onSucess, @required VoidCallback onFail} )async {
    isLoading=true;
    notifyListeners();
    _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: pass ).then((user) async {

          firebaseUser = user;
          await _saveUserData(userData);
          onSucess();
          isLoading =false;
          notifyListeners();

    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

    
  }

  static UserModel of(BuildContext context){
    return ScopedModel.of<UserModel>(context);
  }
  void singIn({@required email, @required String pass, @required VoidCallback onSucess, @required VoidCallback onFail} )async{
    isLoading = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async{
      firebaseUser = user;

      await _loadCurrentUser();
      onSucess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();

    });

  }
  
  Future _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    await Firestore.instance.collection('user').document(firebaseUser.uid).setData(userData);
  }

  bool isLoggedIn(){



    return firebaseUser !=null;
  }
  void singOut()async{
    await _auth.signOut();
    userData = Map();
    firebaseUser = null ;
    notifyListeners();
  }

  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }
    if(firebaseUser!=null){
      userData = new Map();
      if(userData['name'] == null){
        DocumentSnapshot docUser= await Firestore.instance.collection('user').document(firebaseUser.uid).get();
        userData = docUser.data;
        print(userData);
      }

    }
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void recoveryPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }


}