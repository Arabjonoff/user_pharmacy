import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/aptek_block.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class AddressAptekaListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaListScreenState();
  }
}

class _AddressAptekaListScreenState extends State<AddressAptekaListScreen> {
  DatabaseHelperApteka db = new DatabaseHelperApteka();

  @override
  Widget build(BuildContext context) {
    db.getAllProducts().then((value) => print(value.length));
    blocApteka.fetchAllApteka();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: StreamBuilder(
        stream: blocApteka.allApteka,
        builder: (context, AsyncSnapshot<List<AptekaModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 124,
                    margin: EdgeInsets.only(top: 16, left: 12, right: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 18, left: 14.5, right: 14.5),
                                child: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 3, left: 14.5, right: 14.5),
                                child: Text(
                                  translate("map.address"),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 21),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 14.5, right: 14.5),
                                              child: Text(
                                                snapshot.data[index].open,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.black_text,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 3,
                                                  left: 14.5,
                                                  right: 14.5),
                                              child: Text(
                                                translate("map.work"),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontWeight: FontWeight.normal,
                                                  color: AppTheme
                                                      .black_transparent_text,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 14.5, right: 14.5),
                                              child: Text(
                                                snapshot.data[index].number,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.black_text,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 3,
                                                  left: 14.5,
                                                  right: 14.5),
                                              child: Text(
                                                translate("auth.number_auth"),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontWeight: FontWeight.normal,
                                                  color: AppTheme
                                                      .black_transparent_text,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 27, right: 18, left: 18),
                            child: snapshot.data[index].fav
                                ? Icon(
                                    Icons.favorite,
                                    size: 24,
                                    color: AppTheme.red_fav_color,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    size: 24,
                                    color: AppTheme.arrow_catalog,
                                  ),
                          ),
                          onTap: () {
                            db.saveProducts(snapshot.data[index]);
                            setState(() {
                              snapshot.data[index].fav = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
              itemBuilder: (_, __) => Container(
                height: 124,
                margin: EdgeInsets.only(top: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              itemCount: 10,
            ),
          );
        },
      ),
    );
  }
}
