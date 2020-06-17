import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/model/category_model.dart';
import 'package:pharmacy/ui/main/catalog/sub_catalog_screen.dart';
import 'package:pharmacy/ui/search/search_screen.dart';
import 'package:pharmacy/utils/utils.dart';

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
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Text(
          translate("main.catalog"),
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
                                  categoryModel[position].name,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppTheme.black_catalog,
                                    fontFamily: AppTheme.fontSFProText,
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
                              fontFamily: AppTheme.fontSFProText,
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
