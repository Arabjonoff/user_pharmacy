import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/api/item_model.dart';
import 'package:pharmacy/ui/main/favorite/favorite_empty_screen.dart';
import 'package:pharmacy/ui/view/item_view.dart';

import '../../../app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoritesScreenState();
  }
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Size size;
  int count = 0;
  int allCount = 0;

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1.0,
            backgroundColor: AppTheme.white,
            brightness: Brightness.light,
            title: Container(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          translate("main.favourite"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_text,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontCommons,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          translate(
                            count.toString() + " " + translate("item.tovar"),
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_transparent_text,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: FutureBuilder<List<ItemResult>>(
        future: dataBase.getProdu(false),
        builder: (context, snapshot) {
          allCount = 0;
          var data = snapshot.data;
          if (data == null) {
            return Container(
              child: Center(
                child: Text("error"),
              ),
            );
          }
          count = data.length;
          for (int i = 0; i < data.length; i++) {
            allCount += data[i].cardCount;
          }
          return data.length == 0
              ? FavoriteEmptyScreen()
              : ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ItemView(data[index]);
            },
          );
        },
      ),
    );
  }
}
