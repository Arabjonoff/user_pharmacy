import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/eventBus/all_item_isopen.dart';
import 'package:pharmacy/src/model/eventBus/card_item_change_model.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/payment/verfy_payment_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/order_card_curer.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_pickup_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import '../shopping_curer/curer_address_card.dart';

// ignore: must_be_immutable
class OrderCardPickupScreen extends StatefulWidget {
  int orderId;
  String message;

  OrderCardPickupScreen(this.orderId, this.message);

  @override
  State<StatefulWidget> createState() {
    return _OrderCardPickupScreenState();
  }
}

class _OrderCardPickupScreenState extends State<OrderCardPickupScreen> {
  double allPrice = cashData.total;
  double itemPrice = cashData.total;
  double cashPrice = 0.0;
  int paymentType;
  int clickType;
  bool checkBox = false;
  bool isEnd = false;
  bool isCardNum = false;
  bool isCardDate = false;
  String cardToken = "";

  bool loading = false;
  bool error = false;
  bool edit = true;

  String error_text = "";

  DatabaseHelper dataBase = new DatabaseHelper();
  DateTime date = new DateTime.now();

  TextEditingController cardNumberController =
      TextEditingController(text: "8600");
  TextEditingController cardDateController = TextEditingController();

  TextEditingController cashPriceController = TextEditingController();

