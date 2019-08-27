import 'package:flutter/material.dart';
import 'package:gerenciador_loja/blocs/login_bloc.dart';
import 'package:gerenciador_loja/screens/home_screen.dart';
import 'package:gerenciador_loja/widgets/input_filed.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void dispose() {
    // TODO: implement dispose
    _loginBlock.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBlock.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
          HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(context: context,
              builder:(context)=> AlertDialog(
                title: Text("ERRO"),
                content: Text("Voce não tem os privelegios necessarios "),
              ));
          break;
        default:
          return;

      }
    });
  }

  final _loginBlock = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBlock.outState,
        builder: (context, snapshot) {


          switch (snapshot.data){
            case LoginState.LOADING:
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),);
            case LoginState.FAIL:
            case LoginState.IDLE:
            default:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.store_mall_directory,
                            color: Colors.pinkAccent,
                            size: 160,),
                          InputField(
                            icon: Icons.person_outline,
                            hint: "Usuario",
                            obscure: false,
                            stream: _loginBlock.outEmail,
                            onChanged: _loginBlock.changeEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: "Senha",
                            obscure: true,
                            stream: _loginBlock.outPassword,
                            onChanged: _loginBlock.changePassword,
                          ),
                          SizedBox(height: 32,),

                          StreamBuilder<bool>(
                              stream: _loginBlock.outSubimitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    color: Colors.pinkAccent,
                                    child: Text("Entrar"),
                                    onPressed: snapshot.hasData? _loginBlock.submit: null,
                                    textColor: Colors.white,
                                    disabledColor: Colors.pinkAccent.withAlpha(140),
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );

          }

        }
      ),
    );
  }
}
