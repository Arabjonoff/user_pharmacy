import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../app_theme.dart';

class OrderNumber extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderNumberState();
  }
}

class _OrderNumberState extends State<OrderNumber> {
  @override
  Widget build(BuildContext context) {
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
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: AppTheme.blue_app_color,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Заказ №000004595",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_text,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontCommons,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "от 26 июня",
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
                ),
              ],
            ),
          ),
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
              "Shahboz Turonov",
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
              "+998 94 329 34 06",
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
                SvgPicture.asset("assets/images/check.svg"),
                SizedBox(
                  width: 8,
                ),
                Text(
                  translate("zakaz.oplachen"),
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
                  translate("5"),
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
                  "20 000" + translate(translate("sum")),
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
                  "35 000" + translate(translate("sum")),
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
                          translate("zakaz.kurer"),
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
                      translate("zakaz.address"),
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
                      translate(
                          "Ташкент, ул.Ахмад Даниш, 24, кв. 48, \nэт. 3, подъезд 2"),
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
                    itemCount: 15,
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
                                imageUrl:
                                    "http://185.183.243.77/media/drugs/7c6edcd0-c619-4bfa-8c46-a732200b0219.png",
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
                                margin: EdgeInsets.only(top: 7,bottom: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "АЙФЛОКС каплиглазные 0,3% 5 мл №30 \nблистер",
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11,
                                          fontStyle: FontStyle.normal,
                                          color: AppTheme.black_text,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "39 000"+translate("sum"),
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRoboto,
                                        color: AppTheme.black_text,
                                      ),
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
