import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';

class BottomDialog {
  static void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value) {
      changeLocale(context, value);
    });
  }

  static void onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.title')),
        message: Text(translate('language.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.ru')),
            onPressed: () => Navigator.pop(context, 'ru'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.uz')),
            onPressed: () => Navigator.pop(context, 'uz'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }

  static void createBottomSheetHistory(BuildContext context) async {
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.downToUp,
                            child: LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.blue_app_color,
                        ),
                        height: 44,
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          top: 35,
                          bottom: 30,
                          left: 16,
                          right: 16,
                        ),
                        child: Center(
                          child: Text(
                            translate("dialog.enter"),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 17,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ),
//                    Container(
//                      child: Text(
//                        translate("dialog.register"),
//                        style: TextStyle(
//                          fontFamily: AppTheme.fontRoboto,
//                          fontSize: 13,
//                          fontWeight: FontWeight.normal,
//                          fontStyle: FontStyle.normal,
//                          color: AppTheme.blue_app_color,
//                        ),
//                      ),
//                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        translate("dialog.soglas"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.black_transparent_text,
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Text(
                        translate("dialog.danniy"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.black_text,
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
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

  static void createBottomSheetReadyOrder(BuildContext context) async {
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void mapBottom(
      LocationModel locationItem, BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                height: 300,
                color: AppTheme.white,
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
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12, top: 25),
                      width: double.infinity,
                      child: Text(
                        locationItem.address,
                        textAlign: TextAlign.start,
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
                      margin: EdgeInsets.only(left: 12, right: 12, top: 2),
                      width: double.infinity,
                      child: Text(
                        translate("map.address"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12, top: 29),
                      width: double.infinity,
                      child: Text(
                        locationItem.mode,
                        textAlign: TextAlign.start,
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
                      margin: EdgeInsets.only(left: 12, right: 12, top: 2),
                      width: double.infinity,
                      child: Text(
                        translate("map.work"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12, top: 29),
                      width: double.infinity,
                      child: Text(
                        locationItem.phone,
                        textAlign: TextAlign.start,
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
                      margin: EdgeInsets.only(left: 12, right: 12, top: 2),
                      width: double.infinity,
                      child: Text(
                        translate("auth.number_auth"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          fontStyle: FontStyle.normal,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
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
              ),
            );
          },
        );
      },
    );
  }
}
