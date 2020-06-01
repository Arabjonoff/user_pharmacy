import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/ui/main/card_screen.dart';
import 'package:pharmacy/ui/main/favorites_screen.dart';
import 'package:pharmacy/ui/main/menu_screen.dart';

import 'main/catalog_screen.dart';
import 'main/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;
  List<Widget> tabs = [
    HomeScreen(),
    CatalogScreen(translate("main.catalog")),
    CardScreen(),
    FavoritesScreen(),
    MenuScreen(),
  ];

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        unselectedItemColor: Colors.black26,
        selectedItemColor: Colors.red,
        currentIndex: currentTabIndex,
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
            icon: Icon(Icons.add_shopping_cart),
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
    );
  }
}
