import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class LanguageScreen extends StatefulWidget {
  String language;

  LanguageScreen(this.language);

  @override
  State<StatefulWidget> createState() {
    return _LanguageScreenState();
  }
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool one, two, three;

  @override
  void initState() {
    if (widget.language == "ru") {
      one = false;
      two = true;
      three = false;
    } else if (widget.language == "uz") {
      one = true;
      two = false;
      three = false;
    } else {
      one = false;
      two = false;
      three = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1.0,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
          title: Container(
            height: 63,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      color: AppTheme.arrow_examp_back,
                      child: Center(
                        child: Container(
                          height: 24,
                          width: 24,
                          padding: EdgeInsets.all(3),
                          child:
                          SvgPicture.asset("assets/images/arrow_back.svg"),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          translate("menu.language"),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: GestureDetector(
                      child: Text(
                        translate("auth.save"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          color: AppTheme.blue_app_color,
                        ),
                      ),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var localizationDelegate =
                            LocalizedApp.of(context).delegate;
                        if (one) {
                          prefs.setString("language", "uz");
                          prefs.commit();
                          localizationDelegate.changeLocale(Locale("uz"));
                          Navigator.pop(context, 'uz');
                        } else if (two) {
                          localizationDelegate.changeLocale(Locale("ru"));
                          prefs.setString("language", "ru");
                          prefs.commit();
                          Navigator.pop(context, 'ru');
                        } else {
                          localizationDelegate.changeLocale(Locale("en_US"));
                          prefs.setString("language", "en_US");
                          prefs.commit();
                          Navigator.pop(context, 'en_US');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                one = true;
                two = false;
                three = false;
              });
            },
            child: Container(
              height: 47,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      translate("language.uz"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                      ),
                    ),
                  ),
                  one
                      ? Container(
                          margin: EdgeInsets.only(left: 5, top: 5),
                          child: Icon(
                            Icons.check,
                            color: AppTheme.blue_app_color,
                            size: 24,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          Container(
            color: AppTheme.black_linear_category,
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                one = false;
                two = true;
                three = false;
              });
            },
            child: Container(
              height: 47,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      translate("language.ru"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                      ),
                    ),
                  ),
                  two
                      ? Container(
                          margin: EdgeInsets.only(left: 5, top: 5),
                          child: Icon(
                            Icons.check,
                            color: AppTheme.blue_app_color,
                            size: 24,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          Container(
            color: AppTheme.black_linear_category,
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                one = false;
                two = false;
                three = true;
              });
            },
            child: Container(
              height: 47,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      translate("language.en"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                      ),
                    ),
                  ),
                  three
                      ? Container(
                          margin: EdgeInsets.only(left: 5, top: 5),
                          child: Icon(
                            Icons.check,
                            color: AppTheme.blue_app_color,
                            size: 24,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
