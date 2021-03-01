import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/history_bloc.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

class OrderNumber extends StatefulWidget {
  final HistoryResults item;

  OrderNumber(this.item);

  @override
  State<StatefulWidget> createState() {
    return _OrderNumberState();
  }
}

class _OrderNumberState extends State<OrderNumber> {
  bool isLoading = false;
  bool isCancel = false;
  bool one = false, two = false, three = false, four = false;

  double size = 24;
  var durationTime = Duration(
    milliseconds: 1000,
  );
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(durationTime, (timer) {
      setState(() {
        if (size == 24)
          size = 12;
        else
          size = 24;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isCancel) {
      Repository().fetchCancelOrder(widget.item.id).then(
            (value) => {
              setState(() {
                isLoading = false;
                widget.item.status = "cancelled_by_user";
              }),
              blocHistory.fetchAllHistory(1),
              pageHistory = 2,
              if (value.payment == "Onlayn")
                {
                  BottomDialog.historyCancelOrder(context),
                }
            },
          );
      isCancel = false;
    }
    if (widget.item.status == "payment_waiting" ||
        widget.item.status == "pending") {
      one = true;
    } else if (widget.item.status == "accept") {
      one = true;
      two = true;
    } else if (widget.item.status == "pick_up" ||
        widget.item.status == "waiting_deliverer" ||
        widget.item.status == "delivering") {
      one = true;
      two = true;
      three = true;
    } else if (widget.item.status == "delivered" ||
        widget.item.status == "picked_up") {
      one = true;
      two = true;
      three = true;
      four = true;
    }
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
              "№" + widget.item.id.toString(),
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
      body: ListView(
        children: [
          widget.item.status == "not_paid" ||
                  widget.item.status == "cancelled_by_store" ||
                  widget.item.status == "cancelled_by_admin" ||
                  widget.item.status == "cancelled_by_user"
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 24,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                        ),
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          translate("history.status"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 1.2,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      widget.item.status == "payment_waiting" ||
                              widget.item.status == "pending"
                          ? Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 18, right: 16),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(child: Container()),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 11),
                                              width: 2,
                                              height: 12,
                                              color: Color(0xFFEBEDF0),
                                            ),
                                            Center(
                                              child: AnimatedContainer(
                                                duration: durationTime,
                                                height: size,
                                                width: size,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: Color(0xFFEBEDF0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    translate("history.status_pending"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppTheme.blue,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 24, right: 16),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(child: Container()),
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          color: AppTheme.blue,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    translate("history.status_pending"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppTheme.black_text,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      widget.item.status == "accept"
                          ? Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 18, right: 16),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 11),
                                              width: 2,
                                              height: 12,
                                              color: AppTheme.blue,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 11),
                                              width: 2,
                                              height: 12,
                                              color: Color(0xFFEBEDF0),
                                            ),
                                            Center(
                                              child: AnimatedContainer(
                                                duration: durationTime,
                                                height: size,
                                                width: size,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: Color(0xFFEBEDF0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    translate("history.status_accept"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppTheme.blue,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: two
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                        ),
                                      ),
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          color: two
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: three
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    translate("history.status_accept"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppTheme.black_text,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      widget.item.status == "pick_up" ||
                              widget.item.status == "waiting_deliverer" ||
                              widget.item.status == "delivering"
                          ? Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 18, right: 16),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 11),
                                              width: 2,
                                              height: 12,
                                              color: AppTheme.blue,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 11),
                                              width: 2,
                                              height: 12,
                                              color: Color(0xFFEBEDF0),
                                            ),
                                            Center(
                                              child: AnimatedContainer(
                                                duration: durationTime,
                                                height: size,
                                                width: size,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: Color(0xFFEBEDF0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.item.type == "self"
                                        ? translate("history.status_packed")
                                        : translate("history.status_way"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppTheme.blue,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: three
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                        ),
                                      ),
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          color: three
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: three
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    widget.item.type == "self"
                                        ? translate("history.status_packed")
                                        : translate("history.status_way"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppTheme.black_text,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      widget.item.status == "delivered" ||
                              widget.item.status == "picked_up"
                          ? Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 18, right: 16),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 11),
                                              width: 2,
                                              height: 12,
                                              color: AppTheme.blue,
                                            ),
                                            Center(
                                              child: AnimatedContainer(
                                                duration: durationTime,
                                                height: size,
                                                width: size,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.item.type == "self"
                                        ? translate("history.status_received")
                                        : translate("history.status_delivered"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppTheme.blue,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 44,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: four
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                        ),
                                      ),
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          color: four
                                              ? AppTheme.blue
                                              : Color(0xFFEBEDF0),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    widget.item.type == "self"
                                        ? translate("history.status_received")
                                        : translate("history.status_delivered"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppTheme.black_text,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      GestureDetector(
                        onTap: () {
                          if (three || four) {
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      height: 450,
                                      padding: EdgeInsets.only(
                                          bottom: 24, left: 8, right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          color: AppTheme.white,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 12, bottom: 16),
                                              height: 4,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: AppTheme.bottom_dialog,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 153,
                                                width: 153,
                                                child: SvgPicture.asset(
                                                    "assets/images/order_is_cancel.svg"),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 8, left: 16, right: 16),
                                              child: Center(
                                                child: Text(
                                                  translate(
                                                      "history.order_cancel"),
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    height: 1.65,
                                                    color: AppTheme.black_text,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 8, left: 32, right: 32),
                                              child: Center(
                                                child: Text(
                                                  translate(
                                                      "history.cancel_bottom_text"),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.6,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    color: AppTheme
                                                        .black_transparent_text,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  isLoading = true;
                                                  isCancel = true;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  border: Border.all(
                                                    color: AppTheme.blue,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                height: 44,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Text(
                                                    translate("history.yes"),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRoboto,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 17,
                                                      height: 1.3,
                                                      color: AppTheme.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 20,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppTheme.blue_app_color,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                height: 44,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Text(
                                                    translate("history.no"),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRoboto,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 17,
                                                      height: 1.3,
                                                      color: AppTheme.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          height: 44,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            top: 2,
                            left: 24,
                            right: 24,
                            bottom: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: three || four
                                ? Color.fromRGBO(129, 140, 153, 0.15)
                                : AppTheme.red_fav_color,
                          ),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(
                                    value: null,
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.white),
                                  )
                                : Text(
                                    three || four
                                        ? translate("history.order_not_cancel")
                                        : translate("history.order_cancel"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: three || four
                                          ? AppTheme.search_empty
                                          : AppTheme.white,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          Container(
            margin: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Text(
              translate("zakaz.poluchatel"),
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: AppTheme.black_text,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: Text(
              translate("zakaz.name"),
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontStyle: FontStyle.normal,
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: AppTheme.black_transparent_text,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 3),
            child: Text(
              widget.item.fullName,
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 23),
            child: Text(
              translate("zakaz.number"),
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontStyle: FontStyle.normal,
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: AppTheme.black_transparent_text,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 3),
            child: Text(
              Utils.numberFormat(widget.item.phone),
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          widget.item.delivery == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                    top: 43,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    translate("history.courier"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black_text,
                    ),
                  ),
                ),
          widget.item.delivery == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  child: Text(
                    translate("zakaz.name"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_transparent_text,
                    ),
                  ),
                ),
          widget.item.delivery == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 3),
                  child: Text(
                    widget.item.delivery.firstName +
                        " " +
                        widget.item.delivery.lastName,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
          widget.item.delivery == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 23),
                  child: Text(
                    translate("zakaz.number"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_transparent_text,
                    ),
                  ),
                ),
          widget.item.delivery == null
              ? Container()
              : GestureDetector(
                  onTap: () async {
                    var url = "tel:" + widget.item.delivery.login;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 3),
                    child: Text(
                      Utils.numberFormat(widget.item.delivery.login),
                      style: TextStyle(
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  )),
          Container(
            height: 36,
            margin: EdgeInsets.only(left: 16, right: 16, top: 43),
            child: Row(
              children: [
                Text(
                  translate("zakaz.oplat"),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontFamily: AppTheme.fontRoboto,
                    color: AppTheme.black_text,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                widget.item.paymentType.type == "cash"
                    ? Text(
                        translate("history.payment_type"),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRoboto,
                          color: AppTheme.black_text,
                        ),
                      )
                    : Container(),
                widget.item.paymentType.type != "cash" &&
                        widget.item.status != "not_paid"
                    ? widget.item.status == "payment_waiting"
                        ? SvgPicture.asset("assets/images/check_error.svg")
                        : SvgPicture.asset("assets/images/check.svg")
                    : Container(),
                widget.item.paymentType.type != "cash"
                    ? SizedBox(
                        width: 8,
                      )
                    : Container(),
                widget.item.paymentType.type != "cash" &&
                        widget.item.status != "not_paid"
                    ? Text(
                        widget.item.status == "payment_waiting"
                            ? translate("zakaz.not_paymment")
                            : translate("zakaz.oplachen"),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRoboto,
                          color: AppTheme.black_text,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          widget.item.type == "shipping"
              ? Container(
                  margin: EdgeInsets.only(
                    top: 26,
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
                        priceFormat.format(widget.item.total) +
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
                )
              : Container(),
          widget.item.type == "shipping"
              ? Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        translate("card.dostavka"),
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
                        widget.item.deliveryTotal != 0
                            ? priceFormat.format(widget.item.deliveryTotal) +
                                translate(translate("sum"))
                            : translate("free"),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
              top: 12,
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
                  priceFormat.format(
                          widget.item.total + widget.item.deliveryTotal) +
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.only(
              right: 16,
              top: 24,
              left: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: AppTheme.white,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    height: 25,
                    margin: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          widget.item.type == "self"
                              ? translate("history.somviz")
                              : translate("history.dostavka"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black_text,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorStatus(widget.item.status)
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
                              translate("history.${widget.item.status}"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    widget.item.status == "waiting_deliverer"
                                        ? 7
                                        : 11,
                                color: colorStatus(widget.item.status),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.item.type != "self"
                      ? Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            widget.item.type != "self"
                                ? translate("zakaz.address")
                                : translate("zakaz.order"),
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontRoboto,
                              color: AppTheme.black_text,
                            ),
                          ),
                        )
                      : Container(),
                  widget.item.type != "self"
                      ? Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 2),
                          child: Text(
                            widget.item.address,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRoboto,
                              color: AppTheme.black_text,
                            ),
                            maxLines: 2,
                          ),
                        )
                      : Container(),
                  Container(
                    height: 1,
                    color: AppTheme.black_linear_category,
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 12.5, bottom: 12.5),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: widget.item.items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 68,
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 6, bottom: 6),
                        color: AppTheme.white,
                        child: Row(
                          children: [
                            Container(
                              height: 56,
                              width: 56,
                              child: CachedNetworkImage(
                                height: 112,
                                width: 112,
                                imageUrl: widget
                                    .item.items[index].drug.imageThumbnail,
                                placeholder: (context, url) => Container(
                                  padding: EdgeInsets.all(25),
                                  child: Center(
                                    child: SvgPicture.asset(
                                        "assets/images/place_holder.svg"),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  padding: EdgeInsets.all(25),
                                  child: Center(
                                    child: SvgPicture.asset(
                                        "assets/images/place_holder.svg"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 7, bottom: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.item.items[index].drug.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11,
                                          fontStyle: FontStyle.normal,
                                          color: AppTheme.black_text,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          priceFormat.format(widget
                                                  .item.items[index].price) +
                                              translate("sum"),
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontRoboto,
                                            color: AppTheme.black_text,
                                          ),
                                        ),
                                        Text(
                                          " x " +
                                              priceFormat.format(
                                                  widget.item.items[index].qty),
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontRoboto,
                                            color:
                                                AppTheme.black_transparent_text,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          widget.item.type == "self"
              ? Container(
                  height: 220,
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
                  margin: EdgeInsets.only(
                    right: 16,
                    top: 24,
                    left: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                        width: double.infinity,
                        child: Text(
                          widget.item.store.name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                        width: double.infinity,
                        child: Text(
                          widget.item.store.address,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 17),
                        child: Row(
                          children: [
                            Text(
                              translate("map.work") + " : ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Text(
                                widget.item.store.mode,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Row(
                          children: [
                            Text(
                              translate("auth.number_auth") + " : ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  var url = "tel:" +
                                      widget.item.store.phone
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
                                child: Text(
                                  Utils.numberFormat(
                                    widget.item.store.phone
                                        .replaceAll(" ", "")
                                        .replaceAll("+", "")
                                        .replaceAll("-", "")
                                        .replaceAll("(", "")
                                        .replaceAll(")", ""),
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.blue_app_color,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              var pharmacyLat =
                                  widget.item.store.location.coordinates[1];
                              var pharmacyLng =
                                  widget.item.store.location.coordinates[0];
                              String googleUrl =
                                  'https://maps.google.com/?daddr=$pharmacyLat,$pharmacyLng';
                              if (await canLaunch(googleUrl)) {
                                await launch(googleUrl);
                              } else {
                                throw 'Could not launch $googleUrl';
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                color: AppTheme.blue_app_color,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  translate("map.maps"),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppTheme.white,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
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
      default:
        {
          return Color(0xFF4CAF50);
        }
    }
  }
}
