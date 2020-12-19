import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:rxbus/rxbus.dart';

import '../../../app_theme.dart';

class CardEmptyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardEmptyScreenState();
  }
}

class _CardEmptyScreenState extends State<CardEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 153,
            width: 153,
            child: SvgPicture.asset("assets/images/card_empty.svg"),
          ),
          Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25),
            alignment: Alignment.center,
            child: Text(
              translate("card.empty_name"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: AppTheme.black_text,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4, left: 25, right: 25),
            child: Text(
              translate("card.empty_title"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontRoboto,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: AppTheme.black_transparent_text,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW");
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: AppTheme.blue_app_color,
                  width: 2.0,
                ),
              ),
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.only(top: 30),
              child: Text(
                translate("card.all_catalog"),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontSFProDisplay,
                  fontSize: 15,
                  color: AppTheme.blue_app_color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
