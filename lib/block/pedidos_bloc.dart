
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum CriterioOrdenacao {CONCLUIDOS_ACIMA, CONCLUIDOS_ABAIXO}
class PedidosBloc extends BlocBase {
  final _pedidosController = BehaviorSubject<List>();

  Stream<List> get outPedidos => _pedidosController.stream;
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _pedidos = [];

  CriterioOrdenacao _criterioOrdenacao;
  PedidosBloc() {
    _addPedidosLista();
  }
  void _addPedidosLista() {
    _firestore.collection("orders").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;
        switch (change.type) {
          case DocumentChangeType.added:
            _pedidos.add(change.document);
            break;
          case DocumentChangeType.modified:
            _pedidos.removeWhere((ped) => ped.documentID == uid);
            _pedidos.add(change.document);
            break;
          case DocumentChangeType.removed:
            _pedidos.removeWhere((ped) => ped.documentID == uid);
            break;
        }
      });
      _sort();
    });
  }

  void setOrdernacao(CriterioOrdenacao criterio) 
  {
    _criterioOrdenacao = criterio;
      _sort();
  }
  void _sort () 
  {
      switch(_criterioOrdenacao) 
      {
        case CriterioOrdenacao.CONCLUIDOS_ACIMA:
        _pedidos.sort((a,b){
          int sa = a.data["status"];
          int sb = b.data["status"];

          if(sa < sb) return 1;
          else if(sa > sb) return -1;
          else return 0;
        });
        break;
      case CriterioOrdenacao.CONCLUIDOS_ABAIXO:
        _pedidos.sort((a,b){
          int sa = a.data["status"];
          int sb = b.data["status"];

          if(sa > sb) return 1;
          else if(sa < sb) return -1;
          else return 0;
        });
        break;

      }
      _pedidosController.add(_pedidos);
  }


  @override
  void dispose() {
    _pedidosController.close();
  }
}
