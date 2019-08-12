import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/singup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Criar contar',
              style: TextStyle(fontSize: 15.0),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SingupScreen()));
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'E-mail'),
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@")) {
                        return "Email invalido";
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'senha'),
                    validator: (text) {
                      if (text.isEmpty || text.length < 6) {
                        return 'senha invalida';
                      }
                    },
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        onPressed: () {
                          if(_emailController.text.isEmpty){
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Insira seu email para validação"),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),)

                            );
                          }else{
                            model.recoveryPass(_emailController.text);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Confira seu email"),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 2),)

                            );


                          }
                        },
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Esqueci minha senha ',
                          textAlign: TextAlign.right,
                        )),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        model.singIn(
                            email: _emailController.text,
                            pass: _passwordController.text,
                            onSucess: _onSucess,
                            onFail: _onFail);
                      }
                    },
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onSucess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao entrar"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),)

    );

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });

  }
}
