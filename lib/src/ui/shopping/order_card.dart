import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class OrderCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderCardScreenState();
  }
}

class CheckboxList {
  String number;
  int index;

  CheckboxList({this.number, this.index});
}

class _OrderCardScreenState extends State<OrderCardScreen> {
  String radioItemHolder = 'Наличные';
  int id = 1;

  List<CheckboxList> nList = [
    CheckboxList(
      index: 1,
      number: "Наличные",
    ),
    CheckboxList(
      index: 2,
      number: "8600 57** **** 3285",
    ),
    CheckboxList(
      index: 3,
      number: "Добавить карту",
    ),
  ];

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
        child: ListView(
          children: [
            Container(
              height: 26,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("orders.chechout"),
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontFamily: AppTheme.fontCommons,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.black_text,
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
                        height: 24,
                        width: 24,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.arrow_back,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(right: 16),
                        child:
                            SvgPicture.asset("assets/images/arrow_close.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
                left: 16,
              ),
              child: Text(
                translate("orders.productMethod"),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: AppTheme.fontRoboto,
                  fontStyle: FontStyle.normal,
                  color: AppTheme.black_text,
                ),
              ),
            ),
            Container(
              height: 36,
              margin: EdgeInsets.only(
                right: 16,
                top: 24,
                left: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.white,
                          border: Border.all(
                            color: AppTheme.arrow_catalog,
                            width: 2.0,
                          ),
                        ),
                        height: 36,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            translate("orders.pickup"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppTheme.black_text,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.white,
                          border: Border.all(
                            color: AppTheme.blue_app_color,
                            width: 2.0,
                          ),
                        ),
                        height: 36,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            translate("orders.courier"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppTheme.black_text,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.only(
                right: 16,
                top: 24,
                left: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: [],
                ),
              ),
            ),
            Container(
              height: 24,
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Row(
                children: [
                  Text(
                    translate("orders.your_data"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black_text,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      translate("orders.edit"),
                      style: TextStyle(
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.blue_app_color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 26, left: 16, right: 16),
              child: Text(
                "Shahboz Turonov",
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: AppTheme.black_catalog),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3, left: 16, right: 16),
              child: Text(
                translate("orders.name"),
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: AppTheme.black_transparent_text),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 21, left: 16, right: 16),
              child: Text(
                "+998943293406",
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: AppTheme.black_catalog),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3, left: 16, right: 16),
              child: Text(
                translate("orders.number"),
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: AppTheme.black_transparent_text),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 35, left: 16, right: 16),
              child: Text(
                translate("orders.promocode"),
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    color: AppTheme.black_catalog),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24, left: 16, right: 16),
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 12),
                          child: Text(
                            translate("orders.promocode"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              color: AppTheme.black_catalog,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3, left: 12),
                          child: Text(
                            translate("orders.promocode"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              color: AppTheme.black_transparent_text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppTheme.white,
                      border: Border.all(
                        color: AppTheme.blue_app_color,
                        width: 2.0,
                      ),
                    ),
                    height: 36,
                    width: 36,
                    child: Icon(
                      Icons.add,
                      color: AppTheme.blue_app_color,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Text(
                translate("orders.type"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: AppTheme.black_catalog,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: nList
                  .map((data) => RadioListTile(
                        title: Text(
                          "${data.number}",
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRoboto,
                            color: AppTheme.black_text,
                          ),
                        ),
                        activeColor: AppTheme.blue_app_color,
                        groupValue: id,
                        value: data.index,
                        onChanged: (val) {
                          setState(() {
                            radioItemHolder = data.number;
                            id = data.index;
                          });
                        },
                      ))
                  .toList(),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 24,
                left: 16,
                right: 16,
              ),
              child: Text(
                translate("orders.type_payment"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: AppTheme.black_catalog,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 23,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Text(
                    translate("card.all_card"),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_transparent_text,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    translate(5.toString()),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_transparent_text,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 18,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Text(
                    translate("card.tovar_sum"),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_transparent_text,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    translate("50 000" + translate("sum")),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_transparent_text,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 26,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Text(
                    translate("card.all"),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black_text,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    translate("50 000" + translate("sum")),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black_text,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(top: 35),
              color: AppTheme.black_linear_category,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                child: Center(
                  child: Text(
                    translate("card.buy"),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 17,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
