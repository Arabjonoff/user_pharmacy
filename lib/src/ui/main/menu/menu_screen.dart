import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/menu_bloc.dart';
import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_theme.dart';

class MenuScreen extends StatefulWidget {
  final Function onLogin;
  final Function onRegion;
  final Function onFavStore;
  final Function onNoteAll;
  final Function onHistory;
  final Function onLanguage;
  final Function onFaq;
  final Function onAbout;
  final Function onMyInfo;

  MenuScreen({
    this.onLogin,
    this.onRegion,
    this.onFavStore,
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

String language = "";
String languageData = "";

class _MenuScreenState extends State<MenuScreen> {
  Size size;

  String fullName = "";
  String city = "";
  int _stars = 0;
  var loading = false;

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    registerBus();
    super.initState();
  }

  void registerBus() {
    RxBus.register<BottomView>(tag: "MENU_VIEW").listen((event) {
      if (event.title) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  @override
  void dispose() {
    RxBus.destroy();
    super.dispose();
  }

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
              ? StreamBuilder(
                  stream: menuBack.cashBackOptions,
                  builder: (context, AsyncSnapshot<CashBackModel> snapshot) {
                    if (snapshot.hasData) {
                      Utils.saveCashBack(snapshot.data.cash);
                      return Container(
                        height: 146,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Container(
                              height: 146,
                              width: double.infinity,
                              color: AppTheme.white,
                              child: Image.asset(
                                "assets/images/menu_image.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15),
                                    Text(
                                      priceFormat.format((snapshot.data.cash)
                                              .toInt()
                                              .toDouble()) +
                                          translate("sum"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 24,
                                        height: 1.17,
                                        fontFamily: AppTheme.fontRoboto,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      translate("cash_price_title"
                                          ""),
                                      style: TextStyle(
                                        height: 1.17,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        fontFamily: AppTheme.fontRoboto,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Container(
                      height: 146,
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Container(
                            height: 146,
                            width: double.infinity,
                            color: AppTheme.white,
                            child: Image.asset(
                              "assets/images/menu_image.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 24,
                                      height: 1.17,
                                      fontFamily: AppTheme.fontRoboto,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    translate("cash_price_title"
                                        ""),
                                    style: TextStyle(
                                      height: 1.17,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12,
                                      fontFamily: AppTheme.fontRoboto,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                        onTap: widget.onLogin,
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
            onTap: widget.onFavStore,
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
                                        fontFamily: AppTheme.fontRoboto,
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
                                      fontFamily: AppTheme.fontRoboto,
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
                                      fontFamily: AppTheme.fontRoboto,
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
                                        fontFamily: AppTheme.fontRoboto,
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
                                                        AppTheme.fontRoboto,
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
          Container(
            margin: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
            child: Center(
              child: Text(
                translate("menu.number"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  color: AppTheme.black_text,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString('language') != null) {
        languageData = prefs.getString('language');
        if (prefs.getString('language') == "ru")
          language = translate("language.ru");
        else if (prefs.getString('language') == "uz")
          language = translate("language.uz");
        else if (prefs.getString('language') == "en")
          language = translate("language.en");
      } else {
        languageData = "ru";
        language = translate("language.ru");
      }
      if (prefs.getString("city") != null) {
        city = prefs.getString("city");
      } else {
        city = "Ташкент";
      }

      var name = prefs.getString("name");
      var surName = prefs.getString("surname");
      if (name != null && surName != null) {
        fullName = name + " " + surName;
      }
    });
  }
}
