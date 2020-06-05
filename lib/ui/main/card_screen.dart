import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/database/database_helper_card.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/list/item_view_list.dart';

import '../../app_theme.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

class _CardScreenState extends State<CardScreen> {
  Size size;
  List<ItemModel> itemCard = new List();
  DatabaseHelperCard dbCard = new DatabaseHelperCard();

  @override
  void initState() {
//    dbCard.getAllProducts().then((products) {
//      setState(() {
//        products.forEach((i) {
//          itemCard.add(ItemModel.fromMap(i));
//        });
//      });
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: <Widget>[
          Container(
            height: 80,
            width: size.width,
            color: AppTheme.red_app_color,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 24, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      translate("card.name"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ItemViewList(itemCard),
          )
        ],
      ),
    );
  }
}
