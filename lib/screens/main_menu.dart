import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/menu.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/global.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxform.dart';
import 'package:mobilepacking/screens/packingCar/packboxcar_list.dart';
import 'package:mobilepacking/screens/packingSO/getSoDoc.dart';
import 'package:mobilepacking/screens/packingSend/packsend_list.dart';

class Mainmenu extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => Mainmenu());
  }

  @override
  _MainmenuState createState() => _MainmenuState();
}

Widget menuBuild(BuildContext context, List<MenuStruct> menuList) {
  final storeBloc = context.read<StoreBloc>();

  List<Widget> menuWidgets = [];
  for (var menu in menuList) {
    menuWidgets.add(
      Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                switch (menu.targetId) {
                  case menuId.packbox:
                    storeBloc.add(StoreLoaded(
                      type: StoreType.Packbox,
                      docNo: '',
                      products: <Product>[],
                    ));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => PackboxList()));
                    break;
                  case menuId.packcar:
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => PackcarList()));
                    break;
                  case menuId.send:
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PacksendList()));
                    break;
                  case menuId.signout:
                    context.read<AuthenticationBloc>().add(
                        AuthenticationStatusChanged(
                            status: AuthenticationStatus.unauthenticated));
                    break;
                }
              },
              icon: Icon(
                menu.icon,
                size: 39,
                color: menu.color,
              ),
            ),
            TextButton(
              onPressed: () {
                switch (menu.targetId) {
                  case menuId.packbox:
                    storeBloc.add(StoreLoaded(
                      type: StoreType.Packbox,
                      docNo: '',
                      products: <Product>[],
                    ));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => PackboxList()));
                    break;
                  case menuId.packcar:
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => PackcarList()));
                    break;
                  case menuId.send:
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PacksendList()));
                    break;
                  case menuId.signout:
                    context.read<AuthenticationBloc>().add(
                        AuthenticationStatusChanged(
                            status: AuthenticationStatus.unauthenticated));
                    break;
                }
              },
              child: Text(menu.name,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: menu.color)),
            ),
          ],
        ),
      ),
    );
  }
  return Container(
    padding: EdgeInsets.only(top: 20),
    color: Colors.white,
    alignment: Alignment.center,
    child: Wrap(spacing: 10, runSpacing: 20, children: menuWidgets),
  );
}

Widget mainMenu(BuildContext context) {
  List<Widget> menuList = [];

  menuList.add(menuBuild(context, [
    new MenuStruct(
        name: 'จัดสินค้าลงกล่อง',
        color: Colors.green,
        icon: Icons.list_alt,
        targetId: menuId.packbox),
    new MenuStruct(
        name: 'จัดสินค้าขึ้นรถ',
        color: Colors.blue,
        icon: Icons.car_rental,
        targetId: menuId.packcar),
    new MenuStruct(
        name: 'จัดส่งสินค้า',
        color: Colors.purple,
        icon: Icons.send_and_archive,
        targetId: menuId.send),
    new MenuStruct(
        name: 'ออกจากระบบ',
        color: Colors.amber,
        icon: Icons.logout_outlined,
        targetId: menuId.signout),
  ]));

  return Column(
    children: menuList,
  );
}

class _MainmenuState extends State<Mainmenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(247, 166, 245, 1),
          title: Text(
            'Mobile Packing',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            AuthenticationState authenticationState =
                BlocProvider.of<AuthenticationBloc>(context).state;
            User? user = User.empty();

            if (authenticationState.status ==
                AuthenticationStatus.authenticated) {
              user = state.user ?? User.empty();
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(10),
                    color: Color.fromRGBO(247, 166, 245, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading:
                              Icon(Icons.person, size: 55, color: Colors.white),
                          title: Text(
                            'ยินดีต้อนรับ ${user.userCode}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            'สาขา: ${user.branchCode}  คลัง: ${user.icWht} ที่เก็บ: ${user.icShelf}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: mainMenu(context),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
