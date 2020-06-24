import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: ListView(
        children: <Widget>[
          Container(
            width: size.width,
            child: Image.asset(
              "assets/images/menu_image.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.only(
              left: 16,
              top: 24,
              right: 16,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "Shahboz Turonov",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black_text,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              translate("menu.all_info"),
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
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 19,
                        color: AppTheme.arrow_catalog,
                      ),
                      SizedBox(width: 3),
                    ],
                  ),
                  height: 48,
                  color: AppTheme.white,
                ),
                Container(
                  height: 1,
                  color: AppTheme.black_linear_category,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: SvgPicture.asset("assets/images/bonus_card.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.bonus_card"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                    color: AppTheme.arrow_catalog,
                  ),
                  SizedBox(width: 3),
                ],
              ),
              height: 48,
              color: AppTheme.white,
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: SvgPicture.asset("assets/images/city.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.city"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "Ташкент",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: AppTheme.fontRoboto,
                      color: AppTheme.black_transparent_text,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                    color: AppTheme.arrow_catalog,
                  ),
                  SizedBox(width: 3),
                ],
              ),
              height: 48,
              color: AppTheme.white,
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: SvgPicture.asset("assets/images/address_apt.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.address_apteka"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                    color: AppTheme.arrow_catalog,
                  ),
                  SizedBox(width: 3),
                ],
              ),
              height: 48,
              color: AppTheme.white,
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: SvgPicture.asset("assets/images/history.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.history"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                    color: AppTheme.arrow_catalog,
                  ),
                  SizedBox(width: 3),
                ],
              ),
              height: 48,
              color: AppTheme.white,
            ),
          ),
          GestureDetector(
            onTap: () async {
              var localizationDelegate = LocalizedApp.of(context).delegate;
              localizationDelegate.changeLocale(Locale("en_US"));
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', 'en_US');
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          translate("language.en"),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.blue_app_color,
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                  height: 48,
                  color: AppTheme.white,
                ),
                Container(
                  height: 1,
                  color: Colors.black12,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var localizationDelegate = LocalizedApp.of(context).delegate;
              localizationDelegate.changeLocale(Locale("ru"));
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', 'ru');
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          translate("language.ru"),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.blue_app_color,
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                  height: 48,
                  color: AppTheme.white,
                ),
                Container(
                  height: 1,
                  color: Colors.black12,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var localizationDelegate = LocalizedApp.of(context).delegate;
              localizationDelegate.changeLocale(Locale("uz"));
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', 'uz');
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          translate("language.uz"),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.blue_app_color,
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                  height: 48,
                  color: AppTheme.white,
                ),
                Container(
                  height: 1,
                  color: Colors.black12,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
