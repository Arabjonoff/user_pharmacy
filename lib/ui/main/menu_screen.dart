import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
              margin: EdgeInsets.only(top: 24, left: 15, bottom: 24),
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  translate("main.menu"),
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80),
            child: ListView(
              children: <Widget>[
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Container(

                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: DottedBorder(
                            color: Colors.black,
                            strokeWidth: 1,
                            child: FlutterLogo(size: 36),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
