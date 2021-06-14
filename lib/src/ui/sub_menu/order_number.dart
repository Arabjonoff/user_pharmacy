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
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
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
  var type = 1;

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
      type = 1;
    } else if (widget.item.status == "accept") {
      type = 2;
    } else if (widget.item.status == "pick_up" ||
        widget.item.status == "waiting_deliverer" ||
        widget.item.status == "delivering") {
      type = 3;
    } else if (widget.item.status == "delivered" ||
        widget.item.status == "picked_up") {
      type = 4;
    }
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
              translate("history.order") + widget.item.id.toString(),
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
          Expanded(
            child: ListView(
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
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(16),
                              child: Text(
                                translate("history.status"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.2,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: AppTheme.background,
                            ),
                            Container(
                              height: 24,
                              margin: EdgeInsets.only(
                                top: 16,
                                left: 19,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: type == 1
                                          ? AppTheme.blue
                                          : AppTheme.textGray,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/check.svg",
                                        width: 8,
                                        height: 6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 19),
                                  Expanded(
                                    child: Text(
                                      translate("history.status_pending"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        height: 1.2,
                                        color: type == 1
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 24,
                              margin: EdgeInsets.only(
                                top: 16,
                                left: 19,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: type < 2
                                          ? AppTheme.white
                                          : type == 2
                                              ? AppTheme.blue
                                              : AppTheme.textGray,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1.5,
                                        color: type == 2
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/check.svg",
                                        width: 8,
                                        height: 6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 19),
                                  Expanded(
                                    child: Text(
                                      translate("history.status_accept"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        height: 1.2,
                                        color: type == 2
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 24,
                              margin: EdgeInsets.only(
                                top: 16,
                                left: 19,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: type < 3
                                          ? AppTheme.white
                                          : type == 3
                                              ? AppTheme.blue
                                              : AppTheme.textGray,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1.5,
                                        color: type == 3
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/check.svg",
                                        width: 8,
                                        height: 6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 19),
                                  Expanded(
                                    child: Text(
                                      widget.item.type == "self"
                                          ? translate("history.status_packed")
                                          : translate("history.status_way"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        height: 1.2,
                                        color: type == 3
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 24,
                              margin: EdgeInsets.only(
                                top: 16,
                                left: 19,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: type < 4
                                          ? AppTheme.white
                                          : type == 4
                                              ? AppTheme.blue
                                              : AppTheme.textGray,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1.5,
                                        color: type == 4
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/check.svg",
                                        width: 8,
                                        height: 6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 19),
                                  Expanded(
                                    child: Text(
                                      widget.item.type == "self"
                                          ? translate("history.status_received")
                                          : translate(
                                              "history.status_delivered"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        height: 1.2,
                                        color: type == 4
                                            ? AppTheme.blue
                                            : AppTheme.textGray,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              color: AppTheme.background,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (type < 3) {
                                  BottomDialog.showCancelOrder(
                                    context,
                                    widget.item.id,
                                    () {},
                                  );
                                }
                              },
                              child: Container(
                                height: 44,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      type > 2 ? AppTheme.gray : AppTheme.red,
                                ),
                                child: Center(
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          value: null,
                                          strokeWidth: 3.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppTheme.white),
                                        )
                                      : Text(
                                          type > 2
                                              ? translate(
                                                  "history.order_not_cancel")
                                              : translate(
                                                  "history.order_cancel"),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRubik,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: AppTheme.white,
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
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Text(
                          translate("history.user"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.background,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          translate("history.user_name"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
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
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Text(
                          widget.item.fullName,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          translate("history.user_number"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
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
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Text(
                          Utils.numberFormat(widget.item.phone),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          translate("history.user_address"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
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
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Text(
                          widget.item.address,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        color: AppTheme.background,
                      ),
                      //widget.item.type == "self"
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          widget.item.type == "self"
                              ? translate("history.store")
                              : translate("history.courier"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          widget.item.type == "self"
                              ? translate("history.store_name")
                              : translate("history.user_name"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
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
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Text(
                          widget.item.type == "self"
                              ? widget.item.store.name
                              : widget.item.delivery.firstName +
                                  " " +
                                  widget.item.delivery.lastName,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          translate("history.user_number"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
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
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Text(
                          widget.item.type == "self"
                              ? Utils.numberFormat(widget.item.store.phone)
                              : Utils.numberFormat(widget.item.delivery.login),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      widget.item.type == "self"
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                              ),
                              child: Text(
                                translate("history.store_address"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.2,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            )
                          : Container(),
                      widget.item.type == "self"
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 8,
                                left: 16,
                                right: 16,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              child: Text(
                                widget.item.store.address,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.2,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Text(
                          translate("history.item_count") +
                              widget.item.items.length.toString(),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: widget.item.items.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: AppTheme.background,
                                margin: EdgeInsets.only(bottom: 16),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 8),
                                  CachedNetworkImage(
                                    height: 80,
                                    width: 80,
                                    imageUrl: widget
                                        .item.items[index].drug.imageThumbnail,
                                    placeholder: (context, url) => Container(
                                      padding: EdgeInsets.all(13),
                                      child: Center(
                                        child: SvgPicture.asset(
                                            "assets/images/place_holder.svg"),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      padding: EdgeInsets.all(13),
                                      child: Center(
                                        child: SvgPicture.asset(
                                            "assets/images/place_holder.svg"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.item.items[index].drug.name,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRubik,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            height: 1.5,
                                            color: AppTheme.text_dark,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              translate("lan") == "1"
                                                  ? TextSpan(
                                                      text: translate("from"),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTheme.fontRubik,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        height: 1.2,
                                                        color:
                                                            AppTheme.text_dark,
                                                      ),
                                                    )
                                                  : WidgetSpan(
                                                      child: SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                                    ),
                                              TextSpan(
                                                text: priceFormat.format(widget
                                                        .item
                                                        .items[index]
                                                        .price) +
                                                    translate("sum"),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  height: 1.2,
                                                  color: AppTheme.text_dark,
                                                ),
                                              ),
                                              translate("lan") != "1"
                                                  ? TextSpan(
                                                      text: translate("from"),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTheme.fontRubik,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        height: 1.2,
                                                        color:
                                                            AppTheme.text_dark,
                                                      ),
                                                    )
                                                  : WidgetSpan(
                                                      child: SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                                    ),
                                              TextSpan(
                                                text: " x " +
                                                    widget.item.items[index].qty
                                                        .toString(),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  height: 1.2,
                                                  color: AppTheme.textGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        },
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
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              translate("history.payment"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 1.2,
                                color: AppTheme.text_dark,
                              ),
                            ),
                            Expanded(child: Container()),
                            widget.item.status == "not_paid" ||
                                    widget.item.status ==
                                        "cancelled_by_store" ||
                                    widget.item.status == "cancelled_by_user" ||
                                    widget.item.status == "cancelled_by_admin"
                                ? Container()
                                : widget.item.paymentType.type != "cash"
                                    ? Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.blue.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          translate("history.pay"),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRubik,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            height: 1.2,
                                            color: AppTheme.blue,
                                          ),
                                        ),
                                      )
                                    : widget.item.status == "payment_waiting"
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppTheme.text_dark
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              translate("history.pay"),
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                height: 1.2,
                                                color: AppTheme.text_dark,
                                              ),
                                            ),
                                          ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.background,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Text(
                            translate("history.payment_type"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.textGray,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            widget.item.paymentType.type == "online"
                                ? translate("history.online")
                                : translate("history.cash"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.text_dark,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Text(
                            translate("history.price"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.textGray,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            priceFormat.format(widget.item.total) +
                                translate("sum"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.text_dark,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      widget.item.type != "self"
                          ? SizedBox(height: 16)
                          : Container(),
                      widget.item.type != "self"
                          ? Row(
                              children: [
                                SizedBox(width: 16),
                                Text(
                                  translate("history.price_delivery"),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.2,
                                    color: AppTheme.textGray,
                                  ),
                                ),
                                Expanded(child: Container()),
                                Text(
                                  widget.item.deliveryTotal != 0.0
                                      ? priceFormat.format(
                                              widget.item.deliveryTotal) +
                                          translate(translate("sum"))
                                      : translate("free"),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.2,
                                    color: AppTheme.text_dark,
                                  ),
                                ),
                                SizedBox(width: 16),
                              ],
                            )
                          : Container(),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        color: AppTheme.background,
                        width: double.infinity,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Text(
                            translate("history.all_price"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.textGray,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            priceFormat.format(widget.item.total +
                                    widget.item.deliveryTotal) +
                                translate("sum"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.text_dark,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 12,
              left: 22,
              right: 22,
              bottom: 24,
            ),
            color: AppTheme.white,
            child: GestureDetector(
              onTap: () async {
                if (widget.item.type == "self") {
                  var pharmacyLat = widget.item.store.location.coordinates[1];
                  var pharmacyLng = widget.item.store.location.coordinates[0];
                  String googleUrl =
                      'https://maps.google.com/?daddr=$pharmacyLat,$pharmacyLng';
                  if (await canLaunch(googleUrl)) {
                    await launch(googleUrl);
                  } else {
                    throw 'Could not launch $googleUrl';
                  }
                } else {
                  var url = "tel:" +
                      widget.item.delivery.login
                          .replaceAll("+", "")
                          .replaceAll(" ", "")
                          .replaceAll("-", "")
                          .replaceAll(")", "")
                          .replaceAll("(", "");
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.item.type == "self"
                        ? translate("history.direct")
                        : translate("history.call_curer"),
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
          )
        ],
      ),
    );
  }

  Color colorStatus(String status) {
    switch (status) {
      case "pending":
        {
          return AppTheme.blue;
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
