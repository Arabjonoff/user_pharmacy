import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class RegionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegionScreenState();
  }
}

class _RegionScreenState extends State<RegionScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;
  String obj = "";

  List<RegionModel> users = new List();

  @override
  void initState() {
    _getMoreData();
    super.initState();
  }

  _RegionScreenState() {
    searchController.addListener(() {
      if (searchController.text != obj) {
        setState(() {
          users = new List();
          obj = searchController.text;
          isSearchText = true;
          _getMoreData();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
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
                            translate("menu.city"),
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
          )),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            height: 36,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: AppTheme.black_transparent,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: new Icon(
                            Icons.search,
                            size: 24,
                            color: AppTheme.notWhite,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 36,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                cursorColor: AppTheme.notWhite,
                                style: TextStyle(
                                  color: AppTheme.black_text,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: translate("search_real"),
                                  hintStyle: TextStyle(
                                    color: AppTheme.notWhite,
                                    fontSize: 15,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                controller: searchController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("city", users[index].name);
                          prefs.commit();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 9, bottom: 2, left: 12, right: 12),
                          child: Text(
                            users[index].name,
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 15,
                              color: AppTheme.black_text,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("city", users[index].name);
                          prefs.commit();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            users[index].parentName,
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 13,
                              color: AppTheme.black_transparent_text,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setString("city", users[index].name);
                            prefs.commit();
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(
                              users[index].parentName,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 13,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: AppTheme.black_linear_category,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _getMoreData() async {
    var response = Repository().fetchRegions(obj);

    response.then((value) => {
          setState(() {
            users = new List();
            users = value;
          }),
        });
  }
}
