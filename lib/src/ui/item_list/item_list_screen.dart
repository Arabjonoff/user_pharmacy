import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_fav.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
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
      body: StreamBuilder(
        stream: blocItemsList.allItemsList,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.next == null ? isLoading = true : isLoading = false;
            return snapshot.data.results.length > 0
                ? StaggeredGridView.countBuilder(
                    controller: _sc,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    crossAxisCount: 4,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white,
                        ),
                        height: 190,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Center(
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data.results[index].imageThumbnail,
                                      placeholder: (context, url) =>
                                          SvgPicture.asset(
                                        "assets/images/place_holder.svg",
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        "assets/images/place_holder.svg",
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Positioned(
                                    child: GestureDetector(
                                      onTap: () {
                                        snapshot.data.results[index].favourite =
                                            !snapshot
                                                .data.results[index].favourite;
                                        if (snapshot
                                            .data.results[index].favourite) {
                                          dataBaseFav
                                              .saveProducts(
                                                  snapshot.data.results[index])
                                              .then((value) {
                                            blocItemsList.update(widget.type);
                                          });
                                        } else {
                                          dataBaseFav
                                              .deleteProducts(snapshot
                                                  .data.results[index].id)
                                              .then((value) {
                                            blocItemsList.update(widget.type);
                                          });
                                        }
                                      },
                                      child: snapshot
                                              .data.results[index].favourite
                                          ? SvgPicture.asset(
                                              "assets/icons/fav_select.svg")
                                          : SvgPicture.asset(
                                              "assets/icons/fav_unselect.svg"),
                                    ),
                                    top: 0,
                                    right: 0,
                                  ),
                                  Positioned(
                                    child: snapshot.data.results[index].price >=
                                            snapshot
                                                .data.results[index].basePrice
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color:
                                                  AppTheme.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "-" +
                                                  (((snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .basePrice -
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .price) *
                                                              100) ~/
                                                          snapshot
                                                              .data
                                                              .results[index]
                                                              .basePrice)
                                                      .toString() +
                                                  "%",
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                height: 1.2,
                                                color: AppTheme.red,
                                              ),
                                            ),
                                          ),
                                    top: 0,
                                    left: 0,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              snapshot.data.results[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                height: 1.5,
                                color: AppTheme.text_dark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              snapshot.data.results[index].manufacturer.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            SizedBox(height: 4),
                            snapshot.data.results[index].isComing
                                ? Container(
                                    height: 29,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: translate("fast"),
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                height: 1.2,
                                                color: AppTheme.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : snapshot.data.results[index].cardCount > 0
                                    ? Container(
                                        height: 29,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                              AppTheme.blue.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (snapshot.data.results[index]
                                                        .cardCount >
                                                    1) {
                                                  snapshot.data.results[index]
                                                      .cardCount = snapshot
                                                          .data
                                                          .results[index]
                                                          .cardCount -
                                                      1;
                                                  dataBase
                                                      .updateProduct(snapshot
                                                          .data.results[index])
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
                                              child: Container(
                                                height: 29,
                                                width: 29,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/remove.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  snapshot.data.results[index]
                                                          .cardCount
                                                          .toString() +
                                                      " " +
                                                      translate("sht"),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    height: 1.2,
                                                    color: AppTheme.text_dark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (snapshot.data.results[index]
                                                        .cardCount <
                                                    snapshot.data.results[index]
                                                        .maxCount)
                                                  snapshot.data.results[index]
                                                      .cardCount = snapshot
                                                          .data
                                                          .results[index]
                                                          .cardCount +
                                                      1;
                                                dataBase
                                                    .updateProduct(snapshot
                                                        .data.results[index])
                                                    .then((value) {
                                                  blocItemsList
                                                      .update(widget.type);
                                                });
                                              },
                                              child: Container(
                                                height: 29,
                                                width: 29,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/add.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          snapshot.data.results[index]
                                              .cardCount = 1;
                                          dataBase
                                              .saveProducts(
                                                  snapshot.data.results[index])
                                              .then((value) {
                                            blocItemsList.update(widget.type);
                                          });
                                        },
                                        child: Container(
                                          height: 29,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppTheme.blue,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: priceFormat.format(
                                                        snapshot
                                                            .data
                                                            .results[index]
                                                            .price),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      height: 1.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: translate("sum"),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      height: 1.2,
                                                      color: AppTheme.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(2),
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
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
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              crossAxisCount: 4,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppTheme.white,
                  ),
                  height: 190,
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
          );
        },
      ),
    );
  }

  void _registerBus() {
    RxBus.register<BottomView>(tag: "LIST_VIEW_ERROR_NETWORK").listen(
      (event) {
        /// network error
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
