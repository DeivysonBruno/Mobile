

import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciador_loja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState{IDLE,LOADING, SUCCESS, FAIL}

class LoginBloc extends BlocBase with LoginValidators{
  final _emailControler = BehaviorSubject<String>();
  final _passWordControler = BehaviorSubject<String>();
  final stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail => _emailControler.stream.transform(validateEmail);
  Stream<String > get outPassword => _passWordControler.stream.transform(validatePassWord);
  Stream<LoginState> get outState => stateController.stream;
  
  Stream<bool> get  outSubimitValid => Observable.combineLatest2(outEmail, outPassword, (a,b)=>true);

  StreamSubscription streamSubscription;

  Function(String) get changeEmail => _emailControler.sink.add;
  Function(String) get changePassword => _passWordControler.sink.add;
  LoginBloc(){


   streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user)async {
      if(user != null){
        if(await verifyadmin(user)){
          stateController.add(LoginState.SUCCESS);
        }else{
          stateController.add(LoginState.FAIL);
          FirebaseAuth.instance.signOut();
        }
        print("logou");
      }else{
        stateController.add(LoginState.IDLE);
      }
    });
  }
  void submit(){
    final emaul = _emailControler.value;
    final password = _passWordControler.value;

    stateController.add(LoginState.LOADING);
    FirebaseAuth.instance.signInWithEmailAndPassword(email: emaul, password: password).catchError((e){
      stateController.add(LoginState.FAIL);
    });

  }

  Future<bool> verifyadmin(FirebaseUser user) async {

    return await Firestore.instance.collection('admins').document(user.uid).get().then((doc){
      if(doc.data!= null){
        return true;
      }else
        return false;

    }).catchError((e){
      return false;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailControler.close();
    _passWordControler.close();
    stateController.close();
  streamSubscription.cancel();
  }

}