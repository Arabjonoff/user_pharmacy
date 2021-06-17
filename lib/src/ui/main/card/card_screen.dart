import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/min_sum.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/eventBus/card_item_change_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app_theme.dart';

class CardScreen extends StatefulWidget {
  final Function(CashBackData data) onPickup;
  final Function onCurer;
  final Function onLogin;

  CardScreen({
    this.onPickup,
    this.onCurer,
    this.onLogin,
  });

  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

bool isLogin = false;

class _CardScreenState extends State<CardScreen> {
  double allPrice = 0;
  var loadingPickup = false;
  var loadingDelivery = false;
  String errorText = "";
  bool isNext = false;
  List<CheckErroData> errorData = new List();
  int minSum = 0;

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    Repository().fetchMinSum().then((value) {
      if (value.isSuccess) {
        setState(() {
          minSum = MinSum.fromJson(value.result).min;
        });
      }
    });
    _registerBus();
    super.initState();
  }

  @override
  void dispose() {
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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("card.name"),
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
        stream: blocCard.allCard,
        builder: (context, AsyncSnapshot<List<ItemResult>> snapshot) {
          if (snapshot.hasData) {
            allPrice = 0.0;
            for (int i = 0; i < snapshot.data.length; i++) {
              allPrice += (snapshot.data[i].cardCount * snapshot.data[i].price);
            }

            allPrice.toInt() >= minSum ? isNext = true : isNext = false;

            if (errorData.length > 0) {
              for (int i = 0; i < errorData.length; i++) {
                for (int j = 0; j < snapshot.data.length; j++) {
                  if (errorData[i].drugId == snapshot.data[j].id) {
                    snapshot.data[j].msg = errorData[i].msg;
                  }
                }
              }
            }
            return Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                      left: 24,
                      right: 24,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: translate("card.choose"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.2,
                              color: AppTheme.text_dark,
                            ),
                          ),
                          TextSpan(
                            text: snapshot.data.length.toString(),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.2,
                              color: AppTheme.text_dark,
                            ),
                          ),
                          TextSpan(
                            text: translate("card.item"),
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
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppTheme.background,
                  ),
                  Expanded(
                    child: snapshot.data.length == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppTheme.yellow,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.asset(
                                  "assets/img/card_empty.png",
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                ),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    translate("card.empty_title"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 1.2,
                                      color: AppTheme.text_dark,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 8,
                                  left: 16,
                                  right: 16,
                                ),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    translate("card.empty_message"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      height: 1.2,
                                      color: AppTheme.textGray,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  RxBus.post(BottomViewModel(1),
                                      tag: "EVENT_BOTTOM_VIEW");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 16, right: 16, top: 16),
                                  height: 44,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      translate("card.empty_button"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.25,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
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
                                          BottomViewModel(
                                              snapshot.data[index].id),
                                          tag: "EVENT_BOTTOM_ITEM_ALL");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top: 16),
                                      color: AppTheme.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: 8),
                                              CachedNetworkImage(
                                                height: 80,
                                                width: 80,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snapshot.data[index]
                                                            .manufacturer.name,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme
                                                              .fontRubik,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 10,
                                                          height: 1.2,
                                                          color:
                                                              AppTheme.textGray,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        snapshot
                                                            .data[index].name,
                                                        style: TextStyle(
                                                          fontFamily: AppTheme
                                                              .fontRubik,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 14,
                                                          height: 1.5,
                                                          color: AppTheme
                                                              .text_dark,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
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
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14,
                                                                    height: 1.5,
                                                                    color: AppTheme
                                                                        .text_dark,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          Text(
                                                            priceFormat.format(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .price) +
                                                                translate(
                                                                    "sum"),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppTheme
                                                                      .fontRubik,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              height: 1.5,
                                                              color: AppTheme
                                                                  .text_dark,
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
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14,
                                                                    height: 1.5,
                                                                    color: AppTheme
                                                                        .text_dark,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                .msg,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppTheme
                                                                      .fontRubik,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 12,
                                                              color:
                                                                  AppTheme.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          bottom: 16,
                                                          top: 8,
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
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
                                                                      height:
                                                                          29,
                                                                      width: 29,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: snapshot.data[index].cardCount ==
                                                                                1
                                                                            ? AppTheme.gray
                                                                            : AppTheme.blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: SvgPicture.asset(
                                                                            "assets/icons/remove.svg"),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      if (snapshot
                                                                              .data[index]
                                                                              .cardCount >
                                                                          1) {
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .cardCount = snapshot
                                                                                .data[index].cardCount -
                                                                            1;
                                                                        dataBase
                                                                            .updateProduct(snapshot.data[index])
                                                                            .then((value) {
                                                                          blocCard
                                                                              .fetchAllCard();
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        snapshot.data[index].cardCount.toString() +
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
                                                                          color:
                                                                              AppTheme.text_dark,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .cardCount = snapshot
                                                                              .data[index]
                                                                              .cardCount +
                                                                          1;
                                                                      dataBase
                                                                          .updateProduct(snapshot.data[
                                                                              index])
                                                                          .then(
                                                                              (value) {
                                                                        blocCard
                                                                            .fetchAllCard();
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppTheme
                                                                            .blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                      ),
                                                                      height:
                                                                          29,
                                                                      width: 29,
                                                                      child:
                                                                          Center(
                                                                        child: SvgPicture.asset(
                                                                            "assets/icons/add.svg"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  Container(),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                dataBase
                                                                    .deleteProducts(
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .id)
                                                                    .then(
                                                                        (value) {
                                                                  blocCard
                                                                      .fetchAllCard();
                                                                });
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/icons/delete_item.svg"),
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
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.only(
                                                left: 8, right: 8),
                                            color: AppTheme.background,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              errorText != ""
                                  ? Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          top: 11, left: 16, right: 16),
                                      child: Text(
                                        errorText,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily: AppTheme.fontRubik,
                                          fontSize: 13,
                                          color: AppTheme.red,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              GestureDetector(
                                onTap: () async {
                                  if (isLogin) {
                                    if (isNext) {
                                      errorData = new List();
                                      setState(() {
                                        loadingDelivery = true;
                                        errorText = "";
                                      });
                                      AccessStore addModel = new AccessStore();
                                      List<ProductsStore> drugs = new List();

                                      var databaseItem =
                                          await dataBase.getProduct();

                                      for (int i = 0;
                                          i < databaseItem.length;
                                          i++) {
                                        drugs.add(
                                          ProductsStore(
                                            drugId: databaseItem[i].id,
                                            qty: databaseItem[i].cardCount,
                                          ),
                                        );
                                      }
                                      addModel = new AccessStore(
                                        lat: lat,
                                        lng: lng,
                                        products: drugs,
                                      );

                                      var response = await Repository()
                                          .fetchCheckErrorDelivery(
                                        addModel,
                                      );
                                      if (response.isSuccess) {
                                        var result = CheckErrorModel.fromJson(
                                            response.result);
                                        if (result.error == 0) {
                                          widget.onCurer();
                                          setState(() {
                                            loadingDelivery = false;
                                            errorText = "";
                                          });
                                        } else {
                                          setState(() {
                                            loadingDelivery = false;
                                            if (result.errors != null)
                                              errorData.addAll(result.errors);
                                            errorText = result.msg;
                                          });
                                        }
                                      } else if (response.status == -1) {
                                        setState(() {
                                          loadingDelivery = false;
                                          errorText = translate(
                                              "network.network_title");
                                        });
                                      } else {
                                        setState(() {
                                          loadingDelivery = false;
                                          errorText = response.result["msg"];
                                        });
                                      }
                                    }
                                  } else {
                                    widget.onLogin();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        isNext ? AppTheme.blue : AppTheme.gray,
                                  ),
                                  height: 44,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    top: 24,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: Center(
                                    child: loadingDelivery
                                        ? CircularProgressIndicator(
                                            value: null,
                                            strokeWidth: 3.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppTheme.white),
                                          )
                                        : Text(
                                            translate("card.delivery"),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRubik,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              height: 1.25,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (isLogin) {
                                    if (isNext) {
                                      errorData = new List();
                                      setState(() {
                                        loadingPickup = true;
                                        errorText = "";
                                      });
                                      AccessStore addModel = new AccessStore();
                                      List<ProductsStore> drugs = new List();

                                      var databaseItem =
                                          await dataBase.getProduct();

                                      for (int i = 0;
                                          i < databaseItem.length;
                                          i++) {
                                        drugs.add(
                                          ProductsStore(
                                            drugId: databaseItem[i].id,
                                            qty: databaseItem[i].cardCount,
                                          ),
                                        );
                                      }
                                      addModel = new AccessStore(
                                        lat: lat,
                                        lng: lng,
                                        products: drugs,
                                      );

                                      var response = await Repository()
                                          .fetchCheckErrorPickup(
                                        addModel,
                                      );

                                      if (response.isSuccess) {
                                        var result = CheckErrorModel.fromJson(
                                            response.result);
                                        if (result.error == 0) {
                                          errorData = new List();
                                          widget.onPickup(result.data);
                                          setState(() {
                                            loadingPickup = false;
                                            errorText = "";
                                          });
                                        } else {
                                          setState(() {
                                            loadingPickup = false;
                                            errorData = new List();
                                            if (result.errors != null)
                                              errorData.addAll(result.errors);
                                            errorText = result.msg;
                                          });
                                        }
                                      } else if (response.status == -1) {
                                        setState(() {
                                          loadingPickup = false;
                                          errorText = translate(
                                              "network.network_title");
                                        });
                                      } else {
                                        setState(() {
                                          loadingPickup = false;
                                          errorText = response.result["msg"];
                                        });
                                      }
                                    }
                                  } else {
                                    widget.onLogin();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme.white,
                                    border: Border.all(
                                      color: AppTheme.textGray,
                                      width: 2,
                                    ),
                                  ),
                                  height: 44,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: Center(
                                    child: loadingPickup
                                        ? CircularProgressIndicator(
                                            value: null,
                                            strokeWidth: 3.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppTheme.textGray,
                                            ),
                                          )
                                        : Text(
                                            translate("card.take"),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRubik,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              height: 1.25,
                                              color: AppTheme.textGray,
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  )
                ],
              ),
            );
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _registerBus() {
    RxBus.register<CardItemChangeModel>(tag: "EVENT_CARD_BOTTOM")
        .listen((event) => {
              if (event.cardChange)
                {
                  Timer(Duration(milliseconds: 100), () {
                    blocCard.fetchAllCard();
                    BottomDialog.bottomDialogOrder(context);
                  }),
                },
            });

    RxBus.register<BottomView>(tag: "CARD_VIEW").listen((event) {
      if (event.title) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }
}
