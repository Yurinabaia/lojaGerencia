import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProdutoBlock extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _produtoCarreandoController = BehaviorSubject<bool>();
  final _createController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _produtoCarreandoController.stream;
  Stream<bool> get outCreate => _createController.stream;
  String categoria;
  DocumentSnapshot produtos;
  Map<String, dynamic> salvarDados;
  ProdutoBlock({this.categoria, this.produtos}) {
    if (produtos != null) {
      salvarDados = Map.of(produtos.data);
      salvarDados["img"] = List.of(produtos.data["img"]);
      salvarDados["prescricao"] = List.of(produtos.data["prescricao"]);
      _createController.add(true);//Habilitar botao de deletar
    } else {
      salvarDados = {
        "titulo": null,
        "descricao": null,
        "preco": null,
        "img": [],
        "prescricao": []
      };
      _createController.add(false);//desabilitar botao de deletar
    }
    _dataController.add(salvarDados);
  }

  void saveTitulo(String titulo) {
    salvarDados['titulo'] = titulo;
  }

  void saveDescricao(String descricao) {
    salvarDados['descricao'] = descricao;
  }

  void savePreco(String preco) {
    salvarDados['preco'] = double.parse(preco);
  }

  void saveImage(List img) {
    salvarDados['img'] = img;
  }
  void savePrescri(List prescri) {
    salvarDados['prescricao'] = prescri;
  }

  Future<bool> saveProduto() async {
    _produtoCarreandoController.add(true);
    try {
      if (produtos != null) {
        await _uploadImagem(produtos.documentID);
        await produtos.reference.updateData(salvarDados); //Salvando produtos existentes, atualizando produtos.
      } else {
        DocumentReference referen = await Firestore.instance
            .collection("produtos")
            .document(categoria)
            .collection("itens")
            .add(Map.from(salvarDados)..remove("img"));

        await _uploadImagem(referen.documentID);
        await referen.updateData(salvarDados);
      }
      _createController.add(true);
      _produtoCarreandoController.add(false);
      return true;
    } catch (e) {
      _produtoCarreandoController.add(false);
      return false;
    }
  }

  Future _uploadImagem(String produtosID) async {
    for (int i = 0; i < salvarDados['img'].length; i++) {
      if (salvarDados['img'][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoria)
          .child(produtosID)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(salvarDados['img'][i]);

      StorageTaskSnapshot salve = await uploadTask.onComplete;
      String urlImagem = await salve.ref.getDownloadURL();
      salvarDados['img'][i] = urlImagem;
    }
  }

  void deleteProduto() 
  {
    produtos.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _produtoCarreandoController.close();
    _createController.close();
  }
}
