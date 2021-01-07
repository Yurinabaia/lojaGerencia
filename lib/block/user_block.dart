
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

//stless
//stfull

class UsuarioBloc extends BlocBase {
  final _userController = BehaviorSubject<List>();
  Stream<List> get outUsuaurio => _userController.stream;
  
  
  Map<String, Map<String, dynamic>> _usuario = {};
  
  Firestore _firestore = Firestore.instance;
  
  UsuarioBloc() 
  {
    _addUsuarioLista();
  }

  void onChangePesquisa(String nome) {
    if(nome.trim().isEmpty) 
    {
        _userController.add(_usuario.values.toList());
    } else 
    {
        _userController.add(_filter(nome.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String nome) 
  {
    List<Map<String, dynamic>> filtraUsuarios = List.from(_usuario.values.toList());
    filtraUsuarios.retainWhere((nomeUsuario) 
    {
      return nomeUsuario["nome"].toUpperCase().contains(nome.toUpperCase());
    }); 
    return filtraUsuarios;
  }
  void _addUsuarioLista() 
  {
  _firestore.collection("usuarios").snapshots().listen((snapshot) 
    {
        snapshot.documentChanges.forEach((change) 
        {
          String uid = change.document.documentID;
          switch(change.type) 
          {
            case DocumentChangeType.added:
              _usuario[uid] = change.document.data;
              _buscaPedido(uid);
              break;
            case DocumentChangeType.modified:
              _usuario[uid].addAll(change.document.data);
              _userController.add(_usuario.values.toList());
              break;
            case DocumentChangeType.removed:
              _usuario.remove(uid);
              _cacelarsubscribeToOrders(uid);
              _userController.add(_usuario.values.toList());
              break;
          }
        });
    });
  }

  void _buscaPedido(String uid) {
     _usuario[uid]["subscription"]  =  _firestore.collection("usuarios").document(uid)
    .collection("orders").snapshots().listen((orders) async
    {
        int numOrders = orders.documents.length;
        double money = 0.0;

        for(DocumentSnapshot d in orders.documents) 
        {
          DocumentSnapshot order = await _firestore.collection("orders").document(d.documentID).get();
          
          if(order.data == null) continue;

          money += order.data["total"];
        }
        _usuario[uid].addAll(
          {"money" : money, "orders": numOrders}
        );

        _userController.add(_usuario.values.toList());
    });
  }

  void _cacelarsubscribeToOrders(String uid) 
  {
    _usuario[uid]["subscription"].cancel();
  }

  @override
    void dispose() {
      _userController.close();
    }
}