import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/widget/categoria_title.dart';
//stless
//stfull
class ProdutosTable extends StatefulWidget {
  @override
  _ProdutosTableState createState() => _ProdutosTableState();
}

class _ProdutosTableState extends State<ProdutosTable>  with AutomaticKeepAliveClientMixin{

   @override
  Widget build(BuildContext context) {
      super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("produtos").snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        );
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return CategoriasTitle(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

}