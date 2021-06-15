import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/eventBus/card_item_change_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/payment/verfy_payment_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/order_card_curer.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class OrderCardPickupScreen extends StatefulWidget {
  final int orderId;
  final String message;
  final CashBackData cashBackData;

  OrderCardPickupScreen(
    this.orderId,
    this.message,
    this.cashBackData,
  );

  @override
  State<StatefulWidget> createState() {
    return _OrderCardPickupScreenState();
  }
}

class _OrderCardPickupScreenState extends State<OrderCardPickupScreen> {
  double allPrice = 0.0;
  double itemPrice = 0.0;
  double cashPrice = 0.0;
  int paymentType;
  int clickType;

  bool loading = false;
  bool error = false;

  String errorText = "";

  DatabaseHelper dataBase = new DatabaseHelper();
  DateTime date = new DateTime.now();

  TextEditingController cashPriceController = TextEditingController();

  @override
  void initState() {
    _getInfo();
    setState(() {
      allPrice = widget.cashBackData.total;
      itemPrice = widget.cashBackData.total;
    });
    super.initState();
  }

  _OrderCardPickupScreenState() {
    cashPriceController.addListener(() {
      double p;
      try {
        p = cashPriceController.text == ""
            ? 0.0
            : double.parse(cashPriceController.text.replaceAll(" ", ""));
        if (cashPrice.toInt().toString() != cashPriceController.text) {
          if (p <= widget.cashBackData.cash) {
            if (p >= widget.cashBackData.total) {
              setState(() {
                allPrice = 0;
                cashPrice = widget.cashBackData.total;
                cashPriceController.text =
                    widget.cashBackData.total.toInt().toString();
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
                allPrice = widget.cashBackData.total - p;
                cashPrice = p;
              });
            }
          } else {
            if (p >= widget.cashBackData.total) {
              setState(() {
                allPrice = 0;
                cashPrice = [
                  widget.cashBackData.total,
                  widget.cashBackData.cash
                ].reduce(min);
                cashPriceController.text = [
                  widget.cashBackData.total,
                  widget.cashBackData.cash
                ].reduce(min).toInt().toString();
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
                widget.cashBackData.cash == 0
                    ? cashPriceController.text = ""
                    : cashPriceController.text =
                        widget.cashBackData.cash.toInt().toString();

                allPrice = widget.cashBackData.total - widget.cashBackData.cash;
                cashPrice = widget.cashBackData.cash;
              });
            }
          }
        }
      } on Exception catch (_) {}
    });
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
              translate("payment.name"),
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
                          translate("payment.type"),
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
                      StreamBuilder(
                        stream: blocOrderOptions.orderOptions,
                        builder: (context,
                            AsyncSnapshot<OrderOptionsModel> snapshot) {
                          if (snapshot.hasData) {
                            return new ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.paymentTypes.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (snapshot.data.paymentTypes[index].id !=
                                        paymentType) {
                                      setState(() {
                                        paymentType = snapshot
                                            .data.paymentTypes[index].id;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                      left: 16,
                                      right: 16,
                                    ),
                                    height: 48,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 8),
                                        snapshot.data.paymentTypes[index]
                                                    .type ==
                                                "cash"
                                            ? SvgPicture.asset(
                                                "assets/icons/cash.svg")
                                            : snapshot.data.paymentTypes[index]
                                                        .type ==
                                                    "card"
                                                ? SvgPicture.asset(
                                                    "assets/icons/card.svg")
                                                : SvgPicture.asset(
                                                    "assets/icons/wallet.svg"),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            snapshot.data.paymentTypes[index].id
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRubik,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              height: 1.2,
                                              color: AppTheme.textGray,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 270),
                                          curve: Curves.easeInOut,
                                          height: 16,
                                          width: 16,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: paymentType ==
                                                      snapshot
                                                          .data
                                                          .paymentTypes[index]
                                                          .id
                                                  ? AppTheme.blue
                                                  : AppTheme.gray,
                                            ),
                                          ),
                                          child: Center(
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 270),
                                              curve: Curves.easeInOut,
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: paymentType ==
                                                        snapshot
                                                            .data
                                                            .paymentTypes[index]
                                                            .id
                                                    ? AppTheme.blue
                                                    : AppTheme.background,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (_, __) => Container(
                                height: 48,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              itemCount: 4,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                translate("payment.my_cash"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.2,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                            ),
                            Text(
                              translate("payment.my_cash_price"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            Text(
                              " " +
                                  priceFormat.format(widget.cashBackData.cash) +
                                  translate("sum"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.background,
                      ),
                      Container(
                        height: 44,
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.only(top: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.text_dark,
                          ),
                          controller: cashPriceController,
                          decoration: InputDecoration(
                            hintText: translate('payment.price'),
                            hintStyle: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              height: 1.2,
                              color: AppTheme.gray,
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
                    ],
                  ),
                ),
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
                          translate("payment.create"),
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
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              translate("payment.price_order"),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.search_empty,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              priceFormat.format(itemPrice) +
                                  translate(translate("sum")),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRubik,
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
                              translate("payment.my_cash"),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRubik,
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
                                fontFamily: AppTheme.fontRubik,
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
                              translate("history.all_price"),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black_text,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              priceFormat.format(allPrice) +
                                  translate(translate("sum")),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black_text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                errorText != ""
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                        child: Text(
                          errorText,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRubik,
                            fontSize: 13,
                            color: AppTheme.red,
                          ),
                        ),
                      )
                    : Container(),
                widget.message.length > 1
                    ? Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                        child: Text(
                          widget.message,
                          maxLines: 5,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontSize: 15,
                            height: 1.2,
                            color: AppTheme.blue,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
            color: AppTheme.white,
            child: GestureDetector(
              onTap: () {
                if (!loading) {
                  if (widget.orderId != null && clickType != null) {
                    setState(() {
                      loading = true;
                    });

                    PaymentOrderModel addModel = new PaymentOrderModel();

                    // isEnd
                    //     ? addModel = new PaymentOrderModel(
                    //         orderId: widget.orderId,
                    //         cashPay: cashPrice.toInt(),
                    //         paymentType: paymentType,
                    //         cardPan: cardNum,
                    //         cardExp: cardDate,
                    //         cardSave: checkBox ? 1 : 0,
                    //       )
                    //     :
                    addModel = new PaymentOrderModel(
                      orderId: widget.orderId,
                      cashPay: cashPrice.toInt(),
                      paymentType: paymentType,
                      // cardToken: cardToken == "" ? null : cardToken,
                    );
                    Repository().fetchPayment(addModel).then((response) => {
                          if (response.status == 1)
                            {
                              if (response.data.errorCode == 0)
                                {
                                  setState(() {
                                    loading = false;
                                    error = false;
                                  }),
                                  if (response.data.cardToken != "")
                                    {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VerifyPaymentScreen(
                                            response.data.phoneNumber,
                                            response.data.cardToken,
                                          ),
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
                                    errorText = response.data.errorNote;
                                  }),
                                }
                            }
                          else if (response.status == -1)
                            {
                              setState(() {
                                error = true;
                                loading = false;
                                errorText = response.msg;
                              }),
                            }
                          else
                            {
                              setState(() {
                                error = true;
                                loading = false;
                                errorText = response.msg == ""
                                    ? translate("error_distanse")
                                    : response.msg;
                              }),
                            }
                        });
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: (clickType == null)
                      ? AppTheme.blue_app_color_transparent
                      : AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 24,
                  left: 22,
                  right: 22,
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
                          translate("payment.pay"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRubik,
                            fontSize: 17,
                            color: AppTheme.white,
                          ),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var languageData = prefs.getString('language') ?? "ru";

    blocOrderOptions.fetchOrderOptions(languageData);
  }
}
