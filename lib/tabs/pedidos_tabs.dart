import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/block/pedidos_bloc.dart';
import 'package:lojagerencia/widget/pedidos_title.dart';

//stless
//stfull

class PedidosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _pedidosBloc = BlocProvider.of<PedidosBloc>(context);
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder(
          stream: _pedidosBloc.outPedidos,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.cyanAccent),
                  ///
                ), ////
              ); ////
            else if(snapshot.data.length ==0) 
             return Center(
               child: Text("Nenhum pedido encontrado! ", style: TextStyle(
               color: Colors.cyanAccent))
             );
            else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return PedidosTitle(snapshot.data[index]);
                },
              );
          },
        ));
  }
}
