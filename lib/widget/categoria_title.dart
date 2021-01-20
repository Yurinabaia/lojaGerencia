import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/screens/produtoScreen.dart';
//stless
//stfull

class CategoriasTitle extends StatelessWidget {
  final DocumentSnapshot categoria;

  CategoriasTitle(this.categoria);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
            child: ExpansionTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              categoria.data["icon"],
            ),
            backgroundColor: Colors.transparent,
          ),
          title: Text(categoria.data["titulo"],
              style: TextStyle(color: Colors.grey[850]) //
              ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: categoria.reference.collection("itens").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Column(
                    children: snapshot.data.documents.map((doc) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doc.data["img"][0]),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(doc.data["titulo"]),
                    trailing:
                        Text("R\$${doc.data["preco"].toStringAsFixed(2)}"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProdutoScreen(
                            categoriaScreen: categoria.documentID,
                            produtosScreen: doc//O produto é o DOC
                            )));
                    },
                  );
                }).toList()
                      ..add(ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.add, color: Colors.blueAccent),
                        ),
                        title: Text("Adicionar"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProdutoScreen(
                            categoriaScreen: categoria.documentID
                            )));
                        },
                      )));
              },
            )
          ],
        ) //
            ) //
        );
  }
}
