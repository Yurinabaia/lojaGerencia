import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/block/user_block.dart';

//stless
//stfull

class UsuarioTab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _usuarioBlock = BlocProvider.of<UsuarioBloc>(context);
    return Column(
      children: <Widget>[
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: 
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Pesquisar",
            hintStyle: TextStyle(color: Colors.white),
            icon: Icon(Icons.search, color: Colors.white),
            border: InputBorder.none
            ),
            onChanged: _usuarioBlock.onChangePesquisa,
        ),
        ),
        //Mudar função abaixo para não atualizar dinamicamente
        
        
      ],
    );
  }
}