import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/model/ramadan_model.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';
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

  static void setRamadan() {
    List<RamadanModel> list = [
      RamadanModel(
        id: 1,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 15, 4, 22),
      ),
      RamadanModel(
        id: 2,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 15, 19, 05),
      ),
      RamadanModel(
        id: 3,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 16, 4, 20),
      ),
      RamadanModel(
        id: 4,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 16, 19, 06),
      ),
      RamadanModel(
        id: 5,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 17, 4, 18),
      ),
      RamadanModel(
        id: 6,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 17, 19, 07),
      ),
      RamadanModel(
        id: 7,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 18, 4, 16),
      ),
      RamadanModel(
        id: 8,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 18, 19, 08),
      ),
      RamadanModel(
        id: 9,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 19, 4, 14),
      ),
      RamadanModel(
        id: 10,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 19, 19, 09),
      ),
      RamadanModel(
        id: 11,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 20, 4, 13),
      ),
      RamadanModel(
        id: 12,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 20, 19, 10),
      ),
      RamadanModel(
        id: 13,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 21, 4, 11),
      ),
      RamadanModel(
        id: 14,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 21, 19, 11),
      ),
      RamadanModel(
        id: 15,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 22, 4, 09),
      ),
      RamadanModel(
        id: 16,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 22, 19, 13),
      ),
      RamadanModel(
        id: 17,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 23, 4, 07),
      ),
      RamadanModel(
        id: 18,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 23, 19, 14),
      ),
      RamadanModel(
        id: 19,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 24, 4, 05),
      ),
      RamadanModel(
        id: 20,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 24, 19, 15),
      ),
      RamadanModel(
        id: 21,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 25, 4, 04),
      ),
      RamadanModel(
        id: 22,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 25, 19, 16),
      ),
      RamadanModel(
        id: 23,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 26, 4, 02),
      ),
      RamadanModel(
        id: 24,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 26, 19, 17),
      ),
      RamadanModel(
        id: 25,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 27, 4, 00),
      ),
      RamadanModel(
        id: 26,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 27, 19, 18),
      ),
      RamadanModel(
        id: 27,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 28, 3, 58),
      ),
      RamadanModel(
        id: 28,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 28, 19, 19),
      ),
      RamadanModel(
        id: 29,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 29, 3, 57),
      ),
      RamadanModel(
        id: 30,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 29, 19, 20),
      ),
      RamadanModel(
        id: 31,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 30, 3, 55),
      ),
      RamadanModel(
        id: 32,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 4, 30, 19, 21),
      ),
      RamadanModel(
        id: 33,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 1, 3, 53),
      ),
      RamadanModel(
        id: 34,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 1, 19, 22),
      ),
      RamadanModel(
        id: 35,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 2, 3, 51),
      ),
      RamadanModel(
        id: 36,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 2, 19, 23),
      ),
      RamadanModel(
        id: 37,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 3, 3, 50),
      ),
      RamadanModel(
        id: 38,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 3, 19, 24),
      ),
      RamadanModel(
        id: 39,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 4, 3, 48),
      ),
      RamadanModel(
        id: 40,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 4, 19, 25),
      ),
      RamadanModel(
        id: 41,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 5, 3, 46),
      ),
      RamadanModel(
        id: 42,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 5, 19, 26),
      ),
      RamadanModel(
        id: 43,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 6, 3, 45),
      ),
      RamadanModel(
        id: 44,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 6, 19, 27),
      ),
      RamadanModel(
        id: 45,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 7, 3, 43),
      ),
      RamadanModel(
        id: 46,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 7, 19, 28),
      ),
      RamadanModel(
        id: 47,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 8, 3, 42),
      ),
      RamadanModel(
        id: 48,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 8, 19, 29),
      ),
      RamadanModel(
        id: 49,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 9, 3, 40),
      ),
      RamadanModel(
        id: 50,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 9, 19, 31),
      ),
      RamadanModel(
        id: 51,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 10, 3, 39),
      ),
      RamadanModel(
        id: 52,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 10, 19, 32),
      ),
      RamadanModel(
        id: 53,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 11, 3, 37),
      ),
      RamadanModel(
        id: 54,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 11, 19, 33),
      ),
      RamadanModel(
        id: 55,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 12, 3, 36),
      ),
      RamadanModel(
        id: 56,
        title: "Title",
        message: "Message",
        dateTime: DateTime(2021, 5, 12, 19, 34),
      ),
    ];
    var dateTime = DateTime.now();
    for (int i = 0; i < list.length; i++) {
      if (dateTime.month < list[i].dateTime.month) {
        scheduleNotification(
          list[i].id,
          list[i].title,
          list[i].message,
          list[i].dateTime,
        );
      } else if (dateTime.day < list[i].dateTime.day) {
        scheduleNotification(
          list[i].id,
          list[i].title,
          list[i].message,
          list[i].dateTime,
        );
      } else if (dateTime.day == list[i].dateTime.day &&
          dateTime.hour < list[i].dateTime.hour) {
        scheduleNotification(
          list[i].id,
          list[i].title,
          list[i].message,
          list[i].dateTime,
        );
      }
    }
  }

  static Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime time,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id.toString(),
      title,
      title + " " + body,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      id,
      id % 2 == 0 ? "Iftorlik vaqti" : "Saharlik vaqti",
      "Bugun Toshkent vaqti bilan: " +
          format(time.hour) +
          ":" +
          format(time.minute),
      DateTime(time.year, time.month, time.day, time.hour, time.minute - 20),
      platformChannelSpecifics,
    );
  }

  static String format(int k) {
    if (k < 10) {
      return "0" + k.toString();
    } else {
      return k.toString();
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
