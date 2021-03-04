import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/src/blocs/history_bloc.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/order_card_curer.dart';
import 'package:pharmacy/src/ui/shopping_pickup/order_card_pickup.dart';
import 'package:pharmacy/src/ui/sub_menu/order_number.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

class HistoryOrderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryOrderScreenState();
  }
}

int pageHistory = 1;

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  bool isLoading = false;

  ScrollController _sc = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _getMoreData(1);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(pageHistory);
      }
    });

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
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.arrow_examp_back,
            padding: EdgeInsets.all(19),
            child: SvgPicture.asset("assets/images/arrow_back.svg"),
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
              translate("menu.history"),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.black_text,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontCommons,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: AppTheme.white,
        color: AppTheme.blue,
        key: _refreshIndicatorKey,
        onRefresh: _refreshRegion,
        child: StreamBuilder(
          stream: blocHistory.allHistory,
          builder: (context, AsyncSnapshot<HistoryModel> snapshot) {
            if (snapshot.hasData) {
              snapshot.data.next == null ? isLoading = true : isLoading = false;
              return snapshot.data.results.length > 0
                  ? ListView.builder(
                      controller: _sc,
                      itemCount: snapshot.data.results.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.results.length) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Opacity(
                                opacity: isLoading ? 0.0 : 1.0,
                                child: Container(
                                  height: 72,
                                  child: Lottie.asset(
                                      'assets/anim/item_load_animation.json'),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if (snapshot.data.results[index].status ==
                                  "payment_waiting") {
                                if (snapshot.data.results[index].type ==
                                    "self") {
                                  Utils.getCashBack().then(
                                    (value) => {
                                      cashData = new CashBackData(
                                        total:
                                            snapshot.data.results[index].total,
                                        cash: value == null ? 0.0 : value,
                                      ),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderCardPickupScreen(
                                            snapshot.data.results[index].id,
                                            snapshot.data.results[index]
                                                .expireSelfOrder,
                                          ),
                                        ),
                                      ),
                                    },
                                  );
                                } else {
                                  Utils.getCashBack().then(
                                    (value) => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderCardCurerScreen(
                                            orderId:
                                                snapshot.data.results[index].id,
                                            price: snapshot
                                                .data.results[index].realTotal,
                                            cash: value == null ? 0.0 : value,
                                            deliveryPrice: snapshot.data
                                                .results[index].deliveryTotal,
                                          ),
                                        ),
                                      ),
                                    },
                                  );
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderNumber(
                                      snapshot.data.results[index],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              margin:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, top: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "№" +
                                              snapshot.data.results[index].id
                                                  .toString(),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRoboto,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            fontStyle: FontStyle.normal,
                                            color: AppTheme.black_text,
                                          ),
                                        )),
                                        Text(
                                          translate("history.all"),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRoboto,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            height: 1.71,
                                            fontStyle: FontStyle.normal,
                                            color: AppTheme.blue,
                                          ),
                                        ),
                                        Container(
                                          height: 24,
                                          width: 18,
                                          margin: EdgeInsets.only(top: 3),
                                          padding: EdgeInsets.all(1),
                                          child: SvgPicture.asset(
                                            "assets/images/icon_arrow_blue.svg",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: AppTheme.black_linear_category,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, top: 17),
                                  ),
                                  Container(
                                    height: 25,
                                    margin: EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data.results[index].type ==
                                                  "self"
                                              ? translate("history.somviz")
                                              : translate("history.dostavka"),
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontRoboto,
                                            color: AppTheme.black_text,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            color: colorStatus(snapshot
                                                    .data.results[index].status)
                                                .withOpacity(0.15),
                                          ),
                                          padding: EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 12,
                                            right: 12,
                                          ),
                                          child: Center(
                                            child: Text(
                                              translate(
                                                  "history.${snapshot.data.results[index].status}"),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRoboto,
                                                fontWeight: FontWeight.w600,
                                                fontSize: snapshot
                                                            .data
                                                            .results[index]
                                                            .status ==
                                                        "waiting_deliverer"
                                                    ? 7
                                                    : 11,
                                                color: colorStatus(snapshot.data
                                                    .results[index].status),
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  snapshot.data.results[index].type ==
                                          "shipping"
                                      ? snapshot.data.results[index].delivery ==
                                              null
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  left: 16, right: 16, top: 16),
                                              child: Text(
                                                translate("history.courier") +
                                                    ": " +
                                                    snapshot.data.results[index]
                                                        .delivery.firstName +
                                                    " " +
                                                    snapshot.data.results[index]
                                                        .delivery.lastName,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.normal,
                                                  color: AppTheme.black_text,
                                                ),
                                              ),
                                            )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16, top: 16),
                                          child: Text(
                                            snapshot
                                                .data.results[index].store.name,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              fontStyle: FontStyle.normal,
                                              color: AppTheme.black_text,
                                            ),
                                          ),
                                        ),
                                  snapshot.data.results[index].type ==
                                          "shipping"
                                      ? snapshot.data.results[index].delivery ==
                                              null
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () async {
                                                var url = "tel:" +
                                                    snapshot.data.results[index]
                                                        .delivery.login;
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 4,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      translate(
                                                              "zakaz.number") +
                                                          ": ",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTheme.fontRoboto,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color:
                                                            AppTheme.black_text,
                                                      ),
                                                    ),
                                                    Text(
                                                      Utils.numberFormat(
                                                        snapshot
                                                            .data
                                                            .results[index]
                                                            .delivery
                                                            .login,
                                                      ),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTheme.fontRoboto,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: AppTheme.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                      : GestureDetector(
                                          onTap: () async {
                                            var url = "tel:" +
                                                snapshot.data.results[index]
                                                    .store.phone
                                                    .replaceAll(" ", "")
                                                    .replaceAll("-", "")
                                                    .replaceAll("(", "")
                                                    .replaceAll(")", "");
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 16, right: 16, top: 4),
                                            child: Row(
                                              children: [
                                                Text(
                                                  translate("zakaz.number") +
                                                      ": ",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13,
                                                    fontStyle: FontStyle.normal,
                                                    color: AppTheme.black_text,
                                                  ),
                                                ),
                                                Text(
                                                  Utils.numberFormat(
                                                    snapshot.data.results[index]
                                                        .store.phone
                                                        .replaceAll(" ", "")
                                                        .replaceAll("-", "")
                                                        .replaceAll("+", "")
                                                        .replaceAll("(", "")
                                                        .replaceAll(")", ""),
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13,
                                                    fontStyle: FontStyle.normal,
                                                    color: AppTheme.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, top: 4),
                                    child: Text(
                                      translate("history.price") +
                                          " " +
                                          priceFormat.format(snapshot
                                                  .data.results[index].total +
                                              snapshot.data.results[index]
                                                  .deliveryTotal) +
                                          translate("sum"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRoboto,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        fontStyle: FontStyle.normal,
                                        color: AppTheme.black_transparent_text,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 16, bottom: 16),
                                    height: 56,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                        top: 0,
                                        bottom: 0,
                                        right: 16,
                                        left: 16,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot
                                          .data.results[index].items.length,
                                      itemBuilder:
                                          (BuildContext context, int subindex) {
                                        return Container(
                                          width: 56,
                                          height: 56,
                                          margin: EdgeInsets.only(right: 16),
                                          child: Container(
                                            width: 56,
                                            height: 56,
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data
                                                  .results[index]
                                                  .items[subindex]
                                                  .drug
                                                  .imageThumbnail,
                                              placeholder: (context, url) =>
                                                  Container(
                                                padding: EdgeInsets.all(5),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                      "assets/images/place_holder.svg"),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                padding: EdgeInsets.all(5),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                      "assets/images/place_holder.svg"),
                                                ),
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
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
                        Container(
                          height: 153,
                          width: 153,
                          child: SvgPicture.asset(
                              "assets/images/empty_history.svg"),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25, left: 16, right: 16),
                          alignment: Alignment.center,
                          child: Text(
                            translate("menu_sub.history_title"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_text,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                          child: Text(
                            translate("menu_sub.history_message"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_transparent_text,
                            ),
                          ),
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    height: 260,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Null> _refreshRegion() async {
    isLoading = false;
    pageHistory = 1;
    _getMoreData(1);
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        blocHistory.fetchAllHistory(index);
        pageHistory++;
      });
    }
  }

  Color colorStatus(String status) {
    switch (status) {
      case "pending":
        {
          return Color(0xFF0A6CFF);
        }
      case "accept":
        {
          return Color(0xFF3F8AE0);
        }
      case "cancelled_by_store":
        {
          return Color(0xFF5F4B18);
        }
      case "waiting_deliverer":
        {
          return Color(0xFFEDCC57);
        }
      case "delivering":
        {
          return Color(0xFFE4E75B);
        }
      case "delivered":
        {
          return Color(0xFF4BB34B);
        }
      case "cancelled_by_admin":
        {
          return Color(0xFF818C99);
        }
      case "pick_up":
        {
          return Color(0xFF00B0DC);
        }
      case "picked_up":
        {
          return Color(0xFF4BB34B);
        }
      case "payment_waiting":
        {
          return Color(0xFFF94FB5);
        }
      case "cancelled_by_user":
        {
          return Color(0xFF1C1C1E);
        }
      case "not_paid":
        {
          return Color(0xFF1C1C1E);
        }

      default:
        {
          return Color(0xFF4CAF50);
        }
    }
  }
}
