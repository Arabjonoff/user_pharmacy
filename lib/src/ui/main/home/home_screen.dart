import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/blocs/menu_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/eventBus/check_version.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_theme.dart';

final priceFormat = new NumberFormat("#,##0", "ru");
String fcToken = "";

class HomeScreen extends StatefulWidget {
  final Function onStore;
  final Function onRegion;
  final Function onHistory;
  final Function onLogin;

  HomeScreen({
    this.onStore,
    this.onRegion,
    this.onHistory,
    this.onLogin,
  });

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DatabaseHelper dataBase = new DatabaseHelper();
  int page = 1;
  String city = "";
  final FirebaseMessaging _fcm = FirebaseMessaging();

  int _stars = 0;
  var loading = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    _setLanguage();
    _initPackageInfo();
    registerBus();
    _notificationFirebase();
    _getNoReview();
    blocHome.fetchCityName();
    blocHome.fetchAllHome(
      page,
      "",
      "",
      "",
      "",
      "",
      "",
    );
    Utils.isLogin().then((value) => {
          isLogin = value,
          if (isLogin)
            {
              menuBack.fetchCashBack(),
            }
        });

    super.initState();
  }

  void _getNoReview() {
    Utils.isLogin().then((value) => {
          isLogin = value,
          if (value)
            {
              Repository().fetchGetNoReview().then(
                    (value) => {
                      if (value.data.length > 0)
                        {
                          _stars = 0,
                          commentController.text = "",
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, setState) =>
                                    Container(
                                  height: 535,
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 5, right: 5),
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
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 16, left: 16, right: 16),
                                              height: 153,
                                              width: 153,
                                              child: SvgPicture.asset(
                                                  "assets/images/icon_comment.svg"),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 8, left: 16, right: 16),
                                              child: Text(
                                                translate("dialog_rat.title"),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
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
                                                color: AppTheme
                                                    .black_transparent_text,
                                                height: 1.47,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 8, left: 16, right: 16),
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: AppTheme.auth_border,
                                                    width: 1)),
                                            margin: EdgeInsets.only(
                                                left: 16, right: 16, top: 24),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.multiline,
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
                                                hintText: translate(
                                                    "dialog_rat.comment"),
                                                hintStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  color: AppTheme.grey,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.001),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.001),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (commentController
                                                          .text.length >
                                                      0 ||
                                                  _stars > 0) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                Repository()
                                                    .fetchOrderItemReview(
                                                      commentController.text,
                                                      _stars,
                                                      value.data[0],
                                                    )
                                                    .then(
                                                      (value) => {
                                                        setState(() {
                                                          loading = false;
                                                        }),
                                                        Navigator.of(context)
                                                            .pop(),
                                                      },
                                                    );
                                              }
                                            },
                                            child: Container(
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
                                                color: AppTheme.blue_app_color,
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
                                                        translate(
                                                            "dialog_rat.send"),
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                          color: AppTheme.white,
                                                          height: 1.29,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        },
                    },
                  ),
            }
        });
  }

  void _notificationFirebase() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {
        _notifiData(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _notifiData(message);
      },
    );
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.getToken().then((value) => {
          fcToken = value,
        });
  }

  void registerBus() {
    RxBus.register<BottomView>(tag: "HOME_VIEW").listen((event) {
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

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (info.buildNumber != null) {
      Repository().fetchCheckVersion(info.buildNumber).then((value) => {
            if (value.status != null && value.status != 0)
              {
                RxBus.post(
                    CheckVersionModel(
                        title: true,
                        packageName: info.packageName,
                        desk: value.description),
                    tag: "EVENT_ITEM_CHECK")
              }
            else if (!value.winner)
              {
                Utils.showWitter(context, value.konkursText),
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              brightness: Brightness.light,
              backgroundColor: AppTheme.white,
              expandedHeight: 155,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 36.45,
                      margin: EdgeInsets.only(left: 16, top: 38),
                      child:
                          SvgPicture.asset("assets/images/logo_new_design.svg"),
                    ),
                    GestureDetector(
                      onTap: widget.onRegion,
                      child: Container(
                        height: 28,
                        color: AppTheme.white,
                        margin: EdgeInsets.only(top: 16.0, left: 16, right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StreamBuilder(
                                stream: blocHome.allCityName,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRoboto,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.black_text,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "Ташкент",
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppTheme.black_text,
                                    ),
                                  );
                                }),
                            SizedBox(
                              width: 8,
                            ),
                            SvgPicture.asset(
                                "assets/images/down_arrow_black.svg"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              elevation: 1.0,
              bottom: PreferredSize(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 36,
                      margin: EdgeInsets.only(left: 12, right: 12),
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SearchScreen("", 0, 1),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.0),
                                  color: AppTheme.black_transparent,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.search,
                                      size: 24,
                                      color: AppTheme.notWhite,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        translate("search_hint"),
                                        style: TextStyle(
                                          color: AppTheme.notWhite,
                                          fontSize: 15,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        BottomDialog.voiceAssistantDialog(
                                            context);
                                        try {
                                          MethodChannel methodChannel =
                                              MethodChannel(
                                                  "flutter/MethodChannelDemoExam");
                                          var result = await methodChannel
                                              .invokeMethod("start");
                                          if (result.toString().length > 0) {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    SearchScreen(result, 0, 1),
                                              ),
                                            );
                                            await methodChannel
                                                .invokeMethod("stop");
                                          }
                                        } on PlatformException catch (e) {
                                          print(e.toString());
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        padding: EdgeInsets.all(7),
                                        child: SvgPicture.asset(
                                            "assets/images/voice.svg"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 17),
                                child: Center(
                                  child: SvgPicture.asset(
                                      "assets/images/scanner.svg"),
                                ),
                              ),
                              onTap: () {
                                var response = Utils.scanBarcodeNormal();
                                response.then(
                                  (value) => {
                                    if (value != "-1")
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.fade,
                                          child: SearchScreen(value, 1, 1),
                                        ),
                                      )
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16)
                  ],
                ),
                preferredSize: Size(double.infinity, 60),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 11,
              ),
              Container(
                height: 113.0,
                width: double.infinity,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    right: 15,
                    left: 15,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        isLogin
                            ? widget.onHistory()
                            : BottomDialog.createBottomSheetHistory(
                                context,
                                widget.onLogin,
                              );
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            children: [
                              SvgPicture.asset("assets/images/card.svg"),
                              Container(
                                padding: EdgeInsets.only(left: 12),
                                width: 113,
                                height: 113,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                      height: 23,
                                    ),
                                    SizedBox(
                                      height: 16,
                                      child: Text(
                                        translate("home.your"),
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 13,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: Text(
                                        translate("home.history").toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 15,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          right: 12,
                        ),
                        width: 128,
                        height: 113,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        RxBus.post(BottomViewModel(1),
                            tag: "EVENT_BOTTOM_VIEW");
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            children: [
                              SvgPicture.asset("assets/images/card2.svg"),
                              Container(
                                padding: EdgeInsets.only(left: 12),
                                width: 113,
                                height: 113,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                      height: 23,
                                    ),
                                    SizedBox(
                                      height: 16,
                                      child: Text(
                                        translate("home.look"),
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 13,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: Text(
                                        translate("home.pharmacy")
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 15,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          right: 12,
                        ),
                        width: 128,
                        height: 113,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onStore,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            children: [
                              SvgPicture.asset("assets/images/card3.svg"),
                              Container(
                                padding: EdgeInsets.only(left: 12),
                                width: 113,
                                height: 113,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                      height: 23,
                                    ),
                                    SizedBox(
                                      height: 16,
                                      child: Text(
                                        translate("home.karta"),
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 13,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: Text(
                                        translate("home.pharma").toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 15,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          right: 12,
                        ),
                        width: 128,
                        height: 113,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isLogin
                            ? RxBus.post(LoginModel(status: 1, msg: "Yes"),
                                tag: "EVENT_CHAT_SCREEN")
                            : BottomDialog.createBottomSheetHistory(
                                context,
                                widget.onLogin,
                              );
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            children: [
                              SvgPicture.asset("assets/images/card4.svg"),
                              Container(
                                padding: EdgeInsets.only(left: 12),
                                width: 113,
                                height: 113,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                      height: 23,
                                    ),
                                    SizedBox(
                                      height: 16,
                                      child: Text(
                                        translate("home.set"),
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 13,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: Text(
                                        translate("home.question")
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 15,
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          right: 12,
                        ),
                        width: 128,
                        height: 113,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.width - 30) / 2.0,
                width: double.infinity,
                margin: EdgeInsets.only(top: 32),
                child: StreamBuilder(
                  stream: blocHome.allSale,
                  builder: (context, AsyncSnapshot<SaleModel> snapshot) {
                    if (snapshot.hasData) {
                      return CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 0.9,
                          aspectRatio: 2.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                        ),
                        items: snapshot.data.results.map(
                          (url) {
                            return GestureDetector(
                              onTap: () {
                                if (url.drugs.length > 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemListScreen(
                                        url.name,
                                        4,
                                        url.drugs
                                            .toString()
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                            .replaceAll(' ', ''),
                                      ),
                                    ),
                                  );
                                } else if (url.drug != null) {
                                  RxBus.post(BottomViewModel(url.drug),
                                      tag: "EVENT_BOTTOM_ITEM_ALL");
                                } else if (url.category != null) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ItemListScreen(
                                        url.name,
                                        1,
                                        url.category.toString(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: 6,
                                  right: 6,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    color: AppTheme.white,
                                    child: CachedNetworkImage(
                                      imageUrl: url.image,
                                      placeholder: (context, url) => Container(
                                        color: AppTheme.background,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: AppTheme.background,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // padding: EdgeInsets.only(
                                //   right: 12,
                                // ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          right: 12,
                          left: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: 311,
                            height: 154,
                            margin: EdgeInsets.only(
                              right: 12,
                            ),
                          ),
                        ),
                        itemCount: 3,
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12, right: 12, top: 32),
                child: Row(
                  children: <Widget>[
                    Text(
                      translate("home.best"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.fontRoboto,
                        fontSize: 20,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemListScreen(
                              translate("home.best"),
                              2,
                              "0",
                            ),
                          ),
                        );
                      },
                      child: Text(
                        translate("home.show_all"),
                        style: TextStyle(
                          color: AppTheme.blue_app_color,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.fontRoboto,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 250.0,
                margin: EdgeInsets.only(top: 16),
                child: StreamBuilder(
                  stream: blocHome.getBestItem,
                  builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          right: 12,
                          left: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.results.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     type: PageTransitionType.bottomToTop,
                              //     alignment: Alignment.bottomCenter,
                              //     child: ItemScreenNotInstruction(
                              //         snapshot.data.results[index].id),
                              //   ),
                              // );
                              RxBus.post(
                                  BottomViewModel(
                                      snapshot.data.results[index].id),
                                  tag: "EVENT_BOTTOM_ITEM_ALL");
                            },
                            child: Container(
                              width: 140,
                              height: 250,
                              margin: EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 140,
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: snapshot.data.results[index]
                                              .getImageThumbnail,
                                          placeholder: (context, url) =>
                                              Container(
                                            padding: EdgeInsets.all(25),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/images/place_holder.svg"),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            padding: EdgeInsets.all(25),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/images/place_holder.svg"),
                                            ),
                                          ),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child:
                                              snapshot.data.results[index]
                                                          .price >=
                                                      snapshot
                                                          .data
                                                          .results[index]
                                                          .basePrice
                                                  ? Container()
                                                  : Container(
                                                      height: 18,
                                                      width: 39,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .red_fav_color,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "-" +
                                                              (((snapshot.data.results[index].basePrice - snapshot.data.results[index].price) *
                                                                          100) ~/
                                                                      snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .basePrice)
                                                                  .toString() +
                                                              "%",
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily: AppTheme
                                                                .fontRoboto,
                                                            color:
                                                                AppTheme.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      snapshot.data.results[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppTheme.black_text,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRoboto,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    child: Text(
                                      snapshot.data.results[index]
                                                  .manufacturer ==
                                              null
                                          ? ""
                                          : snapshot.data.results[index]
                                              .manufacturer.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppTheme.black_transparent_text,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: AppTheme.fontRoboto,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 30,
                                        width: 120,
                                        margin: EdgeInsets.only(top: 11),
                                        child: snapshot
                                                .data.results[index].isComing
                                            ? Container(
                                                child: Center(
                                                  child: Text(
                                                    translate("fast"),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                          AppTheme.black_text,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          AppTheme.fontRoboto,
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              )
                                            : snapshot.data.results[index]
                                                        .cardCount >
                                                    0
                                                ? Container(
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme
                                                          .blue_transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    width: 120,
                                                    child: Row(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  AppTheme.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10.0,
                                                              ),
                                                            ),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                            height: 26,
                                                            width: 26,
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: AppTheme
                                                                    .white,
                                                                size: 19,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount >
                                                                1) {
                                                              setState(() {
                                                                snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount = snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount -
                                                                    1;
                                                                dataBase.updateProduct(
                                                                    snapshot.data
                                                                            .results[
                                                                        index]);
                                                              });
                                                            } else if (snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount ==
                                                                1) {
                                                              setState(() {
                                                                snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount = snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount -
                                                                    1;

                                                                dataBase.deleteProducts(
                                                                    snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .id);
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          width: 60,
                                                          child: Center(
                                                            child: Text(
                                                              snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .cardCount
                                                                      .toString() +
                                                                  " " +
                                                                  translate(
                                                                      "item.sht"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: AppTheme
                                                                    .blue,
                                                                fontFamily: AppTheme
                                                                    .fontRoboto,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount <
                                                                snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .maxCount)
                                                              setState(() {
                                                                snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount = snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount +
                                                                    1;
                                                                dataBase.updateProduct(
                                                                    snapshot.data
                                                                            .results[
                                                                        index]);
                                                              });
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  AppTheme.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10.0,
                                                              ),
                                                            ),
                                                            height: 26,
                                                            width: 26,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                color: AppTheme
                                                                    .white,
                                                                size: 19,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        snapshot
                                                            .data
                                                            .results[index]
                                                            .cardCount = 1;

                                                        dataBase.saveProducts(
                                                            snapshot.data
                                                                    .results[
                                                                index]);
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 140,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        color: AppTheme.blue,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              priceFormat.format(snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .price) +
                                                                  translate(
                                                                      "sum"),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily: AppTheme
                                                                    .fontRoboto,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          SvgPicture.asset(
                                                            "assets/images/card_icon.svg",
                                                          ),
                                                          SizedBox(
                                                            width: 8.11,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(
                                right: 12,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          right: 12,
                          left: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Container(
                            width: 140,
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  color: AppTheme.white,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 15,
                                  width: double.infinity,
                                  color: AppTheme.white,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  color: AppTheme.white,
                                  height: 14,
                                  width: 80,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                              right: 12,
                            ),
                          ),
                        ),
                        itemCount: 8,
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 24,
                        left: 12,
                        right: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEEEEFF),
                            Color(0xFFF8F8FF),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25,
                            width: double.infinity,
                          ),
                          Image.asset(
                            "assets/images/home_bonus.png",
                            width: 124,
                            height: 124,
                          ),
                          SizedBox(
                            height: 32,
                            width: double.infinity,
                          ),
                          Text(
                            translate("home.bonus"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              height: 1.1,
                              color: AppTheme.black_text,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 16,
                              left: 26,
                              right: 26,
                              bottom: 24,
                            ),
                            child: Center(
                              child: Text(
                                translate("home.bonus_txt"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Color(0xFF6E80B0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8,
                        left: MediaQuery.of(context).size.width / 4.15,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/images/bonus_one.png",
                          width: 46,
                          height: 46,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 9.375,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/bonus_two.png",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 110,
                        left: MediaQuery.of(context).size.width / 7.5,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/images/bonus_three.png",
                          width: 46,
                          height: 46,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 104,
                        right: 2,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/bonus_four.png",
                        ),
                      ),
                    ),
                  ],
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
                  height: 88,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 24,
                    bottom: 32,
                  ),
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 16,
                    top: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFE2EEFB),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              translate("call_center"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    MediaQuery.of(context).size.width > 375
                                        ? 18
                                        : 12,
                                color: AppTheme.black_text,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset("assets/images/call.svg"),
                                SizedBox(width: 8),
                                Text(
                                  "+998 (71) 205-0-888",
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize:
                                        MediaQuery.of(context).size.width > 375
                                            ? 18
                                            : 12,
                                    height: 1.6,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.blue,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SvgPicture.asset("assets/images/call_center.svg")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale(prefs.getString('language')));
      });
    } else {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale('ru'));
      });
    }
  }

  void _notifiData(Map<String, dynamic> message) {
    int item = int.parse(message["data"]["drug"]);
    int category = int.parse(message["data"]["category"]);
    String ids = message["data"]["drugs"];

    if (item > 0) {
      RxBus.post(BottomViewModel(item), tag: "EVENT_BOTTOM_ITEM_NOTF");
    } else if (category > 0) {
      RxBus.post(BottomViewModel(category), tag: "EVENT_BOTTOM_CATEGORY_NOTF");
    } else if (ids.length > 2) {
      RxBus.post(BottomViewIdsModel(ids), tag: "EVENT_BOTTOM_IDS_NOTF");
    }
  }
}
