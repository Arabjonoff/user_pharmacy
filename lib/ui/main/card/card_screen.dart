import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/database/database_helper_card.dart';
import 'package:pharmacy/database/database_helper_star.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/main/card/card_empty_screen.dart';
import 'package:pharmacy/ui/view/item_view.dart';

import '../../../app_theme.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

int count = 0;

class _CardScreenState extends State<CardScreen> {
  Size size;

  List<ItemModel> itemStar = new List();
  List<ItemModel> itemCard = new List();

  DatabaseHelperCard dbCard = new DatabaseHelperCard();
  DatabaseHelperStar dbStar = new DatabaseHelperStar();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    dbCard.getAllProducts().then((products) {
      itemCard = new List();
      products.forEach((products) {
        itemCard.add(ItemModel.fromMap(products));
      });

      dbStar.getAllProducts().then((products) {
        setState(() {
          products.forEach((products) {
            itemStar.add(ItemModel.fromMap(products));
          });
          for (var i = 0; i < itemCard.length; i++) {
            for (var j = 0; j < itemStar.length; j++) {
              if (itemCard[i].id == itemStar[j].id) {
                itemCard[i].favourite = true;
              }
            }
          }
        });
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.red_app_color,
        title: Text(
          translate("card.name"),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: AppTheme.background,
      body: itemCard.length == 0
          ? CardEmptyScreen()
          : Container(
              height: size.height - 80,
              width: size.width,
              child: ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                itemCount: itemCard.length,
                itemBuilder: (context, index) {
                  return new ItemView(itemCard[index]);
                },
              ),
              //child: ItemView(snapshot.data),
            ),
    );
  }
}
