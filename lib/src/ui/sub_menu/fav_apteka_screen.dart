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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.arrow_examp_back,
            padding: EdgeInsets.all(13),
            child: SvgPicture.asset("assets/images/arrow_back.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
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
                      margin: EdgeInsets.only(top: 16, left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data[index].name,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_text,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  child: Container(
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
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6, left: 16, right: 16),
                            child: Text(
                              snapshot.data[index].address,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_text,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 19, left: 16, right: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data[index].open,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_text,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data[index].number,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 3, bottom: 20, left: 16, right: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    translate("map.work"),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_transparent_text,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: Text(
                                    translate("auth.number_auth"),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_transparent_text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
