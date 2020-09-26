import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  //static String BASE_URL = "http://185.183.243.77";
  static String BASE_URL = "https://api.gopharm.uz";
  //static String BASE_URL = "https://test.gopharm.uz";
  static String BASE_URL_SOCET = "wss://api.gopharm.uz/ws/";

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
    prefs.commit();
  }

  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.commit();
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

  static Future<String> scanBarcodeNormal() async {
    try {
      return await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on FormatException {
      return '';
    }
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
