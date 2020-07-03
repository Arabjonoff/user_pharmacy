import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/item/item_screen.dart';
import 'package:pharmacy/src/ui/view/item_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../../app_theme.dart';
import 'card_empty_screen.dart';

final priceFormat = new NumberFormat("#,##0", "ru");

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

int count = 0;

class _CardScreenState extends State<CardScreen> {
  Size size;
  int count = 0;
  int allCount = 0;
  double allPrice = 0;

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    blocCard.fetchAllCard();
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1.0,
            backgroundColor: AppTheme.white,
            brightness: Brightness.light,
            title: Container(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          translate("card.name"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_text,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontCommons,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          translate(
                            count.toString() + " " + translate("item.tovar"),
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_transparent_text,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: StreamBuilder(
        stream: blocCard.allCard,
        builder: (context, AsyncSnapshot<List<ItemResult>> snapshot) {
          if (snapshot.hasData) {
            allCount = 0;
            allPrice = 0.0;
            count = snapshot.data.length;
            for (int i = 0; i < snapshot.data.length; i++) {
              allCount += snapshot.data[i].cardCount;
              allPrice += (snapshot.data[i].cardCount * snapshot.data[i].price);
            }
            return snapshot.data.length == 0
                ? CardEmptyScreen()
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
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.downToUp,
                                  alignment: Alignment.bottomCenter,
                                  child: ItemScreen(snapshot.data[index].id),
                                ),
                              );
                            },
                            child: Container(
                              height: snapshot.data[index].sale ? 172 : 160,
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
                                              imageUrl:
                                                  snapshot.data[index].image,
                                              placeholder: (context, url) =>
                                                  Icon(Icons.camera_alt),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
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
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      snapshot.data[index].sale
                                                          ? StrikeThroughWidget(
                                                              child: Text(
                                                                priceFormat.format(snapshot
                                                                        .data[
                                                                            index]
                                                                        .price) +
                                                                    translate(
                                                                        "sum"),
                                                                style:
                                                                    TextStyle(
                                                                  color: AppTheme
                                                                      .black_transparent_text,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      AppTheme
                                                                          .fontRoboto,
                                                                ),
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
                                                          color: snapshot
                                                                  .data[index]
                                                                  .sale
                                                              ? AppTheme
                                                                  .red_text_sale
                                                              : AppTheme
                                                                  .black_text,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 15.5),
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
                                                                  color: AppTheme
                                                                      .blue_transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
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
                                                                            dataBase.updateProduct(snapshot.data[index]);
                                                                          });
                                                                        } else if (snapshot.data[index].cardCount ==
                                                                            1) {
                                                                          setState(
                                                                              () {
                                                                            snapshot.data[index].cardCount =
                                                                                snapshot.data[index].cardCount - 1;
                                                                            if (snapshot.data[index].favourite) {
                                                                              dataBase.updateProduct(snapshot.data[index]);
                                                                            } else {
                                                                              dataBase.deleteProducts(snapshot.data[index].id);
                                                                            }
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
                                                                            color:
                                                                                AppTheme.blue,
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
                                                                          dataBase
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
                                                                    if (snapshot
                                                                        .data[
                                                                            index]
                                                                        .favourite) {
                                                                      dataBase.updateProduct(
                                                                          snapshot
                                                                              .data[index]);
                                                                    } else {
                                                                      dataBase.saveProducts(
                                                                          snapshot
                                                                              .data[index]);
                                                                    }
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
                                                      GestureDetector(
                                                        child: snapshot
                                                                .data[index]
                                                                .favourite
                                                            ? Icon(
                                                                Icons.favorite,
                                                                size: 24,
                                                                color: AppTheme
                                                                    .red_fav_color,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                size: 24,
                                                                color: AppTheme
                                                                    .arrow_catalog,
                                                              ),
                                                        onTap: () {
                                                          setState(() {
                                                            if (snapshot
                                                                .data[index]
                                                                .favourite) {
                                                              snapshot
                                                                      .data[index]
                                                                      .favourite =
                                                                  false;
                                                              if (snapshot
                                                                      .data[
                                                                          index]
                                                                      .cardCount ==
                                                                  0) {
                                                                dataBase.deleteProducts(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .id);
                                                              } else {
                                                                dataBase.updateProduct(
                                                                    snapshot.data[
                                                                        index]);
                                                              }
                                                            } else {
                                                              snapshot
                                                                  .data[index]
                                                                  .favourite = true;
                                                              if (snapshot
                                                                      .data[
                                                                          index]
                                                                      .cardCount ==
                                                                  0) {
                                                                dataBase.saveProducts(
                                                                    snapshot.data[
                                                                        index]);
                                                              } else {
                                                                dataBase.updateProduct(
                                                                    snapshot.data[
                                                                        index]);
                                                              }
                                                            }
                                                          });
                                                        },
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
                      Container(
                        child: Text(
                          translate("card.my_card"),
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppTheme.fontRoboto,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black_text,
                          ),
                        ),
                        margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 23,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              translate("card.all_card"),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              translate(allCount.toString()),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 18,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              translate("card.tovar_sum"),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              priceFormat.format(allPrice) +
                                  translate(translate("sum")),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 26,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              translate("card.all"),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black_text,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              priceFormat.format(allPrice) +
                                  translate(translate("sum")),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black_text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomDialog.createBottomSheetHistory(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppTheme.blue_app_color,
                          ),
                          height: 44,
                          width: size.width,
                          margin: EdgeInsets.only(
                            top: 47,
                            bottom: 47,
                            left: 12,
                            right: 12,
                          ),
                          child: Center(
                            child: Text(
                              translate("card.buy"),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 17,
                                color: AppTheme.white,
                              ),
                            ),
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

class StrikeThroughWidget extends StatelessWidget {
  final Widget _child;

  StrikeThroughWidget({Key key, @required Widget child})
      : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/red.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}