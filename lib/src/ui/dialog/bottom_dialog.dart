import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/blocs/items_bloc.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomDialog {
  static void showWinner(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 375,
          padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: AppTheme.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.bottom_dialog,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/images/winner.png"),
                ),
                Text(
                  translate("winner.title"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    height: 1.65,
                    color: AppTheme.black_text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 24, right: 24, top: 8),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: 1.6,
                      color: AppTheme.grey,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 20,
                    ),
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        translate("winner.button"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          height: 1.3,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showUpdate(
    BuildContext context,
    String text,
    bool optional,
  ) async {
    showModalBottomSheet(
      barrierColor: Color.fromRGBO(23, 43, 77, 0.3),
      context: context,
      isScrollControlled: true,
      isDismissible: optional,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: optional ? 365 : 321,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
                color: AppTheme.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.bottom_dialog,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        translate("home.update_title"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.2,
                          color: AppTheme.text_dark,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/img/update_image.png",
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 1.6,
                      color: AppTheme.textGray,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      if (Platform.isAndroid) {
                        var url =
                            'https://play.google.com/store/apps/details?id=uz.go.pharm';
                        await launch(url);
                      } else if (Platform.isIOS) {
                        var url =
                            'https://apps.apple.com/uz/app/gopharm-online/id1527930423';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }
                    },
                    child: Container(
                      height: 44,
                      margin: EdgeInsets.only(
                        bottom: 16,
                        top: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          translate("home.update_button"),
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
                  optional
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            color: AppTheme.white,
                            child: Center(
                              child: Text(
                                translate("home.skip"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.25,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void showNetworkError(BuildContext context, Function reload) async {
    showModalBottomSheet(
      barrierColor: Color.fromRGBO(23, 43, 77, 0.3),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: 365,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
                color: AppTheme.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.bottom_dialog,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        translate("network.network_title"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.2,
                          color: AppTheme.text_dark,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/img/network_error_image.png",
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    translate("network.network_message"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 1.6,
                      color: AppTheme.textGray,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      reload();
                    },
                    child: Container(
                      height: 44,
                      margin: EdgeInsets.only(
                        bottom: 16,
                        top: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          translate("network.reload_screen"),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 44,
                      color: AppTheme.white,
                      child: Center(
                        child: Text(
                          translate("network.close"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.25,
                            color: AppTheme.textGray,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void showCommentService(BuildContext context, int orderId) async {
    int _stars = 5;
    TextEditingController commentController = TextEditingController();
    var loading = false;
    showModalBottomSheet(
      barrierColor: Color.fromRGBO(23, 43, 77, 0.3),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Container(
            height: 534,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: AppTheme.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8),
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.bottom_dialog,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Text(
                    translate("comment.title"),
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
                  height: 80,
                  width: 80,
                  margin: EdgeInsets.only(top: 24, bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/img/note_image.png",
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    translate("comment.message"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 1.6,
                      color: AppTheme.textGray,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  height: 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: _stars >= 1
                            ? SvgPicture.asset("assets/icons/star_select.svg")
                            : SvgPicture.asset(
                                "assets/icons/star_un_select.svg"),
                        onTap: () {
                          setState(() {
                            _stars = 1;
                          });
                        },
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        child: _stars >= 2
                            ? SvgPicture.asset("assets/icons/star_select.svg")
                            : SvgPicture.asset(
                                "assets/icons/star_un_select.svg"),
                        onTap: () {
                          setState(() {
                            _stars = 2;
                          });
                        },
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        child: _stars >= 3
                            ? SvgPicture.asset("assets/icons/star_select.svg")
                            : SvgPicture.asset(
                                "assets/icons/star_un_select.svg"),
                        onTap: () {
                          setState(() {
                            _stars = 3;
                          });
                        },
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        child: _stars >= 4
                            ? SvgPicture.asset("assets/icons/star_select.svg")
                            : SvgPicture.asset(
                                "assets/icons/star_un_select.svg"),
                        onTap: () {
                          setState(() {
                            _stars = 4;
                          });
                        },
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        child: _stars >= 5
                            ? SvgPicture.asset("assets/icons/star_select.svg")
                            : SvgPicture.asset(
                                "assets/icons/star_un_select.svg"),
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
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      translate("comment.comment"),
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        height: 1.2,
                        color: AppTheme.textGray,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.text_dark,
                      ),
                      controller: commentController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.background,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (commentController.text.length > 0 || _stars > 0) {
                      setState(() {
                        loading = true;
                      });
                      Repository()
                          .fetchOrderItemReview(
                            commentController.text,
                            _stars,
                            orderId,
                          )
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
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.blue_app_color,
                    ),
                    child: Center(
                      child: loading
                          ? CircularProgressIndicator(
                              value: null,
                              strokeWidth: 3.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(AppTheme.white),
                            )
                          : Text(
                              translate("dialog_rat.send"),
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontRubik,
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
        );
      },
    );
  }

  static void showItemDrug(BuildContext context, int id) async {
    showModalBottomSheet(
      barrierColor: Color.fromRGBO(23, 43, 77, 0.3),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height - 60,
              margin: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
                color: AppTheme.white,
              ),
              child: StreamBuilder(
                stream: blocItem.allItems,
                builder: (context, AsyncSnapshot<ItemsAllModel> snapshot) {
                  if (snapshot.hasData) {
                    return ListView();
                  }
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            left: (MediaQuery.of(context).size.width - 60) / 2,
                            right: (MediaQuery.of(context).size.width - 60) / 2,
                          ),
                          height: 4,
                          width: 60,
                          color: AppTheme.white,
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 24,bottom: 24),
                            height: 240,
                            width: 240,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          height: 15,
                          width: 250,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          height: 22,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          height: 22,
                          width: 125,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.only(left: 16, right: 16),
                          height: 40,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  static void createBottomSheetHistory(
    BuildContext context,
    Function _onLogin,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 210,
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _onLogin();
                            // Navigator.pushReplacement(
                            //   context,
                            //   PageTransition(
                            //     type: PageTransitionType.bottomToTop,
                            //     child: LoginScreen(),
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppTheme.blue_app_color,
                            ),
                            height: 44,
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 16,
                              bottom: 30,
                              left: 16,
                              right: 16,
                            ),
                            child: Center(
                              child: Text(
                                translate("dialog.enter"),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: AppTheme.fontRubik,
                                  fontSize: 17,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        translate("dialog.soglas"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.black_transparent_text,
                          fontFamily: AppTheme.fontRubik,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var url = 'https://api.gopharm.uz/privacy';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Text(
                          translate("dialog.danniy"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.blue_app_color,
                            fontFamily: AppTheme.fontRubik,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void bottomDialogOrder(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 420,
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SvgPicture.asset(
                            "assets/images/image_defoult_dialog.svg"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
                      child: Text(
                        translate("dialog_rat.order_title"),
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRubik,
                          fontSize: 17,
                          height: 1.65,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black_text,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      child: Text(
                        translate("dialog_rat.order_message"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRubik,
                          fontSize: 13,
                          height: 1.38,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryOrderScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 44,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            border: Border.all(
                              color: AppTheme.blue_app_color,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            translate("dialog_rat.history"),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              fontFamily: AppTheme.fontRubik,
                              fontStyle: FontStyle.normal,
                              height: 1.29,
                              color: AppTheme.blue_app_color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 44,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            color: AppTheme.blue_app_color,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            translate("dialog_rat.close"),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              fontFamily: AppTheme.fontRubik,
                              fontStyle: FontStyle.normal,
                              height: 1.29,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void historyCancelOrder(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              padding: EdgeInsets.only(bottom: 24, left: 8, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 16),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 153,
                        width: 153,
                        child:
                            SvgPicture.asset("assets/images/cancel_order.svg"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Center(
                        child: Text(
                          translate("history.cancel_text"),
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRubik,
                            height: 1.65,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 32, right: 32),
                      child: Center(
                        child: Text(
                          translate("history.cancel_message"),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRubik,
                            color: AppTheme.black_transparent_text,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () async {
                        var url = "tel:+998712051209";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.blue_app_color,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 44,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            translate("history.call"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 17,
                              height: 1.3,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
