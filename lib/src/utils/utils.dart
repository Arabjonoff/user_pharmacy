import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Utils {
  //static String baseUrl = "https://api.gopharm.uz";

  static String baseUrl = "https://test.gopharm.uz";

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
    int id,
    String city,
    double lat,
    double lng,
  ) async {
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
  }

  static String dateFormat(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return format(dateTime.day) +
            " " +
            translate("month.january") +
            " " +
            dateTime.year.toString();
        break;
      case 2:
        return format(dateTime.day) +
            " " +
            translate("month.february") +
            " " +
            dateTime.year.toString();
        break;
      case 3:
        return format(dateTime.day) +
            " " +
            translate("month.march") +
            " " +
            dateTime.year.toString();
        break;
      case 4:
        return format(dateTime.day) +
            " " +
            translate("month.april") +
            " " +
            dateTime.year.toString();
        break;
      case 5:
        return format(dateTime.day) +
            " " +
            translate("month.may") +
            " " +
            dateTime.year.toString();
        break;
      case 6:
        return format(dateTime.day) +
            " " +
            translate("month.june") +
            " " +
            dateTime.year.toString();
        break;
      case 7:
        return format(dateTime.day) +
            " " +
            translate("month.july") +
            " " +
            dateTime.year.toString();
        break;
      case 8:
        return format(dateTime.day) +
            " " +
            translate("month.august") +
            " " +
            dateTime.year.toString();
        break;
      case 9:
        return format(dateTime.day) +
            " " +
            translate("month.september") +
            " " +
            dateTime.year.toString();
        break;
      case 10:
        return format(dateTime.day) +
            " " +
            translate("month.october") +
            " " +
            dateTime.year.toString();
        break;
      case 11:
        return format(dateTime.day) +
            " " +
            translate("month.november") +
            " " +
            dateTime.year.toString();
        break;
      case 12:
        return format(dateTime.day) +
            " " +
            translate("month.december") +
            " " +
            dateTime.year.toString();
        break;
      default:
        return format(dateTime.day) +
            " " +
            translate("month.december") +
            " " +
            dateTime.year.toString();
    }
  }

  static String numberFormat(String number) {
    if (number == null) {
      return "";
    } else {
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
    } on PlatformException catch (_) {
      return "-1";
    }
  }

  static String format(int k) {
    if (k < 10) {
      return "0" + k.toString();
    } else {
      return k.toString();
    }
  }
}
