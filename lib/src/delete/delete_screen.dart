import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DeleteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeleteScreenState();
  }
}

class _DeleteScreenState extends State<DeleteScreen> {
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
        child: Container(
          child: Center(
            child: GestureDetector(
              onTap: () async {
              //  var url = 'tel:*880*7864747#';
                var url = 'https://flutter.dev';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print("Could not launch $url");
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                height: 56,
                margin: EdgeInsets.only(left: 35, right: 35),
                decoration: BoxDecoration(
                  color: AppTheme.blue_app_color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    translate("update"),
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRoboto,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
