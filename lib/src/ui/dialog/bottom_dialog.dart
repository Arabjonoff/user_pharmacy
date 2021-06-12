import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/blocs/items_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_fav.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:pharmacy/src/utils/number_mask.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_html_css/simple_html_css.dart';
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
                      color: AppTheme.textGray,
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

  static void showEditInfo(
    BuildContext context,
    String firstName,
    String lastName,
    String number,
    Function(
      String firstName,
      String lastName,
      String number,
    )
        onChanges,
  ) async {
    TextEditingController lastNameController =
        TextEditingController(text: lastName);
    TextEditingController numberController =
        TextEditingController(text: number);
    TextEditingController firstNameController =
        TextEditingController(text: firstName);

    final PhoneNumberTextInputFormatter _phoneNumber =
        new PhoneNumberTextInputFormatter();
    showModalBottomSheet(
      barrierColor: Color.fromRGBO(23, 43, 77, 0.3),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: 326,
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
                    width: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.bottom_dialog,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        translate("card.choose_info"),
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
                  Container(
                    height: 44,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 24,
                    ),
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLength: 35,
                      controller: lastNameController,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 44,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 16,
                    ),
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLength: 35,
                      controller: firstNameController,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 44,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLength: 17,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        _phoneNumber,
                      ],
                      controller: numberController,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () async {
                      if (numberController.text.length == 17 &&
                          firstNameController.text.length > 0 &&
                          lastNameController.text.length > 0) {
                        Navigator.pop(context);
                        onChanges(firstNameController.text,
                            lastNameController.text, numberController.text);
                      }
                    },
                    child: Container(
                      height: 44,
                      margin: EdgeInsets.only(
                        bottom: 24,
                        top: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          translate("card.save"),
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
                ],
              ),
            );
          },
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
    blocItem.fetchAllInfoItem(id.toString());

    DatabaseHelper dataBase = new DatabaseHelper();
    DatabaseHelperFav dataBaseFav = new DatabaseHelperFav();
    int currentIndex = 0;

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
                    return Column(
                      children: [
                        Container(
                          height: 28,
                          padding: EdgeInsets.only(top: 8, bottom: 16),
                          child: Container(
                            height: 4,
                            width: 64,
                            color: AppTheme.text_dark.withOpacity(0.05),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                height: 190,
                                margin: EdgeInsets.only(left: 16, right: 16),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data.image,
                                        placeholder: (context, url) =>
                                            SvgPicture.asset(
                                          "assets/images/place_holder.svg",
                                        ),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset(
                                          "assets/images/place_holder.svg",
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          snapshot.data.favourite =
                                              !snapshot.data.favourite;
                                          if (snapshot.data.favourite) {
                                            dataBaseFav
                                                .saveProducts(
                                              ItemResult(
                                                snapshot.data.id,
                                                snapshot.data.name,
                                                snapshot.data.barcode,
                                                snapshot.data.image,
                                                snapshot.data.imageThumbnail,
                                                snapshot.data.price,
                                                Manifacture(snapshot
                                                    .data.manufacturer.name),
                                                true,
                                                0,
                                              ),
                                            )
                                                .then((value) {
                                              blocItem.fetchItemUpdate();
                                            });
                                          } else {
                                            dataBaseFav
                                                .deleteProducts(
                                                    snapshot.data.id)
                                                .then((value) {
                                              blocItem.fetchItemUpdate();
                                            });
                                          }
                                        },
                                        child: snapshot.data.favourite
                                            ? SvgPicture.asset(
                                                "assets/icons/fav_select.svg",
                                                width: 32,
                                                height: 32,
                                              )
                                            : SvgPicture.asset(
                                                "assets/icons/fav_unselect.svg",
                                                width: 32,
                                                height: 32,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.blue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/icon_rating.svg"),
                                            SizedBox(width: 4),
                                            Text(
                                              snapshot.data.rating.toString(),
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                height: 1.2,
                                                color: AppTheme.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      top: 0,
                                      left: 0,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                child: Text(
                                  snapshot.data.manufacturer.name,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    height: 1.2,
                                    color: AppTheme.textGray,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 16, right: 16),
                                child: Text(
                                  snapshot.data.name,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    height: 1.5,
                                    color: AppTheme.text_dark,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 8,
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                child: snapshot.data.price >=
                                        snapshot.data.basePrice
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          translate("lan") != "2"
                                              ? Text(
                                                  translate("from"),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20,
                                                    height: 1.5,
                                                    color: AppTheme.text_dark,
                                                  ),
                                                )
                                              : Container(),
                                          Text(
                                            priceFormat.format(
                                                    snapshot.data.price) +
                                                translate("sum"),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRubik,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              height: 1.5,
                                              color: AppTheme.text_dark,
                                            ),
                                          ),
                                          translate("lan") == "2"
                                              ? Text(
                                                  translate("from"),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20,
                                                    height: 1.5,
                                                    color: AppTheme.text_dark,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          translate("lan") != "2"
                                              ? Text(
                                                  translate("from"),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20,
                                                    height: 1.5,
                                                    color: AppTheme.red,
                                                  ),
                                                )
                                              : Container(),
                                          Text(
                                            priceFormat.format(
                                                    snapshot.data.price) +
                                                translate("sum"),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRubik,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              height: 1.5,
                                              color: AppTheme.red,
                                            ),
                                          ),
                                          translate("lan") == "2"
                                              ? Text(
                                                  translate("from"),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20,
                                                    height: 1.5,
                                                    color: AppTheme.red,
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(width: 12),
                                          RichText(
                                            text: new TextSpan(
                                              text: priceFormat.format(
                                                      snapshot.data.basePrice) +
                                                  translate("sum"),
                                              style: new TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                height: 1.5,
                                                color: AppTheme.textGray,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: AppTheme.background,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16, right: 16),
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (currentIndex != 0) {
                                            setState(() {
                                              currentIndex = 0;
                                            });
                                          }
                                        },
                                        child: Container(
                                          color: AppTheme.white,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    translate(
                                                        "item.description"),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          currentIndex == 0
                                                              ? FontWeight.w500
                                                              : FontWeight.w400,
                                                      fontSize: 14,
                                                      height: 1.2,
                                                      color: currentIndex == 0
                                                          ? AppTheme.text_dark
                                                          : AppTheme.textGray,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 270),
                                                curve: Curves.easeInOut,
                                                height:
                                                    currentIndex == 0 ? 2 : 1,
                                                width: double.infinity,
                                                color: currentIndex == 0
                                                    ? AppTheme.blue
                                                    : AppTheme.background,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (currentIndex != 1) {
                                            setState(() {
                                              currentIndex = 1;
                                            });
                                          }
                                        },
                                        child: Container(
                                          color: AppTheme.white,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    translate("item.analog"),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          currentIndex == 1
                                                              ? FontWeight.w500
                                                              : FontWeight.w400,
                                                      fontSize: 14,
                                                      height: 1.2,
                                                      color: currentIndex == 1
                                                          ? AppTheme.text_dark
                                                          : AppTheme.textGray,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 270),
                                                curve: Curves.easeInOut,
                                                height:
                                                    currentIndex == 1 ? 2 : 1,
                                                width: double.infinity,
                                                color: currentIndex == 1
                                                    ? AppTheme.blue
                                                    : AppTheme.background,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              currentIndex == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(16),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                translate("item.substance"),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                  color: AppTheme.textGray,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                snapshot.data.internationalName
                                                    .name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  height: 1.6,
                                                  color: AppTheme.text_dark,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                translate("item.release"),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                  color: AppTheme.textGray,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                snapshot.data.unit.name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  height: 1.6,
                                                  color: AppTheme.text_dark,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                translate("item.category"),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                  color: AppTheme.textGray,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                snapshot.data.category.name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  height: 1.6,
                                                  color: AppTheme.text_dark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                          ),
                                          child: Text(
                                            translate("item.info"),
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
                                          margin: EdgeInsets.only(
                                            top: 12,
                                            left: 16,
                                            right: 16,
                                          ),
                                          child: RichText(
                                            text: HTML.toTextSpan(
                                              context,
                                              snapshot.data.description,
                                              defaultTextStyle: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                                height: 1.6,
                                                color: AppTheme.textGray,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(
                                      height: 190,
                                      margin: EdgeInsets.only(top: 16),
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          right: 16,
                                          left: 16,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showItemDrug(
                                                  context,
                                                  snapshot
                                                      .data.analog[index].id);
                                            },
                                            child: Container(
                                              width: 148,
                                              height: 189,
                                              decoration: BoxDecoration(
                                                color: AppTheme.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              margin: EdgeInsets.only(
                                                right: 16,
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                .data
                                                                .analog[index]
                                                                .imageThumbnail,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    SvgPicture
                                                                        .asset(
                                                              "assets/images/place_holder.svg",
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    SvgPicture
                                                                        .asset(
                                                              "assets/images/place_holder.svg",
                                                            ),
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              snapshot
                                                                      .data
                                                                      .analog[index]
                                                                      .favourite =
                                                                  !snapshot
                                                                      .data
                                                                      .analog[
                                                                          index]
                                                                      .favourite;
                                                              if (snapshot
                                                                  .data
                                                                  .analog[index]
                                                                  .favourite) {
                                                                dataBaseFav
                                                                    .saveProducts(snapshot
                                                                            .data
                                                                            .analog[
                                                                        index])
                                                                    .then(
                                                                        (value) {
                                                                  blocItem
                                                                      .fetchAnalogUpdate();
                                                                });
                                                              } else {
                                                                dataBaseFav
                                                                    .deleteProducts(snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .id)
                                                                    .then(
                                                                        (value) {
                                                                  blocItem
                                                                      .fetchAnalogUpdate();
                                                                });
                                                              }
                                                            },
                                                            child: snapshot
                                                                    .data
                                                                    .analog[
                                                                        index]
                                                                    .favourite
                                                                ? SvgPicture.asset(
                                                                    "assets/icons/fav_select.svg")
                                                                : SvgPicture.asset(
                                                                    "assets/icons/fav_unselect.svg"),
                                                          ),
                                                          top: 0,
                                                          right: 0,
                                                        ),
                                                        Positioned(
                                                          child: snapshot
                                                                      .data
                                                                      .analog[
                                                                          index]
                                                                      .price >=
                                                                  snapshot
                                                                      .data
                                                                      .analog[
                                                                          index]
                                                                      .basePrice
                                                              ? Container()
                                                              : Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppTheme
                                                                        .red
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    "-" +
                                                                        (((snapshot.data.analog[index].basePrice - snapshot.data.analog[index].price) * 100) ~/
                                                                                snapshot.data.analog[index].basePrice)
                                                                            .toString() +
                                                                        "%",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ),
                                                          top: 0,
                                                          left: 0,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    snapshot.data.analog[index]
                                                        .name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
                                                      height: 1.5,
                                                      color: AppTheme.text_dark,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    snapshot.data.analog[index]
                                                        .manufacturer.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 10,
                                                      height: 1.2,
                                                      color: AppTheme.textGray,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  snapshot.data.analog[index]
                                                          .isComing
                                                      ? Container(
                                                          height: 29,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppTheme.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Center(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: translate(
                                                                        "fast"),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : snapshot
                                                                  .data
                                                                  .analog[index]
                                                                  .cardCount >
                                                              0
                                                          ? Container(
                                                              height: 29,
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppTheme
                                                                    .blue
                                                                    .withOpacity(
                                                                        0.12),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      if (snapshot
                                                                              .data
                                                                              .analog[index]
                                                                              .cardCount >
                                                                          1) {
                                                                        snapshot
                                                                            .data
                                                                            .analog[
                                                                                index]
                                                                            .cardCount = snapshot
                                                                                .data.analog[index].cardCount -
                                                                            1;
                                                                        dataBase
                                                                            .updateProduct(snapshot.data.analog[index])
                                                                            .then((value) {
                                                                          blocItem
                                                                              .fetchAnalogUpdate();
                                                                        });
                                                                      } else if (snapshot
                                                                              .data
                                                                              .analog[index]
                                                                              .cardCount ==
                                                                          1) {
                                                                        dataBase
                                                                            .deleteProducts(snapshot.data.analog[index].id)
                                                                            .then((value) {
                                                                          blocItem
                                                                              .fetchAnalogUpdate();
                                                                        });
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          29,
                                                                      width: 29,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppTheme
                                                                            .blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "assets/icons/remove.svg",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        snapshot.data.analog[index].cardCount.toString() +
                                                                            " " +
                                                                            translate("sht"),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              AppTheme.fontRubik,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              12,
                                                                          height:
                                                                              1.2,
                                                                          color:
                                                                              AppTheme.text_dark,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      if (snapshot
                                                                              .data
                                                                              .analog[
                                                                                  index]
                                                                              .cardCount <
                                                                          snapshot
                                                                              .data
                                                                              .analog[
                                                                                  index]
                                                                              .maxCount)
                                                                        snapshot
                                                                            .data
                                                                            .analog[
                                                                                index]
                                                                            .cardCount = snapshot
                                                                                .data.analog[index].cardCount +
                                                                            1;
                                                                      dataBase
                                                                          .updateProduct(snapshot
                                                                              .data
                                                                              .analog[index])
                                                                          .then((value) {
                                                                        blocItem
                                                                            .fetchAnalogUpdate();
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          29,
                                                                      width: 29,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppTheme
                                                                            .blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "assets/icons/add.svg",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                snapshot
                                                                    .data
                                                                    .analog[
                                                                        index]
                                                                    .cardCount = 1;
                                                                dataBase
                                                                    .saveProducts(snapshot
                                                                            .data
                                                                            .analog[
                                                                        index])
                                                                    .then(
                                                                        (value) {
                                                                  blocItem
                                                                      .fetchAnalogUpdate();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text: priceFormat.format(snapshot
                                                                              .data
                                                                              .analog[index]
                                                                              .price),
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                AppTheme.fontRubik,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize:
                                                                                14,
                                                                            height:
                                                                                1.2,
                                                                            color:
                                                                                AppTheme.white,
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              translate("sum"),
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                AppTheme.fontRubik,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                14,
                                                                            height:
                                                                                1.2,
                                                                            color:
                                                                                AppTheme.white,
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
                                            ),
                                          ),
                                        ),
                                        itemCount: snapshot.data.analog.length,
                                      ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    );
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
                            margin: EdgeInsets.only(top: 24, bottom: 24),
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
