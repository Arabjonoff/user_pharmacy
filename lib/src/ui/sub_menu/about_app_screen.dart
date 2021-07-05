import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutAppScreenState();
  }
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
            padding: EdgeInsets.all(13),
            child: SvgPicture.asset("assets/icons/arrow_left_blue.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        elevation: 4.0,
        shadowColor: Color.fromRGBO(110, 120, 146, 0.1),
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("menu.about_title"),
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.2,
                color: AppTheme.text_dark,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 155,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/img/about_image.png",
                      height: 50,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  translate("menu.about_title"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    height: 1.2,
                    color: AppTheme.text_dark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  translate("about_app"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.6,
                    color: AppTheme.text_dark,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var url = "tel:712050888";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(
                top: 16,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.blue.withOpacity(0.2),
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/icons/phone.svg"),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate("home.call_center"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          height: 1.2,
                          color: AppTheme.textGray,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "+998 (71) 205-0-888",
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 1.1,
                          color: AppTheme.text_dark,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(width: 16),
                  SvgPicture.asset("assets/icons/arrow_right_grey.svg")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
