import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class CheckoutOrderScreen extends StatefulWidget {
  final List<ProductsStore> drugs;
  final CashBackData data;

  CheckoutOrderScreen({
    this.drugs,
    this.data,
  });

  @override
  State<StatefulWidget> createState() {
    return _CheckoutOrderScreenState();
  }
}

class _CheckoutOrderScreenState extends State<CheckoutOrderScreen> {
  var storeInfo;
  String firstName = "", lastName = "", number = "";

  @override
  void initState() {
    _getFullName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("card.order"),
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                storeInfo == null
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Text(
                                translate("card.data_store"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.2,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: AppTheme.background,
                            ),
                            GestureDetector(
                              onTap: () {
                                BottomDialog.showChooseStore(
                                  context,
                                  widget.drugs,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(16),
                                height: 44,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    translate("card.choose_store"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 1.25,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          translate("card.details_order"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.background,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/profile.svg",
                                height: 48,
                                width: 48,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  firstName + " " + lastName,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.2,
                                    color: AppTheme.text_dark,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  number,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.6,
                                    color: AppTheme.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.background,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Text(
                            translate("card.all_order"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.3,
                              color: AppTheme.textGray,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            "2",
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.6,
                              color: AppTheme.text_dark,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      storeInfo == null
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    translate("card.all_order"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      height: 1.3,
                                      color: AppTheme.textGray,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    // priceFormat(storeInfo) + translate("sum"),
                                    "13e2er",
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
                      SizedBox(height: 16),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.background,
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomDialog.showEditInfo(
                            context,
                            firstName,
                            lastName,
                            number,
                            (valueFirstName, valueLastName, valueNumber) {
                              setState(() {
                                firstName = valueFirstName;
                                lastName = valueLastName;
                                number = valueNumber;
                              });
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(16),
                          height: 44,
                          color: AppTheme.white,
                          child: Center(
                            child: Text(
                              translate("card.edit"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 1.25,
                                color: AppTheme.textGray,
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
            onTap: () {},
            child: Container(
              color: AppTheme.white,
              child: Container(
                margin:
                    EdgeInsets.only(top: 12, left: 22, right: 22, bottom: 24),
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: storeInfo == null ? AppTheme.gray : AppTheme.blue,
                ),
                child: Center(
                  child: Text(
                    translate("card.payment"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.25,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('name') ?? "";
      lastName = prefs.getString('surname') ?? "";
      number = Utils.numberFormat(prefs.getString('number') ?? "");
    });
  }
}
