import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_theme.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  Size size;
  String language = "";
  bool isLogin = false;

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: ListView(
        children: <Widget>[
          isLogin
              ? Container(
                  width: size.width,
                  child: Image.asset(
                    "assets/images/menu_image.png",
                    fit: BoxFit.fitWidth,
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 26, left: 12, right: 12,bottom: 30),
                  height: 146,
                  decoration: BoxDecoration(
                    color: AppTheme.blue_app_color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
          isLogin
              ? Container(
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
                )
              : Container(),
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
//          GestureDetector(
//            onTap: () async {},
//            child: Container(
//              margin: EdgeInsets.only(
//                left: 16,
//                right: 16,
//              ),
//              child: Row(
//                children: <Widget>[
//                  Container(
//                    height: 25,
//                    width: 25,
//                    child: Center(
//                      child: SvgPicture.asset("assets/images/address_apt.svg"),
//                    ),
//                  ),
//                  SizedBox(width: 15),
//                  Expanded(
//                    child: Text(
//                      translate("menu.address_apteka"),
//                      style: TextStyle(
//                        fontWeight: FontWeight.normal,
//                        fontFamily: AppTheme.fontRoboto,
//                        color: AppTheme.black_text,
//                        fontSize: 15,
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: 15,
//                  ),
//                  Icon(
//                    Icons.arrow_forward_ios,
//                    size: 19,
//                    color: AppTheme.arrow_catalog,
//                  ),
//                  SizedBox(width: 3),
//                ],
//              ),
//              height: 48,
//              color: AppTheme.white,
//            ),
//          ),
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
              //BottomDialog.onActionSheetPress(context);
              getLanguage();
            },
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
                      child: SvgPicture.asset("assets/images/language.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.language"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    language,
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
                      child: SvgPicture.asset("assets/images/about.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.about"),
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
//          Container(
//            height: 1,
//            margin: EdgeInsets.only(left: 16, right: 16, top: 13),
//            color: AppTheme.black_linear_category,
//          ),
//          Container(
//            height: 120,
//            margin: EdgeInsets.only(left: 16, right: 16),
//            child: Row(
//              children: [
//                GestureDetector(
//                  child: Container(
//                    height: 120,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        SvgPicture.asset("assets/images/message.svg"),
//                        SizedBox(
//                          height: 14.12,
//                        ),
//                        Text(
//                          translate("menu.message"),
//                          style: TextStyle(
//                            fontSize: 13,
//                            fontFamily: AppTheme.fontRoboto,
//                            fontWeight: FontWeight.normal,
//                            color: Colors.black,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 3,
//                        ),
//                        Text(
//                          translate("menu.message_about"),
//                          style: TextStyle(
//                            fontSize: 10,
//                            fontFamily: AppTheme.fontRoboto,
//                            fontWeight: FontWeight.normal,
//                            color: AppTheme.black_transparent_text,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  onTap: () {},
//                ),
//                Expanded(
//                  child: Container(),
//                ),
//                GestureDetector(
//                  child: Container(
//                    height: 120,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        SvgPicture.asset("assets/images/call.svg"),
//                        SizedBox(
//                          height: 14.12,
//                        ),
//                        Text(
//                          translate("menu.call"),
//                          style: TextStyle(
//                            fontSize: 13,
//                            fontFamily: AppTheme.fontRoboto,
//                            fontWeight: FontWeight.normal,
//                            color: Colors.black,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 3,
//                        ),
//                        Text(
//                          translate("menu.call_about"),
//                          style: TextStyle(
//                            fontSize: 10,
//                            fontFamily: AppTheme.fontRoboto,
//                            fontWeight: FontWeight.normal,
//                            color: AppTheme.black_transparent_text,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  onTap: () {},
//                ),
//                Expanded(
//                  child: Container(),
//                ),
//                GestureDetector(
//                  child: Container(
//                    height: 120,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        SvgPicture.asset("assets/images/faq.svg"),
//                        SizedBox(
//                          height: 14.12,
//                        ),
//                        Text(
//                          translate("menu.faq"),
//                          style: TextStyle(
//                            fontSize: 13,
//                            fontFamily: AppTheme.fontRoboto,
//                            fontWeight: FontWeight.normal,
//                            color: Colors.black,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 3,
//                        ),
//                        Text(
//                          translate("menu.faq_about"),
//                          style: TextStyle(
//                            fontSize: 10,
//                            fontFamily: AppTheme.fontRoboto,
//                            fontWeight: FontWeight.normal,
//                            color: AppTheme.black_transparent_text,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  onTap: () {},
//                ),
//              ],
//            ),
//          )
        ],
      ),
    );
  }

  Future<void> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('language').toString() + "language");
    if (prefs.getString('language') != null) {
      if (prefs.getString('language') == "ru")
        language = translate("language.ru");
      else if (prefs.getString('language') == "uz")
        language = translate("language.uz");
      else if (prefs.getString('language') == "en_US")
        language = translate("language.en");
    } else {
      language = translate("language.en");
    }
  }
}
