import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
                widget.item.paymentType.type != "cash"
                    ? widget.item.status == "payment_waiting"
                        ? SvgPicture.asset("assets/images/check_error.svg")
                        : SvgPicture.asset("assets/images/check.svg")
                    : Container(),
                widget.item.paymentType.type != "cash"
                    ? SizedBox(
                        width: 8,
                      )
                    : Container(),
                widget.item.paymentType.type != "cash"
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: ColorStatus(widget.item.status),
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
                                color: AppTheme.black_text,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.item.type != "self"?  Container(
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
                  ):Container(),
                  widget.item.type != "self"?Container(
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
                  ):Container(),
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
                              child: Text(
                                widget.item.store.phone,
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

                              if (lat == 41.311081 && lng == 69.240562) {
                                Position position = await Geolocator()
                                    .getCurrentPosition(
                                        desiredAccuracy:
                                            LocationAccuracy.bestForNavigation);
                                if (position.latitude != null &&
                                    position.longitude != null) {
                                  lat = position.latitude;
                                  lng = position.longitude;
                                  var url =
                                      'http://maps.google.com/maps?saddr=$lat,$lng&daddr=$pharmacyLat,$pharmacyLng';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                }
                              } else {
                                var url =
                                    'http://maps.google.com/maps?saddr=$lat,$lng&daddr=$pharmacyLat,$pharmacyLng';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
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

  Color ColorStatus(String status) {
    switch (status) {
      case "pending":
        {
          return Colors.yellow;
        }
      case "accept":
        {
          return Color(0xFF43A047);
        }
      case "cancelled_by_store":
        {
          return Color(0xFFE53935);
        }
      case "waiting_deliverer":
        {
          return Color(0xFF0288D1);
        }
      case "delivering":
        {
          return Color(0xFF0288D1);
        }
      case "delivered":
        {
          return Colors.green;
        }
      case "cancelled_by_admin":
        {
          return Color(0xFF616161);
        }
      case "pick_up":
        {
          return Color(0xFFB39DDB);
        }
      case "picked_up":
        {
          return Color(0xFF4CAF50);
        }
      case "payment_waiting":
        {
          return Colors.pink;
        }
      default:
        {
          return Color(0xFF4CAF50);
        }
    }
  }
}
