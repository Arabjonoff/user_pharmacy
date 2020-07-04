import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/category_bloc.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/ui/main/category/sub_category_screen.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app_theme.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    blocCategory.fetchAllCategory();
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
          title: Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text(
                    translate("main.catalog"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontCommons,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: AppTheme.black_text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            margin: EdgeInsets.only(top: 48),
            child: StreamBuilder(
              stream: blocCategory.allCategory,
              builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SubCategoryScreen(
                                snapshot.data.results[position].name,
                                snapshot.data.results[position].childs,
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
                                        snapshot.data.results[position].name,
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
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: ListView.builder(
                    itemBuilder: (_, __) => Container(
                      height: 48,
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 15,
                            width: 250,
                            color: AppTheme.white,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppTheme.arrow_catalog,
                          )
                        ],
                      ),
                    ),
                    itemCount: 20,
                  ),
                );
              },
            ),
          ),
          Container(
            color: AppTheme.white,
            height: 36,
            width: size.width,
            padding: EdgeInsets.only(
              left: 12,
              right: 18,
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
                            child: SearchScreen("", 0),
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
                      (value) => {
                        if (value != "-1")
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SearchScreen(value, 1),
                            ),
                          )
                      },
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
