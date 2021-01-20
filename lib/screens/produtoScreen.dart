import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/block/produto_bloc.dart';
import 'package:lojagerencia/validation/produto_validation.dart';
import 'package:lojagerencia/widget/imagem_widget.dart';
//STLESS
//STFULL

class ProdutoScreen extends StatefulWidget {
  final String categoriaScreen;
  final DocumentSnapshot produtosScreen;

  ProdutoScreen({this.categoriaScreen, this.produtosScreen});

  @override
  _ProdutoScreenState createState() =>
      _ProdutoScreenState(categoriaScreen, produtosScreen);
}

class _ProdutoScreenState extends State<ProdutoScreen> with ProdutoValidacao {
  final ProdutoBlock _produtoBlock;
  _ProdutoScreenState(String categoriaScreen, DocumentSnapshot produtosScreen)
      : _produtoBlock =
            ProdutoBlock(categoria: categoriaScreen, produtos: produtosScreen);

  final _formKey = GlobalKey<FormState>();
  final _scaffodlKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);
    return Scaffold(
      key: _scaffodlKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _produtoBlock.outCreate,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data ? "Atualizar produto " : "Criar produto ");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _produtoBlock.outCreate,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _produtoBlock.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                          onPressed: snapshot.data ? null :(){
                          _produtoBlock.deleteProduto();
                          Navigator.of(context).pop();
                          }
                      );
                    }
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _produtoBlock.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : _saveProdutos,
                );
              })
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _produtoBlock.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text("Imagens",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ImagemWidget(
                        context: context,
                        initialValue: snapshot.data["img"],
                        onSaved: _produtoBlock.saveImage,
                        validator: validationImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["titulo"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _produtoBlock.saveTitulo,
                        validator: validationTitulo,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["descricao"],
                        style: _fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _produtoBlock.saveDescricao,
                        validator: validationDescricao,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data["preco"]?.toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _produtoBlock.savePreco,
                        validator: validationPreco,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              //Tela ofuscada
              stream: _produtoBlock.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              })
        ],
      ),
    );
  }

  void _saveProdutos() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffodlKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvado produto...",
          style: TextStyle(color: Colors.white),
        ),
        //duration: Duration(minutes: 1),
        backgroundColor: Colors.blueAccent,
      ));

      bool sucesso = await _produtoBlock.saveProduto();

      _scaffodlKey.currentState.showSnackBar(SnackBar(
        content: Text(
          sucesso ? "Produto Salvo!!!" : "Erro ao salvar produto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ));
    }
  }
}
