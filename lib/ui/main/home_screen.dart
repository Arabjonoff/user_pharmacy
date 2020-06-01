import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/ui/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;

  _HomeScreenState() {
    searchController.addListener(() {
      if (searchController.text.length > 0) {
        setState(() {
          isSearchText = true;
        });
      } else {
        setState(() {
          isSearchText = false;
        });
      }
      print(searchController.text);
    });
  }

  int _current = 0;
  List imgList = [
    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.only(top: 104),
            height: size.height - 104,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  height: 105,
                  child: Material(
                    elevation: 5.0,
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                ),

                Container(
                  height: 45,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80, left: 15, right: 15, bottom: 15),
            height: 48,
            width: double.infinity,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(9.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: SearchScreen(),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: new Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        translate("search_hint"),
                      ),
                    ),
                    IconButton(
                      icon: new Icon(
                        Icons.scanner,
                        size: 24,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        print("click");
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
