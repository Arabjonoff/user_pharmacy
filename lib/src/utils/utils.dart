import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Utils {
  static String baseUrl = "https://api.gopharm.uz";

  //static String baseUrl = "https://test.gopharm.uz";
  static String baseUrlSocket = "wss://api.gopharm.uz/ws/";

  static Future<void> saveData(int userId, String name, String surname,
      String birthday, String gender, String token, String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId', userId);
    prefs.setString('name', name);
    prefs.setString('surname', surname);
    prefs.setString('birthday', birthday);
    prefs.setString('gender', gender);
    prefs.setString('token', token);
    prefs.setString('number', number);
  }

  static Future<void> saveCashBack(double cashBack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('cashBack', cashBack);
  }

  static Future<void> saveFirstOpen(String string) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstOpen', string);
  }

  static Future<double> getCashBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("cashBack");
  }

  static Future<void> saveRegion(
      int id, String city, double lat, double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cityId', id);
    prefs.setString('city', city);
    prefs.setDouble('coordLat', lat);
    prefs.setDouble('coordLng', lng);
  }

  static Future<void> saveLocation(double lat, double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('coordLat', lat);
    prefs.setDouble('coordLng', lng);
  }

  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<int> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> saveDeviceData(Map<String, dynamic> deviceData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final msg = jsonEncode(deviceData);
    prefs.setString("deviceData", msg);
    //prefs.commit();
  }

  static String numberFormat(String number) {
    String s = "+";
    if (number.length == 12) {
      for (int i = 0; i < number.length; i++) {
        s += number[i];
        if (i == 2 || i == 4 || i == 7 || i == 9) {
          s += " ";
        }
      }
      return s;
    } else {
      return number;
    }
  }

  static Future<String> scanBarcodeNormal() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "Flash on",
          "flash_off": "Flash off",
        },
        restrictFormat: [
          ...BarcodeFormat.values.toList()
            ..removeWhere((e) => e == BarcodeFormat.unknown)
        ],
        useCamera: -1,
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 0.0,
          useAutoFocus: true,
        ),
      );
      var result = await BarcodeScanner.scan(options: options);
      if (result.type.name == "Cancelled")
        return "-1";
      else
        return result.rawContent;
    } on PlatformException catch (e) {
      print(e.toString());
      return "-1";
    }
  }

  static void showWitter(BuildContext context, String text) {
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
                    margin: EdgeInsets.only(top: 12),
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
                    fontFamily: AppTheme.fontRoboto,
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
                      fontFamily: AppTheme.fontRoboto,
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
                          fontFamily: AppTheme.fontRoboto,
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
}
