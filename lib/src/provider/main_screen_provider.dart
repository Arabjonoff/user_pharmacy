import 'package:flutter/material.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenProvider extends ChangeNotifier {
  String _city;
  DatabaseHelper databaseHelper = new DatabaseHelper();

  Future<void> checkItemCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("city") != null) {
      _city = prefs.getString("city");
    } else {
      _city = "Ташкент";
    }
  }

  String get city => _city;
}
