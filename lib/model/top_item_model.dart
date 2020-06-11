import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TopItemModel {
  String name;
  String title;
  Color color;

  TopItemModel(this.name, this.title, this.color);

  static List<TopItemModel> topTitle = <TopItemModel>[
    TopItemModel(
      translate("home.your"),
      translate("home.karta"),
      Color(0xFF825AD7),
    ),
    TopItemModel(
      translate("home.look"),
      translate("home.pharmacy"),
      Color(0xFF27BDEC),
    ),
    TopItemModel(
      translate("home.karta"),
      translate("home.pharma"),
      Color(0xFF36CF86),
    ),
    TopItemModel(
      translate("home.set"),
      translate("home.question"),
      Color(0xFFEFA434),
    ),
  ];
}
