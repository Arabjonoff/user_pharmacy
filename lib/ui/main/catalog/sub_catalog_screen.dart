import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/ui/search/search_screen.dart';

class SubCatalogScreen extends StatefulWidget {
  String name;

  SubCatalogScreen(this.name);

  @override
  State<StatefulWidget> createState() {
    return _SubCatalogScreenState();
  }
}

class _SubCatalogScreenState extends State<SubCatalogScreen> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            width: size.width,
            color: Colors.red,
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 3, bottom: 24),
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 104),
            height: size.height - 104,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                position.toString(),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.red,
                            )
                          ],
                        ),
                        height: 48,
                        margin: EdgeInsets.only(left: 15, right: 15),
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                );
              },
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
