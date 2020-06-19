import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/ui/main/menu_screen.dart';

import 'file:///D:/Flutter/ishxona/user_pharmacy/lib/ui/main/card/card_screen.dart';
import 'file:///D:/Flutter/ishxona/user_pharmacy/lib/ui/main/favorite/favorites_screen.dart';

import '../app_theme.dart';
import 'main/catalog/catalog_screen.dart';
import 'main/home/home_screen.dart';

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
            unselectedItemColor: AppTheme.menu_unselected,
            selectedItemColor: AppTheme.blue_app_color,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? SvgPicture.asset("assets/menu/home_selected.svg")
                    : SvgPicture.asset("assets/menu/home_unselected.svg"),
                title: Text(
                  translate('main.home'),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppTheme.fontRoboto,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? SvgPicture.asset("assets/menu/catalog_selected.svg")
                    : SvgPicture.asset("assets/menu/catalog_unselected.svg"),
                title: Text(
                  translate('main.catalog'),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppTheme.fontRoboto,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Center(
                      child: _selectedIndex == 2
                          ? SvgPicture.asset("assets/menu/card_selected.svg")
                          : SvgPicture.asset("assets/menu/card_unselected.svg"),
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
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppTheme.fontRoboto,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? SvgPicture.asset("assets/menu/favourite_selected.svg")
                    : SvgPicture.asset("assets/menu/favourite_unselected.svg"),
                title: Text(
                  translate('main.favourite'),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppTheme.fontRoboto,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 4
                    ? SvgPicture.asset("assets/menu/menu_selected.svg")
                    : SvgPicture.asset("assets/menu/menu_unselected.svg"),
                title: Text(
                  translate('main.menu'),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppTheme.fontRoboto,
                  ),
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
          CategoryScreen(),
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
