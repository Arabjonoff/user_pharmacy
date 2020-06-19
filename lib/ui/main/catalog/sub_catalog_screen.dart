import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/model/category_model.dart';
import 'package:pharmacy/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/ui/search/search_screen.dart';
import 'package:pharmacy/utils/utils.dart';

import '../../../app_theme.dart';

// ignore: must_be_immutable
class SubCategoryScreen extends StatefulWidget {
  String name;
  List<SubCategoryModel> list;

  SubCategoryScreen(this.name, this.list);

  @override
  State<StatefulWidget> createState() {
    return _SubCategoryScreenState();
  }
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: AppTheme.black_catalog,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.name,
          textAlign: TextAlign.start,
          style: TextStyle(
            //fontFamily: "Sofia",
            fontSize: 21,
            fontFamily: AppTheme.fontCommons,
            fontWeight: FontWeight.normal,
            color: AppTheme.black_text,
          ),
        ),
      ),
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            margin: EdgeInsets.only(top: 56),
            child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ItemListScreen(
                          widget.list[position].name,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: AppTheme.white,
                        child: Container(
                          height: 48,
                          padding: EdgeInsets.only(top: 6, bottom: 6),
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.list[position].name,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppTheme.black_catalog,
                                    fontFamily: AppTheme.fontRoboto,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppTheme.arrow_catalog,
                              )
                            ],
                          ),
                        ),
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
            height: 48,
            width: size.width,
            padding: EdgeInsets.only(
              top: 6,
              bottom: 6,
            ),
            margin: EdgeInsets.only(
              left: 12,
              right: 12,
            ),
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
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Text(
                            translate("search_hint"),
                            style: TextStyle(
                              color: AppTheme.notWhite,
                              fontSize: 17,
                              fontFamily: AppTheme.fontRoboto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Center(
                      child: Image.asset("assets/images/scanner.png"),
                    ),
                  ),
                  onTap: () {
                    var response = Utils.scanBarcodeNormal();
                    response.then(
                      (value) => Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: SearchScreen(value),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
