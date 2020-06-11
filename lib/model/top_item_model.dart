import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TopItemModel {
  String name;
  String title;
  String image;

  TopItemModel(this.name, this.title, this.image);

  static List<TopItemModel> topTitle = <TopItemModel>[
    TopItemModel(
      translate("home.your"),
      translate("home.karta"),
      "assets/images/card.png",
    ),
    TopItemModel(
      translate("home.look"),
      translate("home.pharmacy"),
      "assets/images/card2.png",
    ),
    TopItemModel(
      translate("home.karta"),
      translate("home.pharma"),
      "assets/images/card3.png",
    ),
    TopItemModel(
      translate("home.set"),
      translate("home.question"),
      "assets/images/card4.png",
    ),
  ];
}
