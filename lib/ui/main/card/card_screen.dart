import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/api/item_model.dart';
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
  int count = 0;
  int allCount = 0;

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 64),
            child: FutureBuilder<List<ItemResult>>(
              future: dataBase.getProdu(true),
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
                    ? CardEmptyScreen()
                    : ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ItemView(data[index]);
                            },
                          ),
                          Container(
                            child: Text(
                              translate("card.my_card"),
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black_text,
                              ),
                            ),
                            margin:
                                EdgeInsets.only(top: 24, left: 16, right: 16),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 23,
                              left: 16,
                              right: 16,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  translate("card.all_card"),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  translate(allCount.toString()),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 18,
                              left: 16,
                              right: 16,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  translate("card.tovar_sum"),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  translate("50 000" + translate("sum")),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 26,
                              left: 16,
                              right: 16,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  translate("card.all"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  translate("50 000" + translate("sum")),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: AppTheme.blue_app_color,
                              ),
                              height: 44,
                              width: size.width,
                              margin: EdgeInsets.only(
                                top: 47,
                                bottom: 47,
                                left: 12,
                                right: 12,
                              ),
                              child: Center(
                                child: Text(
                                  translate("card.buy"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 17,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
          Container(
            height: 1,
            color: AppTheme.black_linear_category,
            margin: EdgeInsets.only(top: 87),
          ),
          Container(
            color: AppTheme.white,
            height: 63,
            width: size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translate("card.name"),
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
    );
  }
}
