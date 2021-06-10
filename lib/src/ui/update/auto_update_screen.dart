import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class AutoUpdateScreen extends StatefulWidget {
 final String package;
 final String desk;

  AutoUpdateScreen({this.package, this.desk});

  @override
  State<StatefulWidget> createState() {
    return _AutoUpdateScreenState();
  }
}

class _AutoUpdateScreenState extends State<AutoUpdateScreen> {
  bool isDesk = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Container(
              height: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.item_navigation,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Center(
                child: SvgPicture.asset("assets/images/go_update.svg"),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isDesk = !isDesk;
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translate("auto_update.desk"),
                      style: TextStyle(
                        color: AppTheme.black_transparent_text,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        height: 1.47,
                        fontFamily: AppTheme.fontRubik,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(width: 12),
                    isDesk
                        ? SvgPicture.asset("assets/images/arrow_bottom.svg")
                        : SvgPicture.asset("assets/images/arrow_right.svg")
                  ],
                ),
              ),
            ),
            isDesk
                ? Container(
                    margin: EdgeInsets.only(left: 32, top: 12, right: 32),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.desk,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          height: 1.6,
                          color: AppTheme.black_text,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppTheme.fontRubik
                        ),
                      ),
                    ),
                  )
                : Container(),
            GestureDetector(
              onTap: () async {
                if (Platform.isAndroid) {
                  var url =
                      'https://play.google.com/store/apps/details?id=uz.go.pharm';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                } else if (Platform.isIOS) {
                  var url =
                      'https://apps.apple.com/uz/app/gopharm-online/id1527930423';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              child: Container(
                width: 175,
                margin: EdgeInsets.only(top: 24),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  border: Border.all(color: AppTheme.blue_app_color, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    translate("auto_update.button"),
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRubik,
                      color: AppTheme.blue_app_color,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
