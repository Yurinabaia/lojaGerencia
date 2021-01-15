import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/widget/cabecalho_pedido.dart';

//stless
//stfull

class PedidosTitle extends StatelessWidget {
  final DocumentSnapshot pedidos;
  final status = [
    "",
    "Em preparação",
    "Em transporte",
    "Aguardando Entregar",
    "Entregue"
  ];
  PedidosTitle(this.pedidos);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key:  Key(pedidos.documentID),
          initiallyExpanded: pedidos.data["status"] != 4,
            title: Text(
              "#${pedidos.documentID} - ${status[pedidos.data["status"]]}",
              style: TextStyle(color: pedidos.data["status"] != 4 ? _cores(pedidos.data["status"]) : Colors.green),
            ),
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CabecalhoPedido(pedidos),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: pedidos.data["produtos"].map<Widget>((ped) {
                        return ListTile(
                          title: Text(
                              ped["product"]["titulo"] + " " + ped["prescri"]),
                          subtitle: Text(ped["categorias"] + " " + ped["pid"]),
                          trailing: Text(
                            ped["quantidade"].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Firestore.instance.collection("usuarios").document(pedidos["cliente"]).collection("orders").document(pedidos.documentID).delete();
                            pedidos.reference.delete();
                          },
                          textColor: Colors.red,
                          child: Text("Excluir"),
                        ),
                        FlatButton(
                          onPressed: pedidos.data["status"] > 1 ? () {
                            pedidos.reference.updateData({"status" : pedidos.data["status"] -1});
                          } : null,
                          textColor: Colors.grey[850],
                          child: Text("Regredir"),
                        ),
                        FlatButton(
                          onPressed: pedidos.data["status"] < 4 ? () {
                           pedidos.reference.updateData({"status" : pedidos.data["status"] +1});

                          } : null,
                          textColor: Colors.green,
                          child: Text("Avançar"),
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }

  _cores(pedidos) {
    if (pedidos == 1)
      return Colors.grey[850];
    else if (pedidos == 2)
      return Colors.orange[850];
    else if (pedidos == 3) 
      return Colors.blue[850];
    else
     return Colors.green;
  }
}
