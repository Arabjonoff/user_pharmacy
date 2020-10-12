import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenProvider {
  ValueNotifier<String> cityName = ValueNotifier('Ташкент');

  Future<void> getCityName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("city") != null) {
      cityName.value = prefs.getString("city");
    } else {
      cityName.value = "Ташкент";
    }
  }
}
