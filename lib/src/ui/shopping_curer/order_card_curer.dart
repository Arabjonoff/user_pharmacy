import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/eventBus/card_item_change_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/payment/verfy_payment_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class OrderCardCurerScreen extends StatefulWidget {
  final double total;
  final double cashBack;
  final double deliveryPrice;
  final int orderId;

  OrderCardCurerScreen({
    this.orderId,
    this.total,
    this.cashBack,
    this.deliveryPrice,
  });

  @override
  State<StatefulWidget> createState() {
    return _OrderCardCurerScreenState();
  }
}

class _OrderCardCurerScreenState extends State<OrderCardCurerScreen> {
  double cashBackPrice = 0.0;
  int paymentType;
  bool loading = false;
  String errorText = "";

  TextEditingController cashPriceController = TextEditingController();

  @override
  void initState() {
    blocOrderOptions.fetchOrderOptions();
    super.initState();
  }

  _OrderCardCurerScreenState() {
    cashPriceController.addListener(() {
      try {
        if (cashPriceController.text == "") {
          setState(() {
            cashBackPrice = 0.0;
          });
        } else {
          double cashBack =
              double.parse(cashPriceController.text.replaceAll(" ", ""));
          if (cashBack > widget.cashBack ||
              cashBack > (widget.total + widget.deliveryPrice)) {
            setState(() {
              cashPriceController.text =
                  (min(widget.cashBack, (widget.total + widget.deliveryPrice))
                          .toInt())
                      .toString();
              cashPriceController.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: cashPriceController.text.length,
                ),
              );
              cashBackPrice =
                  min(widget.cashBack, (widget.total + widget.deliveryPrice));
            });
          } else {
            setState(() {
              cashBackPrice = cashBack;
            });
          }
        }
      } on Exception catch (_) {
        setState(() {
          cashPriceController.text = "";
          cashBackPrice = 0.0;
        });
      }
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
                                  priceFormat.format(widget.cashBack) +
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
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              priceFormat.format(widget.total) +
                                  translate(translate("sum")),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.text_dark,
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
                              translate("card.price_delivery"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              widget.deliveryPrice.toInt() != 0.0
                                  ? priceFormat.format(widget.deliveryPrice) +
                                      translate(translate("sum"))
                                  : translate("free"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.text_dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              translate("payment.my_cash"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              cashBackPrice == 0.0
                                  ? "0" + translate(translate("sum"))
                                  : "-" +
                                      priceFormat.format(cashBackPrice) +
                                      translate(
                                        translate("sum"),
                                      ),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.text_dark,
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
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              priceFormat.format(widget.total +
                                      widget.deliveryPrice -
                                      cashBackPrice) +
                                  translate(translate("sum")),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.text_dark,
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
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          errorText,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRubik,
                            fontSize: 13,
                            color: AppTheme.red_fav_color,
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
                  if (paymentType != null) {
                    setState(() {
                      loading = true;
                    });

                    PaymentOrderModel addModel = new PaymentOrderModel();

                    // isEnd
                    //     ? addModel = new PaymentOrderModel(
                    //         orderId: widget.orderId,
                    //         cashPay: cashPrice.toInt(),
                    //         paymentType: paymentType,
                    //         cardToken: cardToken == "" ? null : cardToken,
                    //         cardPan: cardNum,
                    //         cardExp: cardDate,
                    //         cardSave: checkBox ? 1 : 0,
                    //       )
                    //     :
                    addModel = new PaymentOrderModel(
                      orderId: widget.orderId,
                      cashPay: cashBackPrice.toInt(),
                      paymentType: paymentType,
                      //cardToken: cardToken == "" ? null : cardToken,
                    );

                    Repository().fetchPayment(addModel).then((response) => {
                          if (response.status == 1)
                            {
                              if (response.data.errorCode == 0)
                                {
                                  setState(() {
                                    loading = false;
                                    errorText = "";
                                  }),
                                  RxBus.post(CardItemChangeModel(true),
                                      tag: "EVENT_CARD"),
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
                                      ),
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
                                    loading = false;
                                    errorText = response.data.errorNote;
                                  }),
                                }
                            }
                          else if (response.status == -1)
                            {
                              setState(() {
                                loading = false;
                                errorText = response.msg;
                              }),
                            }
                          else
                            {
                              setState(() {
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
                  borderRadius: BorderRadius.circular(10.0),
                  color: paymentType == null ? AppTheme.gray : AppTheme.blue,
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
                          translate("card.pay"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.white,
                          ),
                          maxLines: 1,
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
