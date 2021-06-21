import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_fav.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class ItemListScreen extends StatefulWidget {
  final String name;
  final int type;
  final String id;

  ItemListScreen({
    this.name,
    this.type,
    this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return _ItemListScreenState();
  }
}

class _ItemListScreenState extends State<ItemListScreen> {
  int page = 1;
  String priceMax = "";
  String ordering = "";
  DatabaseHelper dataBase = new DatabaseHelper();
  DatabaseHelperFav dataBaseFav = new DatabaseHelperFav();
  bool isLoading = false;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    super.initState();
    _registerBus();
    _getMoreData(1);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    RxBus.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
            padding: EdgeInsets.all(13),
            child: SvgPicture.asset("assets/icons/arrow_left_blue.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.2,
                color: AppTheme.text_dark,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(110, 120, 146, 0.05),
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0,
              )
            ]),
          ),
          Expanded(
            child: StreamBuilder(
              stream: blocItemsList.allItemsList,
              builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data.next == null
                      ? isLoading = true
                      : isLoading = false;
                  return snapshot.data.results.length > 0
                      ? ListView.builder(
                          controller: _sc,
                          itemCount: snapshot.data.results.length + 1,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if (index == snapshot.data.results.length) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Center(
                                  child: new Opacity(
                                    opacity: isLoading ? 0.0 : 1.0,
                                    child: Container(
                                      height: 64,
                                      child: Lottie.asset(
                                          'assets/anim/item_load_animation.json'),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  RxBus.post(
                                      BottomViewModel(
                                          snapshot.data.results[index].id),
                                      tag: "EVENT_BOTTOM_ITEM_ALL");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 16, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 85,
                                        width: 80,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              child: CachedNetworkImage(
                                                height: 80,
                                                width: 80,
                                                imageUrl: snapshot
                                                    .data
                                                    .results[index]
                                                    .imageThumbnail,
                                                placeholder: (context, url) =>
                                                    SvgPicture.asset(
                                                  "assets/icons/default_image.svg",
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        SvgPicture.asset(
                                                  "assets/icons/default_image.svg",
                                                ),
                                              ),
                                              bottom: 0,
                                            ),
                                            Positioned(
                                              child:
                                                  snapshot.data.results[index]
                                                              .price >=
                                                          snapshot
                                                              .data
                                                              .results[index]
                                                              .basePrice
                                                      ? Container()
                                                      : Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppTheme.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Text(
                                                            "-" +
                                                                (((snapshot.data.results[index].basePrice - snapshot.data.results[index].price) *
                                                                            100) ~/
                                                                        snapshot
                                                                            .data
                                                                            .results[index]
                                                                            .basePrice)
                                                                    .toString() +
                                                                "%",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppTheme
                                                                      .fontRubik,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              height: 1.2,
                                                              color: AppTheme
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),
                                              top: 0,
                                              left: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data.results[index]
                                                    .manufacturer.name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 10,
                                                  height: 1.2,
                                                  color: AppTheme.textGray,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                snapshot
                                                    .data.results[index].name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  height: 1.5,
                                                  color: AppTheme.text_dark,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    snapshot.data.results[index]
                                                                .cardCount >
                                                            0
                                                        ? Container(
                                                            height: 29,
                                                            width: 147,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppTheme
                                                                  .blue
                                                                  .withOpacity(
                                                                      0.12),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                8,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                GestureDetector(
                                                                  child:
                                                                      Container(
                                                                    height: 29,
                                                                    width: 29,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppTheme
                                                                          .blue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/icons/remove.svg"),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    if (snapshot
                                                                            .data
                                                                            .results[index]
                                                                            .cardCount >
                                                                        1) {
                                                                      snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount = snapshot
                                                                              .data
                                                                              .results[index]
                                                                              .cardCount -
                                                                          1;
                                                                      dataBase
                                                                          .updateProduct(snapshot
                                                                              .data
                                                                              .results[index])
                                                                          .then((value) {
                                                                        blocItemsList
                                                                            .update(widget.type);
                                                                      });
                                                                    } else if (snapshot
                                                                            .data
                                                                            .results[index]
                                                                            .cardCount ==
                                                                        1) {
                                                                      dataBase
                                                                          .deleteProducts(snapshot
                                                                              .data
                                                                              .results[index]
                                                                              .id)
                                                                          .then((value) {
                                                                        blocItemsList
                                                                            .update(widget.type);
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      snapshot
                                                                              .data
                                                                              .results[index]
                                                                              .cardCount
                                                                              .toString() +
                                                                          " " +
                                                                          translate("item.sht"),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            AppTheme.fontRubik,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            12,
                                                                        height:
                                                                            1.2,
                                                                        color: AppTheme
                                                                            .text_dark,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .results[index]
                                                                            .cardCount +
                                                                        1;
                                                                    dataBase
                                                                        .updateProduct(snapshot
                                                                            .data
                                                                            .results[index])
                                                                        .then((value) {
                                                                      blocItemsList
                                                                          .update(
                                                                              widget.type);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppTheme
                                                                          .blue,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        8,
                                                                      ),
                                                                    ),
                                                                    height: 29,
                                                                    width: 29,
                                                                    child:
                                                                        Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/icons/add.svg"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              snapshot
                                                                  .data
                                                                  .results[
                                                                      index]
                                                                  .cardCount = 1;

                                                              dataBase
                                                                  .saveProducts(
                                                                      snapshot
                                                                          .data
                                                                          .results[index])
                                                                  .then((value) {
                                                                blocItemsList
                                                                    .update(widget
                                                                        .type);
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 28,
                                                              width: 147,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          8),
                                                                ),
                                                                color: AppTheme
                                                                    .blue,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  translate("lan") !=
                                                                          "2"
                                                                      ? Text(
                                                                          translate(
                                                                              "from"),
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                AppTheme.fontRubik,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            fontSize:
                                                                                14,
                                                                            height:
                                                                                1.5,
                                                                            color:
                                                                                AppTheme.white,
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  Text(
                                                                    priceFormat.format(snapshot
                                                                            .data
                                                                            .results[
                                                                                index]
                                                                            .price) +
                                                                        translate(
                                                                            "sum"),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.5,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  translate("lan") ==
                                                                          "2"
                                                                      ? Text(
                                                                          translate(
                                                                              "from"),
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                AppTheme.fontRubik,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            fontSize:
                                                                                14,
                                                                            height:
                                                                                1.5,
                                                                            color:
                                                                                AppTheme.white,
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (snapshot
                                                            .data
                                                            .results[index]
                                                            .favourite) {
                                                          dataBaseFav
                                                              .deleteProducts(
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .id)
                                                              .then((value) {
                                                            blocItemsList
                                                                .update(widget
                                                                    .type);
                                                          });
                                                        } else {
                                                          dataBaseFav
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .results[
                                                                      index])
                                                              .then((value) {
                                                            blocItemsList
                                                                .update(widget
                                                                    .type);
                                                          });
                                                        }
                                                      },
                                                      child: snapshot
                                                              .data
                                                              .results[index]
                                                              .favourite
                                                          ? SvgPicture.asset(
                                                              "assets/icons/fav_select.svg")
                                                          : SvgPicture.asset(
                                                              "assets/icons/fav_unselect.svg"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  fontFamily: AppTheme.fontRubik,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.search_empty,
                                ),
                              ),
                            ),
                          ],
                        );
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: new ListView.builder(
                    itemCount: 20,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        height: 117,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _registerBus() {
    RxBus.register<BottomView>(tag: "LIST_VIEW_ERROR_NETWORK").listen(
      (event) {
        BottomDialog.showNetworkError(context, () {
          page = 1;
          _getMoreData(page);
        });
      },
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      switch (widget.type) {
        case 1:
          {
            /// recently
            blocItemsList.fetchAllRecently(
              page,
              ordering,
              priceMax,
            );
            break;
          }
        case 2:
          {
            ///category
            blocItemsList.fetchCategory(
              widget.id,
              page,
              ordering,
              priceMax,
            );
            break;
          }
        case 3:
          {
            ///Best item
            blocItemsList.fetchAllBestItem(
              page,
              ordering,
              priceMax,
            );
            break;
          }

        case 4:
          {
            ///Best item
            blocItemsList.fetchAllCollItem(
              page,
              ordering,
              priceMax,
            );
            break;
          }
        case 5:
          {
            ///IDS
            blocItemsList.fetchAllIdsItem(
              widget.id,
              page,
              ordering,
              priceMax,
            );
            break;
          }
        case 6:
          {
            ///search
            blocItemsList.fetchAllSearchItem(
              widget.id,
              page,
              ordering,
              priceMax,
            );
            break;
          }
      }
      page++;
    }
  }
}
