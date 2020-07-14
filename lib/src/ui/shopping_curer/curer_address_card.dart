import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/model/database/address_model.dart';

import '../../app_theme.dart';
import 'add_address_card.dart';
import 'order_card_curer.dart';

// ignore: must_be_immutable
class CurerAddressCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurerAddressCardScreenState();
  }
}

class CheckboxList {
  String number;
  int index;

  CheckboxList({this.number, this.index});
}

class _CurerAddressCardScreenState extends State<CurerAddressCardScreen> {
  DatabaseHelperAddress db = new DatabaseHelperAddress();

  String radioItemHolder = '';
  int id = 1;

  List<CheckboxList> nList = new List();
  List<AddressModel> data = new List();

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
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 48,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
//                              Navigator.pushReplacement(
//                                context,
//                                PageTransition(
//                                  type: PageTransitionType.downToUp,
//                                  child: OrderCardCurerScreen(
//                                    AddressModel(-1, "", "", "", "", ""),
//                                  ),
//                                ),
//                              );
                            },
                            child: Container(
                              height: 48,
                              width: 48,
                              color: AppTheme.arrow_examp_back,
                              padding: EdgeInsets.all(13),
                              margin: EdgeInsets.only(left: 16),
                              child: SvgPicture.asset(
                                "assets/images/arrow_back.svg",
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            translate("address.title"),
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
                              height: 48,
                              width: 48,
                              color: AppTheme.arrow_examp_back,
                              margin: EdgeInsets.only(right: 4),
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
                    margin: EdgeInsets.only(top: 30, left: 16, bottom: 24),
                    child: Text(
                      translate("address.delivery_address"),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        color: AppTheme.black_text,
                      ),
                    ),
                  ),
                  FutureBuilder<List<AddressModel>>(
                    future: db.getProduct(),
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      if (data == null) {
                        return Container(
                          child: Center(
                            child: Text("error"),
                          ),
                        );
                      }
                      if (snapshot.data.length > 0) {
                        this.data = new List();
                        nList = new List();
                        this.data = snapshot.data;
                        radioItemHolder = snapshot.data[0].street;
                        for (int i = 0; i < snapshot.data.length; i++) {
                          nList.add(
                            CheckboxList(
                                index: snapshot.data[i].id,
                                number: snapshot.data[i].street),
                          );
                        }
                      }
                      return ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: nList
                            .map((data) => Container(
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          title: Align(
                                            child: Text(
                                              "${data.number}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: AppTheme.fontRoboto,
                                                color: AppTheme.black_text,
                                              ),
                                            ),
                                            alignment: Alignment.centerLeft,
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
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        margin:
                                            EdgeInsets.only(left: 8, right: 8),
                                        color: AppTheme.black_linear_category,
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                  Container(
                    height: 21,
                    margin: EdgeInsets.only(
                        left: 25, right: 16, top: 25, bottom: 25),
                    child: Row(
                      children: [
                        Container(
                          height: 21,
                          width: 21,
                          child: Icon(
                            Icons.add_circle_outline,
                            color: AppTheme.blue_app_color,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: AddAddressCardScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 21,
                              margin: EdgeInsets.only(left: 25),
                              child: Text(
                                translate("orders.new_address"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: AppTheme.blue_app_color,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
//                Navigator.pushReplacement(
//                  context,
//                  PageTransition(
//                    type: PageTransitionType.downToUp,
//                    child: OrderCardCurerScreen(data[id - 1]),
//                  ),
//                );
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
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                child: Center(
                  child: Text(
                    translate("next"),
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
