import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SingupScreen extends StatefulWidget {
  @override
  _SingupScreenState createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _endController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,

      ),
      body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator(),);
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Nome completo'
                    ),
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Nome inválido";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'E-mail'
                    ),
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
                    decoration: InputDecoration(
                        hintText: 'senha'
                    ),
                    validator: (text) {
                      if (text.isEmpty || text.length < 6) {
                        return 'senha invalida';
                      }
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _endController,
                    decoration: InputDecoration(
                        hintText: 'Endereço'
                    ),
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Endereço invalido';
                      }
                    },
                  ),


                  SizedBox(height: 16,),
                  FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'address': _endController.text,

                        };
                        model.singUp(
                            userData: userData,
                            pass: _passwordController.text, onSucess:
                        _onSucess,
                            onFail: _onFail);
                      }
                    },
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text("Criar Conta", style: TextStyle(fontSize: 18),),
                  )
                ],
              ),

            );
          }
      ),
    );
  }

  void _onSucess() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuário criado com sucesso"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          duration: Duration(seconds: 2),)

    );

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar user"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),)

    );

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });

  }
}
