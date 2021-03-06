import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lojagerencia/block/pedidos_bloc.dart';
import 'package:lojagerencia/block/user_block.dart';
import 'package:lojagerencia/tabs/pedidos_tabs.dart';
import 'package:lojagerencia/tabs/produtos_tabs.dart';
import 'package:lojagerencia/tabs/usuario_tabs.dart';
import 'package:lojagerencia/tabs/usuario_tabs2.dart';

//stless
//stfull

class HomeScreen extends StatefulWidget {
  bool i;
  HomeScreen(this.i);

  @override
  _HomeScreenState createState() => _HomeScreenState(this.i);
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _pagina = 0;
  bool cont;
  UsuarioBloc _usuarioBloc;
  PedidosBloc _pedidosBloc;
  _HomeScreenState(this.cont);
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _usuarioBloc = UsuarioBloc();
    _pedidosBloc = PedidosBloc();
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
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.white54)),
        ),
        child: BottomNavigationBar(
            //Barra que fica embaixo
            currentIndex: _pagina,
            onTap: (pagina) {
              _pageController.animateToPage(pagina,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Clientes")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Produtos")),
            ]),
      ),
         floatingActionButton: _buildFloating(),
      body: SafeArea(
          child: BlocProvider<UsuarioBloc>(
        bloc: _usuarioBloc,
        child: BlocProvider<PedidosBloc>(
          bloc: _pedidosBloc,
          child: PageView(
            onPageChanged: (pagina) {
              setState(() {
                _pagina = pagina;
              });
            },
            controller: _pageController,
            children: <Widget>[
              

              _usuarioTab(),
              PedidosTab(),
              ProdutosTable()
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildFloating() {
    switch (_pagina) {
      case 0:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.cyanAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.autorenew, color: Colors.cyanAccent),
                backgroundColor: Colors.white,
                label: "Atualizar pagina",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                    
                   Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen(true),)
          ); 
                }),
          ],
        );
        break;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.cyanAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.cyanAccent),
                backgroundColor: Colors.white,
                label: "Concluidos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _pedidosBloc
                      .setOrdernacao(CriterioOrdenacao.CONCLUIDOS_ABAIXO);
                }),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.cyanAccent),
                backgroundColor: Colors.white,
                label: "Concluidos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _pedidosBloc
                      .setOrdernacao(CriterioOrdenacao.CONCLUIDOS_ACIMA);
                }),
          ],
        );
    }
  }
  _usuarioTab() 
  {
    if(cont){
      cont = false;
      return UsuarioTab();
    }
    else
      return UsuarioTab2();
  }
}
