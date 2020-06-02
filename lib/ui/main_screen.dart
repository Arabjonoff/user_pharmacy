import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/ui/main/card_screen.dart';
import 'package:pharmacy/ui/main/favorites_screen.dart';
import 'package:pharmacy/ui/main/menu_screen.dart';

import 'main/catalog/catalog_screen.dart';
import 'main/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState.maybePop();
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
            _buildOffstageNavigator(4),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            unselectedItemColor: Colors.black26,
            selectedItemColor: Color.fromRGBO(208, 11, 82, 1.0),
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  translate('main.home'),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text(
                  translate('main.catalog'),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(Icons.add_shopping_cart),
                    ),
//                  Center(
//                    child: Container(
//                      margin: EdgeInsets.only(bottom: 15,left: 15),
//                      height: 5,
//                      width: 5,
//                      color: Colors.red,
//                    ),
//                  )
                  ],
                ),
                title: Text(
                  translate('main.card'),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text(
                  translate('main.favourite'),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text(
                  translate('main.menu'),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomeScreen(),
          CatalogScreen(translate("main.catalog")),
          CardScreen(),
          FavoritesScreen(),
          MenuScreen(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
