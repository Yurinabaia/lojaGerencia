import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            ) //
          ) //
        );
  }
}
