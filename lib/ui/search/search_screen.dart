import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;

  _SearchScreenState() {
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            width: size.width,
            color: Color(0xFFD00B52),
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
                      translate("search_hint"),
                      style: TextStyle(color: Colors.white, fontSize: 21),
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
              itemBuilder: (context, position) {
                return GestureDetector(
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
                              color: Color(0xFFD00B52),
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
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: new Icon(
                      Icons.search,
                      size: 24,
                      color: Color(0xFFD00B52),
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 3, right: 3),
                        hintText: translate("search_hint"),
                      ),
                      controller: searchController,
                    ),
                  ),
                  isSearchText
                      ? IconButton(
                          icon: new Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            setState(() {
                              searchController.text = "";
                            });
                          },
                        )
                      : IconButton(
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
          )
        ],
      ),
    );
  }
}
