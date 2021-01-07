import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/block/user_block.dart';
import 'package:lojagerencia/widget/user_title.dart';

//stless
//stfull

class UsuarioTab extends StatelessWidget {
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
        Expanded(
        child: StreamBuilder<List> (
          stream: _usuarioBlock.outUsuaurio,
          builder: (context, snapshot) 
          {
            
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.cyanAccent),),);
            else if(snapshot.data.length ==0) 
             return Center(
               child: Text("Nenhum usuário encontrado! ", style: TextStyle(
               color: Colors.cyanAccent))
             );
            else 
          return ListView.separated(
          itemBuilder: (context, index) {
            return UsuarioTitle(snapshot.data[index]);
          },
          separatorBuilder: (context, index) 
          {
            return Divider();
          },
            itemCount: snapshot.data.length,
            );
          }
          ),
        )
      ],
    );
  }
}