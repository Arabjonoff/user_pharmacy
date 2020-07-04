import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:pharmacy/src/ui/view/item_view.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemListScreen extends StatefulWidget {
  String name;
  int type;
  String id;

  ItemListScreen(this.name, this.type, this.id);

  @override
  State<StatefulWidget> createState() {
    return _ItemListScreenState();
  }
}



class _ItemListScreenState extends State<ItemListScreen> {
  Size size;

  DatabaseHelper dataBase = new DatabaseHelper();
  int itemSize = 0;
  int lastPosition;
  static int page = 1;
  bool isLoading = false;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    page = 1;
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

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
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 24,
                        color: AppTheme.blue_app_color,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 12),
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
                            itemSize.toString() + " " + translate("item.tovar"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              color: AppTheme.black_transparent_text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
      body: Column(
        children: <Widget>[
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
                        widget.type == 3
                            ? Navigator.pop(context)
                            : Navigator.push(
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
                              widget.type == 3
                                  ? widget.id
                                  : translate("search_hint"),
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
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: widget.type == 2
                    ? blocItemsList.getBestItem
                    : widget.type == 3
                        ? blocItemsList.getItemSearch
                        : blocItemsList.allItemsCategoty,
                builder: (context, AsyncSnapshot<List<ItemResult>> snapshot) {
                  if (snapshot.hasData) {
                    lastPosition == snapshot.data.length
                        ? isLoading = true
                        : isLoading = false;
                    lastPosition = snapshot.data.length;

                    return snapshot.data.length > 0
                        ? ListView.builder(
                            controller: _sc,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length + 1,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Opacity(
                                      opacity: isLoading ? 0.0 : 1.0,
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return ItemView(
                                  snapshot.data[index],
                                );
                              }
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                              ),
                              SvgPicture.asset(
                                "assets/images/empty.svg",
                                height: 155,
                                width: 155,
                              ),
                              Container(
                                width: 210,
                                child: Text(
                                  translate("search.empty"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.search_empty,
                                  ),
                                ),
                              )
                            ],
                          );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, __) => Container(
                        height: 160,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                      left: 15,
                                      right: 14,
                                      bottom: 22.5,
                                    ),
                                    height: 112,
                                    width: 112,
                                    color: AppTheme.white,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 17),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Container(
                                            height: 13,
                                            width: double.infinity,
                                            color: AppTheme.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 3),
                                            height: 11,
                                            width: 120,
                                            color: AppTheme.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 25),
                                            height: 13,
                                            width: 120,
                                            color: AppTheme.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(left: 8, right: 8),
                              color: AppTheme.black_linear,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        widget.type == 2
            ? blocItemsList.fetchAllItemCategoryBest(index)
            : widget.type == 3
                ? blocItemsList.fetchAllItemSearch(widget.id, index)
                : blocItemsList.fetchAllItemCategory(widget.id, index);
        isLoading = false;
        page++;
      });
    }
  }
}
