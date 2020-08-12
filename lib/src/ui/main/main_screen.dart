import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/all_item_isopen.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/eventBus/check_version.dart';
import 'package:pharmacy/src/ui/chat/chat_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/favorite/favorites_screen.dart';
import 'package:pharmacy/src/ui/main/menu/menu_screen.dart';
import 'package:pharmacy/src/ui/view/rating_dialog.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../update/auto_update_screen.dart';
import 'category/category_screen.dart';
import 'home/home_screen.dart';

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
  void initState() {
    registerBus();
    _setLanguage();
    sendRating();
    super.initState();
  }

  Future<void> _setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale(prefs.getString('language')));
      });
    } else {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale('ru'));
      });
    }
  }

  void registerBus() {
    RxBus.register<BottomViewModel>(tag: "EVENT_BOTTOM_VIEW")
        .listen((event) => setState(() {
              _selectedIndex = event.position;
            }));
    RxBus.register<LoginModel>(tag: "EVENT_CHAT_SCREEN").listen((event) => {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: ChatScreen(),
            ),
          ),
        });
    RxBus.register<CheckVersionModel>(tag: "EVENT_ITEM_CHECK")
        .listen((event) => {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.downToUp,
                  child: AutoUpdateScreen(event.packageName),
                ),
              )
            });
  }

  @override
  void dispose() {
    RxBus.destroy();
    super.dispose();
  }

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
              if (index == _selectedIndex) {
                switch (index) {
                  case 0:
                    {
                      RxBus.post(BottomView(true), tag: "HOME_VIEW");
                      break;
                    }
                  case 1:
                    {
                      RxBus.post(BottomView(true), tag: "CATEGORY_VIEW");
                      break;
                    }
                  case 2:
                    {
                      RxBus.post(BottomView(true), tag: "CARD_VIEW");
                      break;
                    }
                  case 3:
                    {
                      RxBus.post(BottomView(true), tag: "FAVOURITES_VIEW");
                      break;
                    }
                  case 4:
                    {
                      RxBus.post(BottomView(true), tag: "MENU_VIEW");
                      break;
                    }
                }
              }
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
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
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
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
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
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
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
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
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
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
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
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
//    switch (index) {
//      case 0:
//        return {'/home': (context) => HomeScreen()};
//      case 1:
//        return {'/category': (context) => CategoryScreen()};
//      case 2:
//        return {'/card': (context) => CardScreen()};
//      case 3:
//        return {'/favorites': (context) => FavoritesScreen()};
//      case 4:
//        return {'/menu': (context) => MenuScreen()};
//    }
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

  Future<void> sendRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var count = prefs.getInt("userEnterCount") == null
        ? 0
        : prefs.getInt("userEnterCount");
    if (count < 51) {
      if (count == 3 || count == 15 || count == 50) {
        Future.delayed(
          Duration(seconds: 5),
          () {
            showDialog(
              context: context,
              builder: (_) => RatingDialog(),
            );
          },
        );
      }
      count = count + 1;
      prefs.setInt('userEnterCount', count);
      prefs.commit();
    }
  }
}
