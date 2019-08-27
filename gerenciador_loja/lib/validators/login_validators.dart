import 'dart:async';
class LoginValidators{

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if(email.contains("@")){
        sink.add(email);
      }else{
        sink.addError("Insira um Email Valido");
      }
    }
  );

  final validatePassWord = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length>= 4){
        sink.add(password);
      }else{
        sink.addError("Se nha deve possuir 4 ou mais Caracteres");
      }
    }
  );


}