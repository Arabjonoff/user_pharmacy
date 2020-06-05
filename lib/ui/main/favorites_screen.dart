import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/database/database_helper_star.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/list/item_view_list.dart';

import '../../app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoritesScreenState();
  }
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Size size;
  List<ItemModel> itemStar = new List();
  DatabaseHelperStar dbStar = new DatabaseHelperStar();

  @override
  void initState() {
    dbStar.getAllProducts().then((products) {
      setState(() {
        products.forEach((i) {
          itemStar.add(ItemModel.fromMap(i));
        });
        print(products.length.toString() + "Star");
      });
    });
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
                      translate("star.name"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ItemViewList(itemStar),
          )
        ],
      ),
    );
  }
}
