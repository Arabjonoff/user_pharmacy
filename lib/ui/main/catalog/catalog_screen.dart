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
//      appBar: AppBar(
//        elevation: 0.0,
//        backgroundColor: AppTheme.white,
//        brightness: Brightness.light,
//        title: Text(
//          translate("main.catalog"),
//          textAlign: TextAlign.start,
//          style: TextStyle(
//            //fontFamily: "Sofia",
//            fontSize: 21,
//            fontFamily: AppTheme.fontCommons,
//            fontWeight: FontWeight.normal,
//            color: AppTheme.black_text,
//          ),
//        ),
//      ),
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 24, left: 12, right: 12),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translate("main.catalog"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontCommons,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: AppTheme.black_text,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.only(top: 108),
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
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
                        margin: EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        height: 1,
                        color: AppTheme.black_linear_category,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            color: AppTheme.white,
            height: 48,
            width: size.width,
            padding: EdgeInsets.only(
              top: 6,
              bottom: 6,
              left: 12,
              right: 18,
            ),
            margin: EdgeInsets.only(
              top: 84,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: AppTheme.black_transparent,
                    ),
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
                        children: [
                          IconButton(
                            icon: new Icon(
                              Icons.search,
                              size: 24,
                              color: AppTheme.notWhite,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              translate("search_hint"),
                              style: TextStyle(
                                color: AppTheme.notWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRoboto,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 17),
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
