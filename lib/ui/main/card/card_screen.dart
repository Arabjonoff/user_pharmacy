import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/view/item_view.dart';

import '../../../app_theme.dart';
import 'card_empty_screen.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

int count = 0;

class _CardScreenState extends State<CardScreen> {
  Size size;

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.green_app_color,
        title: Container(
          width: size.width,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              translate("card.name"),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.background,
      body: FutureBuilder<List<ItemModel>>(
        future: dataBase.getProdu(true),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return Container(
              child: Center(
                child: Text("error"),
              ),
            );
          }
          return data.length == 0
              ? CardEmptyScreen()
              : Container(
                  height: size.height - 80,
                  width: size.width,
                  child: ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ItemView(data[index]);
                    },
                  ),
                  //child: ItemView(snapshot.data),
                );
        },
      ),
    );
  }
}
