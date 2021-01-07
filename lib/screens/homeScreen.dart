import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lojagerencia/block/user_block.dart';
import 'package:lojagerencia/tabs/usuario_tabs.dart';

//stless
//stfull

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _pagina = 0;
  UsuarioBloc _usuarioBloc;
  @override
    void initState() {
      super.initState();
      _pageController = PageController();
      _usuarioBloc = UsuarioBloc();
    }

  @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.cyanAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54)
             ),
        ),
        child: BottomNavigationBar(//Barra que fica embaixo
          currentIndex: _pagina,
          onTap: (pagina) 
          {
              _pageController.animateToPage(
                pagina, 
                duration: Duration(milliseconds: 500), 
                curve: Curves.ease
                );
          },
          items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person), 
                title: Text("Clientes")
                ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart), 
                title: Text("Pedidos")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list),
                 title: Text("Produtos")),
        ]
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UsuarioBloc>(
        bloc: _usuarioBloc,
        child: PageView( 
        onPageChanged: (pagina) 
        {
          setState(() {
            _pagina = pagina;            
          });
        },
        controller: _pageController,
        children: <Widget> [
        UsuarioTab(),
        Container(color: Colors.green,),
        Container(color: Colors.indigo,)
        
        ],
       ),
      ),
      )
    );
  }
}
