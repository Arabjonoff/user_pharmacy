import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/database/database_helper_star.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/list/item_view_list.dart';

import '../../../app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoritesScreenState();
  }
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Size size;

  DatabaseHelperStar dbStar = new DatabaseHelperStar();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.red_app_color,
        title: Text(
          translate("star.name"),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: AppTheme.background,
      body: new FutureBuilder<List<ItemModel>>(
        future: dbStar.getProdu(),
        builder: (context, snapshot) {
          return ItemViewList(snapshot.data);
        },
      ),
    );
  }
}
