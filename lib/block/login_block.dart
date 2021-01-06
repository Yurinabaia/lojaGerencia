import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lojagerencia/validation/login_validaton.dart';
import 'package:rxdart/rxdart.dart';
enum LoginStatus {SEMPROC, LOADING, SUCESS, FAIL}
class LoginBlock extends BlocBase with LogiValidation {
  final _emailController = BehaviorSubject<String>();
  final _passowrdController = BehaviorSubject<String>();
  final _statusController = BehaviorSubject<LoginStatus>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passowrdController.stream.transform(validatePassword);
  Stream<LoginStatus> get outStatus => _statusController.stream;

  StreamSubscription _subscription;
  LoginBlock() 
  {
    _subscription = FirebaseAuth.instance.onAuthStateChanged.listen( 
      (user) 
      async
      {
          if(user != null) 
          {
            if( await verifyPrivilegio(user)) 
            {
                _statusController.add(LoginStatus.SUCESS);
            }
            else 
            {
                FirebaseAuth.instance.signOut();
              _statusController.add(LoginStatus.FAIL);
            }
          }
          else 
          {
            _statusController.add(LoginStatus.SEMPROC);
          }

      });
  }
  void subMIT() 
  {
    final email = _emailController.value;
    final password = _passowrdController.value;
    _statusController.add(LoginStatus.LOADING);
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError(
      (erro) 
      {
        _statusController.add(LoginStatus.FAIL);
      }
    );
  }

  Future<bool> verifyPrivilegio(FirebaseUser user) async
  {
    return await Firestore.instance.collection("admins").document(user.uid).get().then(
    (doc) 
    {
      if(doc.data != null) 
      {
        return true;
      } else 
      {
        return false;
      }
    }
    ).catchError((erro) 
    {
      return false;
    });
  }

  Stream<bool> get outSubmitValue => Observable.combineLatest2(
    outEmail, outPassword, (a, b) => true
  );
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassoword => _passowrdController.sink.add;
  @override
  void dispose() {
    _emailController.close();
    _passowrdController.close();
    _statusController.close();
    _subscription.cancel();
  }
}
