import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  Size size;


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: <Widget>[
          Container(
            height: 80,
            width: size.width,
            color: AppTheme.red_app_color,
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 15),
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  translate("main.menu"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 56),
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    var localizationDelegate =
                        LocalizedApp.of(context).delegate;
                    localizationDelegate.changeLocale(Locale("en_US"));
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('language', 'en_US');
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                translate("language.en"),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var localizationDelegate =
                        LocalizedApp.of(context).delegate;
                    localizationDelegate.changeLocale(Locale("ru"));
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('language', 'ru');
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                translate("language.ru"),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var localizationDelegate =
                        LocalizedApp.of(context).delegate;
                    localizationDelegate.changeLocale(Locale("uz"));
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('language', 'uz');
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                translate("language.uz"),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "position.toString()",
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "position.toString()",
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "position.toString()",
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "position.toString()",
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "position.toString()",
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.red_app_color,
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        height: 48,
                        color: AppTheme.white,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 35),
                  child: Center(
                    child: Text(
                      translate("menu.help"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
