import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/fav_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/fav/fav_empty_screen.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app_theme.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavouriteScreenState();
  }
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  DatabaseHelper dataBaseCard = new DatabaseHelper();

  @override
  void initState() {
    blocFav.fetchAllFav();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("main.favourite"),
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
      body: StreamBuilder(
        stream: blocFav.allFav,
        builder: (context, AsyncSnapshot<List<ItemResult>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? FavEmptyScreen()
                : ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              RxBus.post(
                                  BottomViewModel(snapshot.data[index].id),
                                  tag: "EVENT_BOTTOM_ITEM_ALL");
                            },
                            child: Container(
                              height: 160,
                              color: AppTheme.white,
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
                                          child: Center(
                                            child: CachedNetworkImage(
                                              height: 112,
                                              width: 112,
                                              imageUrl: snapshot
                                                  .data[index].imageThumbnail,
                                              placeholder: (context, url) =>
                                                  Container(
                                                padding: EdgeInsets.all(25),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                padding: EdgeInsets.all(25),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                Text(
                                                  snapshot.data[index].name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppTheme.black_text,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                Row(
                                                  children: <Widget>[],
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  snapshot.data[index]
                                                              .manufacturer ==
                                                          null
                                                      ? ""
                                                      : snapshot.data[index]
                                                          .manufacturer.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .black_transparent_text,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      translate("lan") != "2"
                                                          ? Text(
                                                              translate("from"),
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .black_text,
                                                                height: 1.33,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily: AppTheme
                                                                    .fontRoboto,
                                                              ),
                                                            )
                                                          : Container(),
                                                      Text(
                                                        priceFormat.format(
                                                                snapshot
                                                                    .data[index]
                                                                    .price) +
                                                            translate("sum"),
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .black_text,
                                                          height: 1.33,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                        ),
                                                      ),
                                                      translate("lan") == "2"
                                                          ? Text(
                                                              translate("from"),
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .black_text,
                                                                height: 1.33,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily: AppTheme
                                                                    .fontRoboto,
                                                              ),
                                                            )
                                                          : Container(),
                                                      Expanded(
                                                          child: Container()),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        snapshot
                                                            .data[index].msg,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                          color: AppTheme
                                                              .red_fav_color,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 7,
                                                  ),
                                                  height: 30,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        height: 30,
                                                        child: snapshot
                                                                    .data[index]
                                                                    .cardCount >
                                                                0
                                                            ? Container(
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: snapshot
                                                                              .data[
                                                                                  index]
                                                                              .msg
                                                                              .length >
                                                                          0
                                                                      ? AppTheme
                                                                          .red_fav_color
                                                                          .withOpacity(
                                                                          0.1,
                                                                        )
                                                                      : AppTheme
                                                                          .blue_transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.0,
                                                                  ),
                                                                ),
                                                                width: 120,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    GestureDetector(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppTheme.blue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            10.0,
                                                                          ),
                                                                        ),
                                                                        margin:
                                                                            EdgeInsets.all(2.0),
                                                                        height:
                                                                            26,
                                                                        width:
                                                                            26,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove,
                                                                            color:
                                                                                AppTheme.white,
                                                                            size:
                                                                                19,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        if (snapshot.data[index].cardCount >
                                                                            1) {
                                                                          setState(
                                                                              () {
                                                                            snapshot.data[index].cardCount =
                                                                                snapshot.data[index].cardCount - 1;
                                                                            dataBaseCard.updateProduct(snapshot.data[index]);
                                                                          });
                                                                        } else if (snapshot.data[index].cardCount ==
                                                                            1) {
                                                                          setState(
                                                                              () {
                                                                            snapshot.data[index].cardCount =
                                                                                snapshot.data[index].cardCount - 1;
                                                                            dataBaseCard.deleteProducts(snapshot.data[index].id);
                                                                          });
                                                                        }
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      width: 60,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          snapshot.data[index].cardCount.toString() +
                                                                              " " +
                                                                              translate("item.sht"),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15.0,
                                                                            color: snapshot.data[index].msg.length > 0
                                                                                ? AppTheme.red_fav_color
                                                                                : AppTheme.blue,
                                                                            fontFamily:
                                                                                AppTheme.fontRoboto,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          snapshot
                                                                              .data[index]
                                                                              .cardCount = snapshot.data[index].cardCount + 1;
                                                                          dataBaseCard
                                                                              .updateProduct(snapshot.data[index]);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppTheme.blue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            10.0,
                                                                          ),
                                                                        ),
                                                                        height:
                                                                            26,
                                                                        width:
                                                                            26,
                                                                        margin:
                                                                            EdgeInsets.all(2.0),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                AppTheme.white,
                                                                            size:
                                                                                19,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .cardCount = 1;

                                                                    dataBaseCard
                                                                        .saveProducts(
                                                                            snapshot.data[index]);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 120,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          10.0),
                                                                    ),
                                                                    color:
                                                                        AppTheme
                                                                            .blue,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      translate(
                                                                          "item.card"),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            AppTheme.fontRoboto,
                                                                        color: AppTheme
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
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
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    color: AppTheme.black_linear,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
