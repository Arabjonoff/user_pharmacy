import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';

import '../../app_theme.dart';

class AddressAptekaListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaListScreenState();
  }
}

class _AddressAptekaListScreenState extends State<AddressAptekaListScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;
  String obj = "";

  _AddressAptekaListScreenState() {
    searchController.addListener(() {
      if (searchController.text != obj) {
        if (searchController.text.length > 0) {
          setState(() {
            obj = searchController.text;
            isSearchText = true;
          });
        } else {
          setState(() {
            obj = "";
            isSearchText = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 36,
            margin: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: AppTheme.black_transparent,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: new Icon(
                            Icons.search,
                            size: 24,
                            color: AppTheme.notWhite,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 36,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) {
//                                                Navigator.push(
//                                                  context,
//                                                  PageTransition(
//                                                    type:
//                                                        PageTransitionType.fade,
//                                                    child: ItemListScreen(
//                                                      translate(
//                                                          "search.result"),
//                                                      3,
//                                                      obj,
//                                                    ),
//                                                  ),
//                                                );
                                },
                                cursorColor: AppTheme.notWhite,
                                style: TextStyle(
                                  color: AppTheme.black_text,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: translate("search_real"),
                                  hintStyle: TextStyle(
                                    color: AppTheme.notWhite,
                                    fontSize: 15,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                controller: searchController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
