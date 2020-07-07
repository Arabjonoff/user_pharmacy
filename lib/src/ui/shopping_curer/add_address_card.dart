import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/model/database/address_model.dart';

import '../../app_theme.dart';
import 'curer_address_card.dart';
import 'order_card_curer.dart';

// ignore: must_be_immutable
class AddAddressCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddAddressCardScreenState();
  }
}

class CheckboxList {
  String number;
  int index;

  CheckboxList({this.number, this.index});
}

class _AddAddressCardScreenState extends State<AddAddressCardScreen> {
  TextEditingController homeController = TextEditingController();
  TextEditingController ofisController = TextEditingController();
  TextEditingController padezController = TextEditingController();
  TextEditingController etajController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  DatabaseHelperAddress db = new DatabaseHelperAddress();

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
                    height: 26,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: CurerAddressCardScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              padding: EdgeInsets.all(3),
                              margin: EdgeInsets.only(left: 16),
                              child: SvgPicture.asset(
                                  "assets/images/arrow_back.svg"),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            translate("orders.new_add_address"),
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
                              child: SvgPicture.asset(
                                  "assets/images/arrow_close.svg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 30, left: 16, right: 16),
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
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_text,
                          fontSize: 15,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        controller: homeController,
                        decoration: InputDecoration(
                          labelText: translate('address.dom'),
                          labelStyle: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF6D7885),
                            fontSize: 11,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
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
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_text,
                          fontSize: 15,
                        ),
                        controller: ofisController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: translate('address.ofis'),
                          labelStyle: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF6D7885),
                            fontSize: 11,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
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
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.black_text,
                                  fontSize: 15,
                                ),
                                controller: padezController,
                                decoration: InputDecoration(
                                  labelText: translate('address.padez'),
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
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            height: 56,
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
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.black_text,
                                  fontSize: 15,
                                ),
                                controller: etajController,
                                decoration: InputDecoration(
                                  labelText: translate('address.etaj'),
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
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
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
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_text,
                          fontSize: 15,
                        ),
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: translate('address.comment'),
                          labelStyle: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF6D7885),
                            fontSize: 11,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (homeController.text.isNotEmpty) {
                  db.saveProducts(
                    AddressModel(
                      0,
                      homeController.text,
                      ofisController.text == null ? "" : ofisController.text,
                      padezController.text == null ? "" : padezController.text,
                      etajController.text == null ? "" : etajController.text,
                      commentController.text == null
                          ? ""
                          : commentController.text,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: OrderCardCurerScreen(AddressModel(
                        1,
                        homeController.text,
                        ofisController.text,
                        padezController.text == null
                            ? ""
                            : padezController.text,
                        etajController.text == null ? "" : etajController.text,
                        commentController.text == null
                            ? ""
                            : commentController.text,
                      )),
                    ),
                  );
                }
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
                    translate("address.save_address"),
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
