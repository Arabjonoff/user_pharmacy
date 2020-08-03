import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';

import '../../app_theme.dart';

class OrderNumber extends StatefulWidget {
  HistoryResults item;

  OrderNumber(this.item);

  @override
  State<StatefulWidget> createState() {
    return _OrderNumberState();
  }
}

class _OrderNumberState extends State<OrderNumber> {
  bool itemClick = false;

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
            padding: EdgeInsets.all(13),
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
              "Заказ №" + widget.item.id.toString(),
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
          Container(
            margin: EdgeInsets.all(16.0),
            child: Text(
              translate("zakaz.poluchatel"),
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.black_text,
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 2),
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
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
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
            margin:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 21, bottom: 2),
            child: Text(
              widget.item.phone,
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
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
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
            height: 36,
            margin: EdgeInsets.only(left: 16, right: 16, top: 35),
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
                widget.item.status == "pending"
                    ? SvgPicture.asset("assets/images/check_error.svg")
                    : SvgPicture.asset("assets/images/check.svg"),
                SizedBox(
                  width: 8,
                ),
                Text(
                  widget.item.status == "pending"
                      ? translate("zakaz.not_paymment")
                      : translate("zakaz.oplachen"),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    fontFamily: AppTheme.fontRoboto,
                    color: AppTheme.black_text,
                  ),
                ),
              ],
            ),
          ),
          widget.item.status == "pending"
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      itemClick = true;
                    });

                    Repository()
                        .fetchOrderPayment(widget.item.id.toString())
                        .then((value) => {
                              if (value.data.card_token.length > 0)
                                {
                                  Navigator.pop(context),
                                  Navigator.pop(context),
//                                  Navigator.push(
//                                    context,
//                                    PageTransition(
//                                      type: PageTransitionType.fade,
//                                      child: ShoppingWebScreen(
//                                          value.data.return_url),
//                                    ),
//                                  )
                                }
                              else
                                {
                                  setState(() {
                                    itemClick = false;
                                  }),
                                }
                            });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 21,
                      left: 16,
                      right: 16,
                    ),
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.blue_app_color,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: itemClick
                          ? CircularProgressIndicator(
                              value: null,
                              strokeWidth: 3.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(AppTheme.white),
                            )
                          : Text(
                              translate("zakaz.reload_pay"),
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 17,
                                color: AppTheme.white,
                              ),
                            ),
                    ),
                  ),
                )
              : Container(),
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
                  priceFormat.format(widget.item.total) +
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
                          height: 22,
                          width: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.blue_app_color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Center(
                            child: Text(
                              translate("zakaz.sozdan"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
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
                  ),
                  Container(
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
                  ),
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
          )
        ],
      ),
    );
  }
}
