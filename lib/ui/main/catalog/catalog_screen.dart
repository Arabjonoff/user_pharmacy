import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/model/category_model.dart';
import 'package:pharmacy/ui/main/catalog/sub_catalog_screen.dart';
import 'package:pharmacy/ui/search/search_screen.dart';

import '../../../app_theme.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  Size size;
  List<CategoryModel> categoryModel = CategoryModel.categoryModel;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.green_app_color,
        title: Container(
          width: size.width,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              translate("main.catalog"),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "Sofia",
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.background,
      body: Stack(
        children: <Widget>[
          Container(
            height: 24,
            width: size.width,
            color: AppTheme.green_app_color,
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: ListView.builder(
              itemCount: categoryModel.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: SubCategoryScreen(
                          categoryModel[position].name,
                          categoryModel[position].subCategory,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      position == 0
                          ? SizedBox(
                              height: 24,
                            )
                          : Container(),
                      Container(
                        color: AppTheme.white,
                        child: Container(
                          height: 48,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  categoryModel[position].name,
                                  style: TextStyle(
                                      color: AppTheme.dark_grey,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppTheme.green_app_color,
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
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                      child: SearchScreen(""),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: new Icon(
                        Icons.search,
                        size: 24,
                        color: AppTheme.green_app_color,
                      ),
                      onPressed: () {},
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
