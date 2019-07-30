import 'dart:io';

import 'package:ageenda_de_contatos/helpers/contact_helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact == null) {
      _editedContact = new Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }

    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? 'Novo Contato'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: _createBody(),
      ),
    );
  }

  Widget _createBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              ImagePicker.pickImage(source: ImageSource.camera).then((file){
                if(file == null ) return;
                setState(() {
                  _editedContact.img=file.path;
                });
              });
            },
            child: Container(
              height: 140.0,
              width: 140.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage('images/person.png'),
                  fit: BoxFit.cover)),
            ),
          ),
          TextField(
            focusNode: _nameFocus,
            controller: _nameController,
            decoration: InputDecoration(labelText: "Nome"),
            onChanged: (text) {
              _userEdited = true;
              setState(() {
                _editedContact.name = text;
              });
            },
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
            onChanged: (text) {
              _userEdited = true;
              _editedContact.email = text;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: "Phone"),
            onChanged: (text) {
              _userEdited = true;
              _editedContact.phone = text;
            },
            keyboardType: TextInputType.phone,
          )
        ],
      ),
    );
  }
 Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Descartar alterações?"),
          content: Text("Se sair as alterações serão perdidas"),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Sim"),
            )
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}
