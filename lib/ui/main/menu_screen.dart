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
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 75,
                              width: 75,
                              child: Stack(
                                children: <Widget>[
                                  Image.asset("assets/images/circle_green.png"),
                                  Container(
                                    padding: EdgeInsets.all(25),
                                    child: Image.asset(
                                        "assets/images/chatting.png"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Center(
                                child: Text(
                                  translate("menu.write"),
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Center(
                                child: Text(
                                  translate("menu.chat"),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 75,
                              width: 75,
                              child: Stack(
                                children: <Widget>[
                                  Image.asset("assets/images/circle_green.png"),
                                  Container(
                                    padding: EdgeInsets.all(25),
                                    child: Image.asset(
                                        "assets/images/phone_green.png"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Center(
                                child: Text(
                                  translate("menu.call"),
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Center(
                                child: Text(
                                  translate("menu.hotline"),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 75,
                              width: 75,
                              child: Stack(
                                children: <Widget>[
                                  Image.asset("assets/images/circle_green.png"),
                                  Container(
                                    padding: EdgeInsets.all(25),
                                    child: Image.asset(
                                        "assets/images/question_green.png"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Center(
                                child: Text(
                                  translate("menu.faq"),
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 125,
                              child: Center(
                                child: Text(
                                  translate("menu.ques_answ"),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
