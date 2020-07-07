import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';

import '../../app_theme.dart';

class FavAptekaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavAptekaScreenState();
  }
}

class _FavAptekaScreenState extends State<FavAptekaScreen> {
  DatabaseHelperApteka db = new DatabaseHelperApteka();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
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
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: AppTheme.blue_app_color,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          translate("menu.address_apteka"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_text,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontCommons,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<AptekaModel>>(
        future: db.getProduct(),
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
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 153,
                        width: 153,
                        child:
                            SvgPicture.asset("assets/images/empty_apteka.svg"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25, left: 16, right: 16),
                        alignment: Alignment.center,
                        child: Text(
                          translate("map.lov_apt_mes"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                        child: Text(
                          translate("map.lov_apt_title"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.black_transparent_text,
                          ),
                        ),
                      ),
//                      Container(
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10.0),
//                          border: Border.all(
//                            color: AppTheme.blue_app_color,
//                            width: 2.0,
//                          ),
//                        ),
//                        padding: EdgeInsets.all(15.0),
//                        margin: EdgeInsets.only(top: 30, left: 16, right: 16),
//                        child: Text(
//                          translate("map.lov_apt_cat"),
//                          style: TextStyle(
//                            fontWeight: FontWeight.w500,
//                            fontFamily: AppTheme.fontSFProDisplay,
//                            fontSize: 15,
//                            color: AppTheme.blue_app_color,
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 200,
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
                                      fontSize: 14,
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.black_text,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 3, left: 14.5, right: 14.5),
                                  child: Text(
                                    translate("name"),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_transparent_text,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 14.5, right: 14.5),
                                  child: Text(
                                    snapshot.data[index].address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.black_text,
                                    ),
                                    maxLines: 2,
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
                                                    fontSize: 14,
                                                    fontFamily: AppTheme.fontRoboto,
                                                    fontWeight: FontWeight.w500,
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
                                                    fontFamily: AppTheme.fontRoboto,
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
                                                    fontSize: 14,
                                                    fontFamily: AppTheme.fontRoboto,
                                                    fontWeight: FontWeight.w500,
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
                                                    fontFamily: AppTheme.fontRoboto,
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
                              margin: EdgeInsets.only(top: 27, right: 18, left: 18),
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
                              if (!snapshot.data[index].fav) {
                                db.saveProducts(snapshot.data[index]);
                                setState(() {
                                  snapshot.data[index].fav = true;
                                });
                              } else {
                                db.deleteProducts(snapshot.data[index].id);
                                setState(() {
                                  snapshot.data[index].fav = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
