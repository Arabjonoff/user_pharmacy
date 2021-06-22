import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_theme.dart';

class UniversalScreen extends StatefulWidget {
  final String title;
  final String uri;

  UniversalScreen({this.title, this.uri});

  @override
  State<StatefulWidget> createState() {
    return _UniversalScreenState();
  }
}

class _UniversalScreenState extends State<UniversalScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Container(
            height: 20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppTheme.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  color: AppTheme.white,
                  margin: EdgeInsets.only(right: 4, top: 4, left: 12),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    child: Center(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.text_dark,
                          fontFamily: AppTheme.fontRubik,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    color: AppTheme.white,
                    margin: EdgeInsets.only(right: 12, top: 4, left: 4),
                    child: Center(
                      child: Container(
                        height: 24,
                        width: 24,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(
                          "assets/images/arrow_close.svg",
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: WebView(
                initialUrl: widget.uri,
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