  var maskCardNumberFormatter = new MaskTextInputFormatter(
      mask: '8600 #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  var maskCardDateFormatter = new MaskTextInputFormatter(
      mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  void dispose() {
    // aptekaModel = null;
    super.dispose();
  }

  _OrderCardPickupScreenState() {
    cardNumberController.addListener(() {
      var cardNum = cardNumberController.text.replaceAll(' ', '');
      if (cardNum.length == 16) {
        setState(() {
          isCardNum = true;
        });
      } else {
        setState(() {
          isCardNum = false;
        });
      }
    });
    cardDateController.addListener(() {
      var cardDate =
          cardDateController.text.replaceAll(' ', '').replaceAll('/', '');
      if (cardDate.length == 4) {
        setState(() {
          isCardDate = true;
        });
      } else {
        setState(() {
          isCardDate = false;
        });
      }
    });
    cashPriceController.addListener(() {
      double p;
      try {
        p = cashPriceController.text == ""
            ? 0.0
            : double.parse(cashPriceController.text.replaceAll(" ", ""));
        if (cashPrice.toInt().toString() != cashPriceController.text) {
          if (p <= cashData.cash) {
            if (p >= cashData.total) {
              setState(() {
                allPrice = 0;
                cashPrice = cashData.total;
                cashPriceController.text = cashData.total.toInt().toString();
                cashPriceController.selection = TextSelection.collapsed(
                    offset: cashPriceController.text.length);
              });
            } else {
              if (cashPriceController.text.toString() != "") {
                if (int.parse(cashPriceController.text.toString()) == 0) {
                  cashPriceController.text = "0";
                  cashPriceController.selection = TextSelection.collapsed(
                      offset: cashPriceController.text.length);
                }
              }
              setState(() {
                allPrice = cashData.total - p;
                cashPrice = p;
              });
            }
          } else {
            if (p >= cashData.total) {
              setState(() {
                allPrice = 0;
                cashPrice = [cashData.total, cashData.cash].reduce(min);
                cashPriceController.text = [cashData.total, cashData.cash]
                    .reduce(min)
                    .toInt()
                    .toString();
                cashPriceController.selection = TextSelection.collapsed(
                    offset: cashPriceController.text.length);
              });
            } else {
              if (cashPriceController.text.toString() != "") {
                if (int.parse(cashPriceController.text.toString()) == 0) {
                  cashPriceController.text = "0";
                  cashPriceController.selection = TextSelection.collapsed(
                      offset: cashPriceController.text.length);
                }
              }
              setState(() {
                cashData.cash == 0
                    ? cashPriceController.text = ""
                    : cashPriceController.text =
                        cashData.cash.toInt().toString();

                allPrice = cashData.total - cashData.cash;
                cashPrice = cashData.cash;
              });
            }
          }
        }
      } on Exception catch (_) {
        throw Exception("Error");
      }
    });
  }

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
              height: 48,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("orders.chechout") +
                          " №" +
                          widget.orderId.toString(),
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
                        blocCard.fetchAllCard();
                        //Navigator.pop(context);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Container(
                        height: 48,
                        margin: EdgeInsets.only(right: 4),
                        width: 48,
                        color: AppTheme.arrow_examp_back,
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
              margin: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
              child: Text(
                translate("orders.payment_type"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: AppTheme.black_catalog,
                ),
              ),
            ),
            StreamBuilder(
              stream: blocOrderOptions.orderOptions,
              builder: (context, AsyncSnapshot<OrderOptionsModel> snapshot) {
                if (snapshot.hasData) {
                  paymentTypes = new List();

                  for (int i = 0; i < snapshot.data.paymentTypes.length; i++) {
                    paymentTypes.add(PaymentTypesCheckBox(
                      id: i,
                      payment_id: snapshot.data.paymentTypes[i].id,
                      card_id: snapshot.data.paymentTypes[i].card_id,
                      card_token: snapshot.data.paymentTypes[i].card_token,
                      name: snapshot.data.paymentTypes[i].name,
                      pan: snapshot.data.paymentTypes[i].pan,
                      type: snapshot.data.paymentTypes[i].type,
                    ));
                  }
                  return Column(
                    children: paymentTypes
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
                                        fontFamily: AppTheme.fontRoboto,
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
                                if (data.id == paymentTypes.length - 1) {
                                  setState(() {
                                    clickType = data.id;
                                    paymentType = data.payment_id;
                                    isEnd = true;
                                    cardToken = data.card_token;
                                  });
                                } else {
                                  setState(() {
                                    clickType = data.id;
                                    paymentType = data.payment_id;
                                    isEnd = false;
                                    cardToken = data.card_token;
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
                    itemCount: 4,
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
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_text,
                                fontSize: 15,
                              ),
                              controller: cardNumberController,
                              inputFormatters: [maskCardNumberFormatter],
                              decoration: InputDecoration(
                                labelText: translate('cardNumber'),
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
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_text,
                                fontSize: 15,
                              ),
                              controller: cardDateController,
                              inputFormatters: [maskCardDateFormatter],
                              decoration: InputDecoration(
                                labelText: translate('cardDate'),
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
                        Container(
                          margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                checkBox = !checkBox;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  translate("saveCard"),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontRoboto,
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
                        ),
                      ],
                    ),
                  )
                : Container(),
            Container(
              height: 24,
              margin: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    margin: EdgeInsets.only(right: 8),
                    child: SvgPicture.asset("assets/images/login_logo.svg"),
                  ),
                  Text(
                    translate("cash_price_title"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black_text,
                    ),
                  ),
                  Expanded(child: Container()),
                  Text(
                    translate("cash_pay"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.search_empty,
                    ),
                  ),
                  Text(
                    " " +
                        priceFormat.format(cashData == null
                            ? 0.0
                            : (cashData.cash).toInt().toDouble()) +
                        translate("sum"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.search_empty,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 48,
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppTheme.auth_login,
                border: Border.all(
                  color: AppTheme.auth_border,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.black_text,
                    fontSize: 15,
                  ),
                  controller: cashPriceController,
                  decoration: InputDecoration(
                    labelText: translate('cash_price'),
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
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Text(
                    translate("price_item"),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.search_empty,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    priceFormat.format(itemPrice) + translate(translate("sum")),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.search_empty,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Text(
                    translate("price_cash_item"),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.search_empty,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    cashPrice == 0
                        ? priceFormat.format(cashPrice) +
                            translate(
                              translate("sum"),
                            )
                        : "-" +
                            priceFormat.format(cashPrice) +
                            translate(
                              translate("sum"),
                            ),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.search_empty,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 16,
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
                    priceFormat.format(allPrice) + translate(translate("sum")),
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
            error
                ? Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                    child: Text(
                      error_text,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: AppTheme.fontRoboto,
                        fontSize: 13,
                        color: AppTheme.red_fav_color,
                      ),
                    ),
                  )
                : Container(),
            widget.message.length > 1
                ? Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/icon_info_circle.svg"),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.message,
                            maxLines: 5,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 13,
                              height: 1.6,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.blue_app_color,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            Container(
              height: 1,
              margin: EdgeInsets.only(top: 24),
              color: AppTheme.black_linear_category,
            ),
            GestureDetector(
              onTap: () {
                if (!loading) {
                  if (widget.orderId != null && clickType != null) {
                    var cardNum = cardNumberController.text.replaceAll(' ', '');
                    var cardDate = cardDateController.text
                        .replaceAll(' ', '')
                        .replaceAll('/', '');

                    if (!isEnd ||
                        (cardNum.length == 16 && cardDate.length == 4)) {
                      setState(() {
                        loading = true;
                      });

                      PaymentOrderModel addModel = new PaymentOrderModel();

                      isEnd
                          ? addModel = new PaymentOrderModel(
                              order_id: widget.orderId,
                              cash_pay: cashPrice.toInt(),
                              payment_type: paymentType,
                              card_pan: cardNum,
                              card_exp: cardDate,
                              card_save: checkBox ? 1 : 0,
                            )
                          : addModel = new PaymentOrderModel(
                              order_id: widget.orderId,
                              cash_pay: cashPrice.toInt(),
                              payment_type: paymentType,
                              card_token: cardToken == "" ? null : cardToken,
                            );
                      Repository().fetchPayment(addModel).then((response) => {
                            if (response.status == 1)
                              {
                                if (response.data.error_code == 0)
                                  {
                                    setState(() {
                                      loading = false;
                                      error = false;
                                    }),
                                    if (response.data.card_token != "")
                                      {
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: VerfyPaymentScreen(
                                                response.data.phone_number,
                                                response.data.card_token),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst),
                                        RxBus.post(CardItemChangeModel(true),
                                            tag: "EVENT_CARD_BOTTOM"),
                                      }
                                  }
                                else
                                  {
                                    setState(() {
                                      error = true;
                                      loading = false;
                                      error_text = response.data.error_note;
                                    }),
                                  }
                              }
                            else if (response.status == -1)
                              {
                                setState(() {
                                  error = true;
                                  loading = false;
                                  error_text = response.msg;
                                }),
                              }
                            else
                              {
                                setState(() {
                                  error = true;
                                  loading = false;
                                  error_text = response.msg == ""
                                      ? translate("error_distanse")
                                      : response.msg;
                                }),
                              }
                          });
                    }
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: (clickType == null || (isEnd))
                      ? (isCardNum && isCardDate)
                          ? AppTheme.blue_app_color
                          : AppTheme.blue_app_color_transparent
                      : AppTheme.blue_app_color,
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
                          translate("orders.oplat"),
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

  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var language_data;
    if (prefs.getString('language') != null) {
      language_data = prefs.getString('language');
    } else {
      language_data = "ru";
    }
    blocOrderOptions.fetchOrderOptions(language_data);
  }
}
