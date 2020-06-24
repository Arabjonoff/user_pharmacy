import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/api/item_model.dart';
import 'package:pharmacy/ui/search/search_screen.dart';
import 'package:pharmacy/ui/view/item_view.dart';
import 'package:pharmacy/utils/api.dart';
import 'package:pharmacy/utils/utils.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemListScreen extends StatefulWidget {
  String name;
  int type;
  int id;

  ItemListScreen(this.name, this.type, this.id);

  @override
  State<StatefulWidget> createState() {
    return _ItemListScreenState();
  }
}

class _ItemListScreenState extends State<ItemListScreen> {
  Size size;

  List<ItemResult> items = new List();
  List<ItemResult> itemCard = new List();

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 24, left: 12, right: 12),
            height: 70,
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: AppTheme.blue_app_color,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontFamily: AppTheme.fontCommons,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: AppTheme.black_text,
                        ),
                      ),
                      Text(
                        items.length.toString() + " " + translate("item.tovar"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 108),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 56,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: SvgPicture.asset(
                                "assets/images/name_sort.svg",
                              ),
                            ),
                            SizedBox(
                              width: 19,
                            ),
                            Text(
                              translate("item.sort"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 15,
                                color: AppTheme.black_text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        margin: EdgeInsets.only(top: 16, bottom: 8),
                        height: 56,
                        color: AppTheme.black_linear,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: SvgPicture.asset(
                                "assets/images/filter.svg",
                              ),
                              width: 19,
                            ),
                            SizedBox(
                              width: 19,
                            ),
                            Text(
                              translate("item.filter"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 15,
                                color: AppTheme.black_text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                FutureBuilder<List<ItemResult>>(
                  future: widget.type == 1
                      ? API.getItems(widget.id)
                      : widget.type == 2
                          ? API.getHome()
                          : API.getItems(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SizedBox(
                        child: Text(
                          "нет интернета",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      items = snapshot.data;
                      dataBase.getAllProducts().then((products) {
                        setState(() {
                          products.forEach((products) {
                            itemCard.add(ItemResult.fromMap(products));
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
                    }
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ItemView(
                                items[index],
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ],
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
              right: 12,
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
                    margin: EdgeInsets.only(left: 17, right: 6),
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
                          child: SearchScreen(value, 1),
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
