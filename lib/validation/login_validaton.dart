import 'dart:async';

class LogiValidation 
{
    final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, slink) 
      {
        if(email.contains("@")) 
        {
          slink.add(email);
        }
        else 
        {
          slink.addError("Email não valido");
        }
      }
    );

    final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (passoword, slink) 
      {
        if(passoword.length >= 6)
        {
          slink.add(passoword);
        }
        else 
        {
          slink.addError("Senha não é validar, deve conter mais de 6 caracter");
        }
      }
    );
}