import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/database/database_helper_card.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/list/item_view_list.dart';
import 'package:pharmacy/ui/main/card/card_empty_screen.dart';

import '../../../app_theme.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

class _CardScreenState extends State<CardScreen> {
  Size size;

  DatabaseHelperCard dbCard = new DatabaseHelperCard();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
      body: new FutureBuilder<List<ItemModel>>(
        future: dbCard.getProdu(),
        builder: (context, snapshot) {
          List<ItemModel> data = snapshot.data;
          if (data == null) {
            return Container(
              height: size.height - 80,
              width: size.width,
              child: Center(
                child: Text("error"),
              ),
            );
          } else {
            return data.length == 0
                ? CardEmptyScreen()
                : Container(
                    height: size.height - 80,
                    width: size.width,
                    child: ItemViewList(snapshot.data),
                  );
          }
        },
      ),
    );
  }
}
