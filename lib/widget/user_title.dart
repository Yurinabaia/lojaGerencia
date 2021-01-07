import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//stless
//stfull

class UsuarioTitle extends StatelessWidget {
  
  final Map<String, dynamic>  usuarios;

  UsuarioTitle(this.usuarios);
  @override
  Widget build(BuildContext context) {
    
    final _textStyle = TextStyle(color: Colors.white);
    if(usuarios.containsKey("money"))
    return ListTile(
      title: Text(
        usuarios["nome"],
        style: _textStyle
        ),
        subtitle: Text(
          usuarios["email"],
          style: _textStyle
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("Pedidos: ${usuarios["orders"]}", 
            style: _textStyle
            ),
            Text(
              "Gasto: R\$${usuarios["money"].toStringAsFixed(2)}",
              style: _textStyle
            ),
          ]
        ),
    );
    else 
      return Container(
        margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
            width:  200,
            height: 20,
            child: Shimmer.fromColors(
              child: Container(
                color: Colors.white.withAlpha(50),
                ),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              ),
            ),
            SizedBox(
            width:  50,
            height: 20,
            child: Shimmer.fromColors(
              child: Container(
                color: Colors.white.withAlpha(50),
                ),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              ),
            ) 
          ],
          ),
      );
  }
}