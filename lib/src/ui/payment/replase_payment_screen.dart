import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ReplacePaymentScreen extends StatefulWidget {
  final int orderId;

  ReplacePaymentScreen(this.orderId);

  @override
  State<StatefulWidget> createState() {
    return _ReplacePaymentScreenState();
  }
}

class _ReplacePaymentScreenState extends State<ReplacePaymentScreen> {
  bool loading = false;
  int paymentType;
  int clickType;
  bool checkBox = false;
  bool isEnd = false;
  String cardToken = "";

  List<PaymentTypesCheckBox> paymentTypeReplace = new List();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardDateController = TextEditingController();

  // var maskCardNumberFormatter = new MaskTextInputFormatter(
  //     mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  // var maskCardDateFormatter = new MaskTextInputFormatter(
  //     mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    _getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getLanguage();
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
            Container(
              height: 48,
              width: double.infinity,
              child: Stack(
                children: [
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
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 16),
                    child: Text(
                      translate("orders.payment_type"),
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: AppTheme.black_catalog,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: blocOrderOptions.orderOptions,
                    builder:
                        (context, AsyncSnapshot<OrderOptionsModel> snapshot) {
                      if (snapshot.hasData) {
                        paymentTypeReplace = new List();
                        for (int i = 0;
                            i < snapshot.data.paymentTypes.length;
                            i++) {
                          paymentTypeReplace.add(PaymentTypesCheckBox(
                            id: i,
                            paymentId: snapshot.data.paymentTypes[i].id,
                            cardId: snapshot.data.paymentTypes[i].cardId,
                            cardToken: snapshot.data.paymentTypes[i].cardToken,
                            name: snapshot.data.paymentTypes[i].name,
                            pan: snapshot.data.paymentTypes[i].pan,
                            type: snapshot.data.paymentTypes[i].type,
                          ));
                        }
                        return Column(
                          children: paymentTypeReplace
                              .map((data) => RadioListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${data.pan}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontFamily: AppTheme.fontRubik,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    activeColor: AppTheme.blue_app_color,
                                    groupValue: clickType,
                                    value: data.id,
                                    onChanged: (val) {
                                      if (data.id ==
                                          paymentTypeReplace.length - 1) {
                                        setState(() {
                                          clickType = data.id;
                                          paymentType = data.paymentId;
                                          isEnd = true;
                                          cardToken = data.cardToken;
                                        });
                                      } else {
                                        setState(() {
                                          clickType = data.id;
                                          paymentType = data.paymentId;
                                          isEnd = false;
                                          cardToken = data.cardToken;
                                        });
                                      }
                                    },
                                  ))
                              .toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (_, __) => Container(
                            height: 48,
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  height: 15,
                                  width: 250,
                                  color: AppTheme.white,
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          itemCount: 20,
                        ),
                      );
                    },
                  ),
                  isEnd
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                margin: EdgeInsets.only(
                                    top: 12, left: 16, right: 16),
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
                                      fontFamily: AppTheme.fontRubik,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_text,
                                      fontSize: 15,
                                    ),
                                    controller: cardNumberController,
                                    // inputFormatters: [maskCardNumberFormatter],
                                    decoration: InputDecoration(
                                      labelText: translate('cardNumber'),
                                      labelStyle: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF6D7885),
                                        fontSize: 11,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                                margin: EdgeInsets.only(
                                    top: 12, left: 16, right: 16),
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
                                      fontFamily: AppTheme.fontRubik,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_text,
                                      fontSize: 15,
                                    ),
                                    controller: cardDateController,
                                    // inputFormatters: [maskCardDateFormatter],
                                    decoration: InputDecoration(
                                      labelText: translate('cardDate'),
                                      labelStyle: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF6D7885),
                                        fontSize: 11,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                                margin: EdgeInsets.only(
                                    top: 12, left: 16, right: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkBox = !checkBox;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        translate("saveCard"),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppTheme.fontRubik,
                                          color: AppTheme.black_text,
                                        ),
                                      ),
                                      Checkbox(
                                        activeColor: AppTheme.blue_app_color,
                                        value: checkBox,
                                        onChanged: (bool value) {
                                          setState(() {
                                            checkBox = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!loading) {
                  setState(() {
                    loading = true;
                  });
                  // var cardNum = cardNumberController.text.replaceAll(' ', '');
                  // var cardDate = cardDateController.text
                  //     .replaceAll(' ', '')
                  //     .replaceAll('/', '');
                  // ReplacePayModel replace = new ReplacePayModel();
                  // isEnd
                  //     ? replace = new ReplacePayModel(
                  //         order_id: widget.orderId,
                  //         payment_type: paymentType,
                  //         card_pan: cardNum,
                  //         card_exp: cardDate,
                  //         card_save: checkBox ? 1 : 0,
                  //       )
                  //     : replace = new ReplacePayModel(
                  //         order_id: widget.orderId,
                  //         payment_type: paymentType,
                  //         card_token: cardToken == "" ? null : cardToken,
                  //       );
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
                  child: loading
                      ? CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.white),
                        )
                      : Text(
                          translate("next"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRubik,
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

  Future<void> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var languageData;
    if (prefs.getString('language') != null) {
      languageData = prefs.getString('language');
    } else {
      languageData = "ru";
    }
    blocOrderOptions.fetchOrderOptions(languageData);
  }
}
