import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/search/search_screen.dart';
import 'package:pharmacy/ui/view/item_view.dart';
import 'package:pharmacy/utils/utils.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemListScreen extends StatefulWidget {
  String name;

  ItemListScreen(this.name);

  @override
  State<StatefulWidget> createState() {
    return _ItemListScreenState();
  }
}

class _ItemListScreenState extends State<ItemListScreen> {
  Size size;

  List<ItemModel> items = ItemModel.itemsModel;

  List<ItemModel> itemCard = new List();
  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    dataBase.getAllProducts().then((products) {
      setState(() {
        products.forEach((products) {
          itemCard.add(ItemModel.fromMap(products));
        });
        for (var i = 0; i < items.length; i++) {
          for (var j = 0; j < itemCard.length; j++) {
            if (items[i].id == itemCard[j].id) {
              items[i].cardCount = itemCard[j].cardCount;
              items[i].favourite = itemCard[j].favourite;
            }
          }
        }
      });
    });
    super.initState();
  }

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
            margin: EdgeInsets.only(top: 48),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 56,
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 13,
                            ),
                            Container(
                              child: SvgPicture.asset(
                                "assets/images/name_sort.svg",
                              ),
                            ),
                            SizedBox(
                              width: 19,
                            ),
                            Expanded(
                              child: Text(
                                translate("item.sort"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontSize: 15,
                                  color: AppTheme.black_text,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 13,
                            ),
                            Container(
                              child: SvgPicture.asset(
                                "assets/images/filter.svg",
                              ),
                              width: 19,
                            ),
                            SizedBox(
                              width: 19,
                            ),
                            Expanded(
                              child: Text(
                                translate("item.filter"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontSize: 15,
                                  color: AppTheme.black_text,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: 1,
                  color: AppTheme.black_linear,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemView(items[index]);
                  },
                ),
              ],
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
                    margin: EdgeInsets.only(left: 15,right: 6),
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
