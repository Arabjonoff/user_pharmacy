import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/main.dart';
import 'package:pharmacy/src/blocs/menu_bloc.dart';
import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_theme.dart';

class MenuScreen extends StatefulWidget {
  final Function onLogin;
  final Function onRegion;
  final Function onNoteAll;
  final Function onHistory;
  final Function onLanguage;
  final Function onFaq;
  final Function onAbout;
  final Function onMyInfo;

  MenuScreen({
    this.onLogin,
    this.onRegion,
    this.onNoteAll,
    this.onHistory,
    this.onLanguage,
    this.onFaq,
    this.onAbout,
    this.onMyInfo,
  });

  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  String language = "";
  String languageData = "";
  String fullName = "";
  String city = "";
  int _stars = 0;
  var loading = false;

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    _registerBus();
    _getLanguage();
    super.initState();
  }

  @override
  void dispose() {
    RxBus.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils.isLogin().then((value) => isLogin = value);

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
              translate("menu.name"),
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
      body: ListView(
        children: <Widget>[
          isLogin
              ? StreamBuilder(
                  stream: menuBack.cashBackOptions,
                  builder: (context, AsyncSnapshot<CashBackModel> snapshot) {
                    if (snapshot.hasData) {
                      Utils.saveCashBack(snapshot.data.cash);
                      return Container(
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              color: AppTheme.white,
                              child: Image.asset(
                                "assets/img/menu_image.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    translate("cash_price_title"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      height: 1.2,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    priceFormat.format((snapshot.data.cash)
                                            .toInt()
                                            .toDouble()) +
                                        translate("sum"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      height: 1.2,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            color: AppTheme.white,
                            child: Image.asset(
                              "assets/img/menu_image.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  translate("cash_price_title"),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    height: 1.2,
                                    color: AppTheme.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    height: 1.2,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF70B2FF),
                          Color(0xFF5C9CE6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          translate("menu.login_title"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.6,
                            color: AppTheme.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLogin,
                          child: Container(
                            height: 44,
                            margin: EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                translate("menu.login"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 1.42,
                                  color: AppTheme.blue,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 24,
                    right: 24,
                  ),
                  child: Text(
                    translate("menu.all"),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/profile.svg",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate("menu.user_info"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.43,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                isLogin ? fullName : translate("menu.user"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.67,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          "assets/icons/arrow_right_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                isLogin
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/history.svg",
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate("menu.history_title"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.43,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      translate("menu.history_message"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        height: 1.67,
                                        color: AppTheme.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              SvgPicture.asset(
                                "assets/icons/arrow_right_grey.svg",
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                isLogin
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/card.svg",
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate("menu.price_title"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.43,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      translate("menu.price_message"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        height: 1.67,
                                        color: AppTheme.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              SvgPicture.asset(
                                "assets/icons/arrow_right_grey.svg",
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                isLogin
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location.svg",
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate("menu.my_address_title"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.43,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      translate("menu.my_address_message"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        height: 1.67,
                                        color: AppTheme.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              SvgPicture.asset(
                                "assets/icons/arrow_right_grey.svg",
                                width: 24,
                                height: 24,
                              ),
                            ],
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
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 24,
                    right: 24,
                  ),
                  child: Text(
                    translate("menu.settings"),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/language.svg",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate("menu.language"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.43,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                language,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.67,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          "assets/icons/arrow_right_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                isLogin
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/password.svg",
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate("menu.pin_title"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.43,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      translate("menu.pin_message"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        height: 1.67,
                                        color: AppTheme.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              SvgPicture.asset(
                                "assets/icons/arrow_right_grey.svg",
                                width: 24,
                                height: 24,
                              ),
                            ],
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
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 24,
                    right: 24,
                  ),
                  child: Text(
                    translate("menu.other"),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/rate.svg",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate("menu.feedback_title"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.43,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                translate("menu.feedback_message"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.67,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          "assets/icons/arrow_right_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/faq.svg",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate("menu.qus_title"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.43,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                translate("menu.qus_message"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.67,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          "assets/icons/arrow_right_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/about_app.svg",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate("menu.about_title"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.43,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                translate("menu.about_message"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.67,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          "assets/icons/arrow_right_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/phone_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "+998 (71) 205-0-888",
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.43,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                translate("menu.call_center"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.67,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        SvgPicture.asset(
                          "assets/icons/arrow_right_grey.svg",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          isLoginPage
              ? Container(
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
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/exit.svg",
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate("menu.exit"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.43,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      translate("menu.exit_message"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        height: 1.67,
                                        color: AppTheme.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              SvgPicture.asset(
                                "assets/icons/arrow_right_grey.svg",
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              : Container(),
          SizedBox(height: 24),
          isLogin
              ? GestureDetector(
                  onTap: widget.onMyInfo,
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: AppTheme.fontRubik,
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
                                        fontFamily: AppTheme.fontRubik,
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
            onTap: widget.onRegion,
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
                        fontFamily: AppTheme.fontRubik,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    city,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: AppTheme.fontRubik,
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
            onTap: widget.onNoteAll,
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
                          "assets/images/icon_notification.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("note.screen_name"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRubik,
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
                  onTap: widget.onHistory,
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
                              fontFamily: AppTheme.fontRubik,
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
            onTap: widget.onLanguage,
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
                        fontFamily: AppTheme.fontRubik,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    language,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: AppTheme.fontRubik,
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
              _stars = 0;
              commentController.text = "";
              menuBack.fetchVisible(0, "");
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      commentController.addListener(() {
                        menuBack.fetchVisible(_stars, commentController.text);
                      });
                      return Container(
                        height: 535,
                        padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppTheme.white,
                          ),
                          child: Theme(
                            data: ThemeData(
                              platform: TargetPlatform.android,
                            ),
                            child: ListView(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 12),
                                    height: 4,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: AppTheme.bottom_dialog,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 16, left: 16, right: 16),
                                      height: 153,
                                      width: 153,
                                      child: SvgPicture.asset(
                                          "assets/images/icon_comment.svg"),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 8, left: 16, right: 16),
                                    child: Text(
                                      translate("dialog_rat.title"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        fontStyle: FontStyle.normal,
                                        color: AppTheme.black_text,
                                        height: 1.65,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 8, left: 32, right: 32),
                                  child: Text(
                                    translate("dialog_rat.message"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_transparent_text,
                                      height: 1.47,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 8, left: 16, right: 16),
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: _stars >= 1
                                            ? SvgPicture.asset(
                                                "assets/images/star_select.svg")
                                            : SvgPicture.asset(
                                                "assets/images/star_unselect.svg"),
                                        onTap: () {
                                          setState(() {
                                            _stars = 1;
                                            menuBack.fetchVisible(
                                                _stars, commentController.text);
                                          });
                                        },
                                      ),
                                      SizedBox(width: 16),
                                      InkWell(
                                        child: _stars >= 2
                                            ? SvgPicture.asset(
                                                "assets/images/star_select.svg")
                                            : SvgPicture.asset(
                                                "assets/images/star_unselect.svg"),
                                        onTap: () {
                                          setState(() {
                                            _stars = 2;
                                            menuBack.fetchVisible(
                                                _stars, commentController.text);
                                          });
                                        },
                                      ),
                                      SizedBox(width: 16),
                                      InkWell(
                                        child: _stars >= 3
                                            ? SvgPicture.asset(
                                                "assets/images/star_select.svg")
                                            : SvgPicture.asset(
                                                "assets/images/star_unselect.svg"),
                                        onTap: () {
                                          setState(() {
                                            _stars = 3;
                                            menuBack.fetchVisible(
                                                _stars, commentController.text);
                                          });
                                        },
                                      ),
                                      SizedBox(width: 16),
                                      InkWell(
                                        child: _stars >= 4
                                            ? SvgPicture.asset(
                                                "assets/images/star_select.svg")
                                            : SvgPicture.asset(
                                                "assets/images/star_unselect.svg"),
                                        onTap: () {
                                          setState(() {
                                            _stars = 4;
                                            menuBack.fetchVisible(
                                                _stars, commentController.text);
                                          });
                                        },
                                      ),
                                      SizedBox(width: 16),
                                      InkWell(
                                        child: _stars >= 5
                                            ? SvgPicture.asset(
                                                "assets/images/star_select.svg")
                                            : SvgPicture.asset(
                                                "assets/images/star_unselect.svg"),
                                        onTap: () {
                                          setState(() {
                                            _stars = 5;
                                            menuBack.fetchVisible(
                                                _stars, commentController.text);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 93,
                                  decoration: BoxDecoration(
                                      color: AppTheme.auth_login,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppTheme.auth_border,
                                          width: 1)),
                                  margin: EdgeInsets.only(
                                      left: 16, right: 16, top: 24),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_text,
                                      fontSize: 16,
                                    ),
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: translate("dialog_rat.comment"),
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: AppTheme.fontRubik,
                                        color: AppTheme.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              AppTheme.grey.withOpacity(0.001),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              AppTheme.grey.withOpacity(0.001),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (commentController.text.length > 0 ||
                                        _stars > 0) {
                                      setState(() {
                                        loading = true;
                                      });
                                      Repository()
                                          .fetchSendRating(
                                              commentController.text, _stars)
                                          .then(
                                            (value) => {
                                              setState(() {
                                                loading = false;
                                              }),
                                              Navigator.of(context).pop(),
                                            },
                                          );
                                    }
                                  },
                                  child: StreamBuilder(
                                    stream: menuBack.visibleOptions,
                                    builder: (context,
                                        AsyncSnapshot<bool> snapshot) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                          top: 24,
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                        ),
                                        height: 44,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: (snapshot.data != null)
                                              ? snapshot.data
                                                  ? AppTheme.blue_app_color
                                                  : AppTheme
                                                      .blue_app_color_transparent
                                              : AppTheme
                                                  .blue_app_color_transparent,
                                        ),
                                        child: Center(
                                          child: loading
                                              ? CircularProgressIndicator(
                                                  value: null,
                                                  strokeWidth: 3.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppTheme.white),
                                                )
                                              : Text(
                                                  translate("dialog_rat.send"),
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    color: AppTheme.white,
                                                    height: 1.29,
                                                  ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
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
                          SvgPicture.asset("assets/images/message_square.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.rating"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRubik,
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
            onTap: widget.onFaq,
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
                      child: SvgPicture.asset("assets/images/icon_faq.svg"),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      translate("menu.faq"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRubik,
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
            onTap: widget.onAbout,
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
                        fontFamily: AppTheme.fontRubik,
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
              var url = "tel:+998712050888";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              color: AppTheme.white,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: translate("menu.number"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          color: AppTheme.black_text,
                        ),
                      ),
                      TextSpan(
                        text: "+998 71 205 08 88",
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          color: AppTheme.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerBus() {
    RxBus.register<BottomView>(tag: "MENU_VIEW").listen((event) {
      if (event.title) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  Future<void> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var lan = prefs.getString('language') ?? "ru";
      if (lan == "ru")
        language = "Русский";
      else if (lan == "uz")
        language = "O'zbekcha";
      else if (lan == "en") language = "English";
      city = prefs.getString("city") ?? "Ташкент";
      var name = prefs.getString("name");
      var surName = prefs.getString("surname");
      if (name != null && surName != null) {
        fullName = name + " " + surName;
      }
    });
  }
}
