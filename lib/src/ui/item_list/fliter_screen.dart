import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/ui/item_list/filter_item_screen.dart';

import '../../app_theme.dart';

class FilterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterScreenState();
  }
}

List<FilterResults> internationalNameExamp = new List();
List<FilterResults> manufacturerExamp = new List();
List<FilterResults> unitExamp = new List();

class _FilterScreenState extends State<FilterScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("item.filter"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 36,
                        width: 48,
                        color: AppTheme.arrow_examp_back,
                        margin: EdgeInsets.only(right: 5),
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.arrow_back,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                                "assets/images/arrow_close.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 30),
              child: Text(
                translate("item.price"),
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_transparent_text,
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(top: 24, left: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppTheme.auth_login,
                        border: Border.all(
                          color: AppTheme.auth_border,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 12, right: 12),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.black_text,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            labelText: translate('ot'),
                            labelStyle: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6D7885),
                              fontSize: 11,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.auth_login,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.auth_login,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(top: 24, left: 15, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppTheme.auth_login,
                        border: Border.all(
                          color: AppTheme.auth_border,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 12, right: 12),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.black_text,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            labelText: translate('do'),
                            labelStyle: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6D7885),
                              fontSize: 11,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.auth_login,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.auth_login,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: FilterItemScreen(1),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 16),
                height: 56,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: AppTheme.white,
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.only(top: 6, bottom: 6),
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    translate("release"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                      fontFamily: AppTheme.fontRoboto,
                                    ),
                                  ),
                                  Text(
                                    unitExamp.length.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                      fontFamily: AppTheme.fontRoboto,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.arrow_catalog,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      height: 1,
                      color: AppTheme.black_linear_category,
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: FilterItemScreen(2),
                  ),
                );
              },
              child: Container(
                height: 56,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: AppTheme.white,
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.only(top: 6, bottom: 6),
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    translate("manifac"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                      fontFamily: AppTheme.fontRoboto,
                                    ),
                                  ),
                                  Text(
                                    manufacturerExamp.length.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                      fontFamily: AppTheme.fontRoboto,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.arrow_catalog,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      height: 1,
                      color: AppTheme.black_linear_category,
                    )
                  ],
                ),
              ),
            ),
//            GestureDetector(
//              onTap: (){
//
//              },
//              child: Container(
//                height: 49,
//                child:  Column(
//                  children: <Widget>[
//                    Container(
//                      color: AppTheme.white,
//                      child: Container(
//                        height: 48,
//                        padding: EdgeInsets.only(top: 6, bottom: 6),
//                        margin: EdgeInsets.only(left: 15, right: 15),
//                        child: Row(
//                          children: <Widget>[
//                            Expanded(
//                              child: Text(
//                                translate("country"),
//                                style: TextStyle(
//                                  fontSize: 15,
//                                  fontWeight: FontWeight.normal,
//                                  color: AppTheme.black_catalog,
//                                  fontFamily: AppTheme.fontRoboto,
//                                ),
//                              ),
//                            ),
//                            Icon(
//                              Icons.arrow_forward_ios,
//                              size: 16,
//                              color: AppTheme.arrow_catalog,
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(
//                        left: 8,
//                        right: 8,
//                      ),
//                      height: 1,
//                      color: AppTheme.black_linear_category,
//                    )
//                  ],
//                ),
//              ),
//            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: FilterItemScreen(3),
                  ),
                );
              },
              child: Container(
                height: 56,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: AppTheme.white,
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.only(top: 6, bottom: 6),
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    translate("mnn"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                      fontFamily: AppTheme.fontRoboto,
                                    ),
                                  ),
                                  Text(
                                    internationalNameExamp.length.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                      fontFamily: AppTheme.fontRoboto,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.arrow_catalog,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      height: 1,
                      color: AppTheme.black_linear_category,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              height: 1,
              color: AppTheme.black_linear_category,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 33,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: Text(
                    translate("apply"),
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 17,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
