import 'package:flutter/material.dart';
import 'package:lojagerencia/block/login_block.dart';
import 'package:lojagerencia/screens/homeScreen.dart';
import 'package:lojagerencia/widget/input_field.dart';

//stfull
//stless
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBlock = LoginBlock();

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _loginBlock.outStatus.listen((status) 
      {
        switch (status) 
        {
          case LoginStatus.SUCESS :
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen(false),)
          );  
          break;
          case LoginStatus.FAIL : 
            showDialog(context: context, builder: (context) => AlertDialog(
              title: Text("Erro"),
              content: Text("Você não possuir permissão de administrador"),
            ));
            break;
          case LoginStatus.LOADING :
          case LoginStatus.SEMPROC :
        }
      });
    }

  @override
    void dispose() {
      _loginBlock.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: StreamBuilder<LoginStatus>(
            stream: _loginBlock.outStatus,
            initialData: LoginStatus.LOADING,
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case LoginStatus.LOADING:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                    ),
                  );
                case LoginStatus.FAIL:
                case LoginStatus.SUCESS:
                case LoginStatus.SEMPROC:
                  return Stack(alignment: Alignment.center, children: <Widget>[
                    Container(),
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
 Image.asset(
                        'imagens/logo.png',
                      ),
                            InputField(
                              icon: Icons.person_outline,
                              text: "Usuario",
                              obscuro: false,
                              stream: _loginBlock.outEmail,
                              onChange: _loginBlock.changeEmail,
                            ),
                            InputField(
                              icon: Icons.lock_outline,
                              text: "Senha",
                              obscuro: true,
                              stream: _loginBlock.outPassword,
                              onChange: _loginBlock.changePassoword,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            StreamBuilder<bool>(
                                stream: _loginBlock.outSubmitValue,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                      height: 50,
                                      child: RaisedButton(
                                        color: Colors.cyanAccent,
                                        child: Text("Entrar"),
                                        onPressed: snapshot.hasData
                                            ? _loginBlock.subMIT
                                            : null,
                                        disabledColor:
                                            Colors.blueAccent.withAlpha(140),
                                        textColor: Colors.white,
                                      ));
                                })
                          ],
                        ),
                      ),
                    ),
                  ]);
                
              }
            }
          ),
        );
  }
}