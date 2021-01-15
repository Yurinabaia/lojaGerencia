import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/block/user_block.dart';

//stless
//stfull

class CabecalhoPedido extends StatelessWidget {
  final DocumentSnapshot pedidos;
  CabecalhoPedido(this.pedidos);
  @override

  Widget build(BuildContext context) {
    final _usuarioList = BlocProvider.of<UsuarioBloc>(context); 
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ////
              Text("${_usuarioList.getUsuario(pedidos.data["cliente"])["nome"]}"),
              Text("${_usuarioList.getUsuario(pedidos.data["cliente"])["enderco"]}")
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ////
            Text(
              "Preco Produtos: R\$${pedidos.data["precoPrduto"].toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text("Preco Frete: R\$${pedidos.data["frete"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500)),
            Text("Valor desconto: R\$${pedidos.data["descontoProduto"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500)),
            Text("Preco Total: R\$${pedidos.data["total"].toStringAsFixed(2)}", style: TextStyle(color: Colors.redAccent))
          ],
        ),
      ],
    );
  }
}
