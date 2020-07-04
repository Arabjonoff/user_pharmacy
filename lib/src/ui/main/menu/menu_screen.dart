import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/fav_apteka_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/language_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/my_info_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/region_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
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
  String language_data = "";

  String fullName = "";
  String city = "";

//  @override
//  void initState() {
// //   getLanguage();
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    Utils.isLogin().then((value) => isLogin = value);
    size = MediaQuery.of(context).size;
    getLanguage();
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(15.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
        ),
      ),
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
                  margin: EdgeInsets.only(left: 12, right: 12, bottom: 30),
                  height: 146,
                  decoration: BoxDecoration(
                    color: AppTheme.blue_app_color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                        child: Text(
                          translate("menu.menu_about_message"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.white,
                          ),
                        ),
                        height: 51,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.downToUp,
                              child: LoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 44,
                          margin: EdgeInsets.only(left: 24, right: 24, top: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              translate("menu.enter"),
                              style: TextStyle(
                                color: AppTheme.blue_app_color,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                fontSize: 15,
                                fontFamily: AppTheme.fontRoboto,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          isLogin
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: MyInfoScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.only(
                      left: 16,
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
                                      fullName,
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
                      isLogin
                          ? translate("menu.bonus_card")
                          : translate("menu.bonus_card_not"),
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
            onTap: () async {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: RegionScreen(),
                ),
              );
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
                    city,
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
            onTap: () async {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: FavAptekaScreen(),
                ),
              );
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
          isLogin
              ? GestureDetector(
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
                            child: SvgPicture.asset(
                                "assets/images/payment_card.svg"),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            translate("menu.payment_card"),
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
                )
              : Container(),
          isLogin
              ? GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: HistoryOrderScreen(),
                      ),
                    );
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
                            child:
                                SvgPicture.asset("assets/images/history.svg"),
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
                )
              : Container(),
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: LanguageScreen(language_data),
                ),
              );
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
        ],
      ),
    );
  }

  Future<void> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString('language') != null) {
        language_data = prefs.getString('language');
        if (prefs.getString('language') == "ru")
          language = translate("language.ru");
        else if (prefs.getString('language') == "uz")
          language = translate("language.uz");
        else if (prefs.getString('language') == "en_US")
          language = translate("language.en");
      } else {
        language_data = "en_US";
        language = translate("language.en");
      }
      if (prefs.getString("city") != null) {
        city = prefs.getString("city");
      }

      var name = prefs.getString("name");
      var surName = prefs.getString("surname");
      if (name != null && surName != null) {
        fullName = name + " " + surName;
      }
    });
  }
}
