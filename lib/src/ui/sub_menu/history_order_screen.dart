import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';

import '../../app_theme.dart';

class HistoryOrderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryOrderScreenState();
  }
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
                          translate("menu.history"),
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
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 153,
              width: 153,
              child: SvgPicture.asset("assets/images/empty_history.svg"),
            ),
            Container(
              margin: EdgeInsets.only(top: 25, left: 16, right: 16),
              alignment: Alignment.center,
              child: Text(
                translate("menu_sub.history_title"),
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
                translate("menu_sub.history_message"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_transparent_text,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: AppTheme.blue_app_color,
                  width: 2.0,
                ),
              ),
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Text(
                translate("favourite.all_catalog"),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontSFProDisplay,
                  fontSize: 15,
                  color: AppTheme.blue_app_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
