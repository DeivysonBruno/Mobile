import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciador_loja/blocs/orders_bloc.dart';
import 'package:gerenciador_loja/blocs/user_bloc.dart';
import 'package:gerenciador_loja/tabs/orders_tab.dart';
import 'package:gerenciador_loja/tabs/products_tab.dart';
import 'package:gerenciador_loja/tabs/users_tab.dart';
import 'package:gerenciador_loja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;

  int page = 0;

  UserBloc _userBloc;
  OrderBloc _orderBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    _userBloc = UserBloc();
    _orderBloc = OrderBloc();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white)
          )
        ),
        child: BottomNavigationBar(
          currentIndex: page,
          onTap: (p){
            pageController.animateToPage(p, duration: Duration(milliseconds: 500), curve: Curves.ease);

          },

            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("Clientes"),

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text("Pedidos"),

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text("Produtos"),

              ),
            ]),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrderBloc>(
            bloc: _orderBloc,
            child: PageView(
              onPageChanged: (p){
                setState(() {
                  page =p;
                });
              },
              controller: pageController,
              children: <Widget>[
                UserTab(),
                OrdersTab(),
               ProductsTab()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating(){
    switch(page){
      case 0:
        return null;
        break;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.3,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(Icons.arrow_downward, color: Colors.pinkAccent,),
              backgroundColor: Colors.white,
              label: "Concluidos Abaixo",
              labelStyle: TextStyle(fontSize: 14),
              onTap: (){
                _orderBloc.setOrderCriteria(SortCriteria.READY_LAST);
              }
            ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent,),
                backgroundColor: Colors.white,
                label: "Concluidos acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _orderBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }
            )
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: (){
            showDialog(context: context,builder: (context)=> CategoryDialog() );
          },
        );
    }
  }
}
