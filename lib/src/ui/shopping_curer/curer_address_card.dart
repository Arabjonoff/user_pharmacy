import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/blocs/store_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/shopping_curer/store_list_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import 'order_card_curer.dart';

class CurerAddressCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurerAddressCardScreenState();
  }
}

class _CurerAddressCardScreenState extends State<CurerAddressCardScreen> {
  int shippingId = 0;
  int positionId = 0;
  AddressModel myAddress;
  bool isFirst = true;
  var duration = Duration(milliseconds: 270);

  bool error = false;
  bool loading = false;
  String errorText = "";

  DatabaseHelper dataBase = new DatabaseHelper();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    blocOrderOptions.fetchOrderOptions();
    blocStore.fetchAllAddress();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              physics: BouncingScrollPhysics(),
              cacheExtent: 99999999,
              padding: EdgeInsets.all(16),
              controller: _scrollController,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    translate("address.delivery_address"),
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
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: blocStore.allAddressInfo,
                        builder: (context,
                            AsyncSnapshot<List<AddressModel>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      myAddress = snapshot.data[index];
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        snapshot.data[index].type == 1
                                            ? SvgPicture.asset(
                                                "assets/icons/home.svg",
                                                color: AppTheme.textGray,
                                              )
                                            : snapshot.data[index].type == 2
                                                ? SvgPicture.asset(
                                                    "assets/icons/work.svg",
                                                    color: AppTheme.textGray,
                                                  )
                                                : SvgPicture.asset(
                                                    "assets/icons/location.svg",
                                                    color: AppTheme.textGray,
                                                  ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            snapshot.data[index].type == 1
                                                ? translate("address.home")
                                                : snapshot.data[index].type == 2
                                                    ? translate("address.work")
                                                    : snapshot
                                                        .data[index].street,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                        snapshot.data[index].type == 0
                                            ? GestureDetector(
                                                child: SvgPicture.asset(
                                                    "assets/icons/edit.svg"),
                                                onTap: () {
                                                  BottomDialog.editAddress(
                                                    context,
                                                    snapshot.data[index],
                                                  );
                                                },
                                              )
                                            : Container(),
                                        snapshot.data[index].type == 0
                                            ? SizedBox(width: 8)
                                            : Container(),
                                        AnimatedContainer(
                                          curve: Curves.easeInOut,
                                          duration: duration,
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: myAddress ==
                                                      snapshot.data[index]
                                                  ? AppTheme.blue
                                                  : AppTheme.gray,
                                            ),
                                          ),
                                          child: AnimatedContainer(
                                            duration: duration,
                                            curve: Curves.easeInOut,
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: myAddress ==
                                                      snapshot.data[index]
                                                  ? AppTheme.blue
                                                  : AppTheme.background,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(3),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomDialog.addAddress(context, 0);
                        },
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location.svg",
                                color: AppTheme.textGray,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  translate("address.add"),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.2,
                                    color: AppTheme.textGray,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: blocOrderOptions.orderOptions,
                  builder:
                      (context, AsyncSnapshot<OrderOptionsModel> snapshot) {
                    if (snapshot.hasData) {
                      paymentTypes = new List();
                      for (int i = 0;
                          i < snapshot.data.paymentTypes.length;
                          i++) {
                        paymentTypes.add(PaymentTypesCheckBox(
                          id: i,
                          paymentId: snapshot.data.paymentTypes[i].id,
                          cardId: snapshot.data.paymentTypes[i].cardId,
                          cardToken: snapshot.data.paymentTypes[i].cardToken,
                          name: snapshot.data.paymentTypes[i].name,
                          pan: snapshot.data.paymentTypes[i].pan,
                          type: snapshot.data.paymentTypes[i].type,
                        ));
                      }
                      if (isFirst) {
                        isFirst = false;
                        shippingId = snapshot.data.shippingTimes[0].id;
                      }
                      return ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          snapshot.data.shippingTimes.length > 1
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8, top: 24),
                                  child: Text(
                                    translate("address.choose_time"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.black_text,
                                    ),
                                  ),
                                )
                              : Container(),
                          snapshot.data.shippingTimes.length > 1
                              ? Column(
                                  children: snapshot.data.shippingTimes
                                      .map((data) => RadioListTile(
                                            title: Text(
                                              "${data.name}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontFamily: AppTheme.fontRubik,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            activeColor:
                                                AppTheme.blue_app_color,
                                            groupValue: shippingId,
                                            value: data.id,
                                            onChanged: (val) {
                                              setState(() {
                                                shippingId = data.id;
                                                for (int i = 0;
                                                    i <
                                                        snapshot
                                                            .data
                                                            .shippingTimes
                                                            .length;
                                                    i++) {
                                                  if (data.id ==
                                                      snapshot
                                                          .data
                                                          .shippingTimes[i]
                                                          .id) {
                                                    positionId = i;
                                                  }
                                                }
                                              });
                                            },
                                          ))
                                      .toList(),
                                )
                              : Container(),
                          Container(
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 24),
                            child: Text(
                              translate("type_time"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_text,
                              ),
                            ),
                          ),
                          ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(16),
                              itemCount: snapshot.data.shippingTimes[positionId]
                                  .descriptions.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/images/icon_yes_blue.svg"),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              snapshot
                                                  .data
                                                  .shippingTimes[positionId]
                                                  .descriptions[index],
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15,
                                                height: 1.33,
                                                fontFamily: AppTheme.fontRubik,
                                                color: AppTheme.black_text,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: Color.fromRGBO(0, 0, 0, 0.08),
                                    )
                                  ],
                                );
                              }),
                        ],
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
                error
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 11, left: 16, right: 16),
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
          GestureDetector(
            onTap: () {
              if (!loading) {
                if (myAddress != null) {
                  if (shippingId != null) {
                    setState(() {
                      loading = true;
                    });
                    CreateOrderModel createOrder;
                    List<Drugs> drugs = new List();
                    dataBase.getProdu(true).then((dataBaseValue) => {
                          for (int i = 0; i < dataBaseValue.length; i++)
                            {
                              drugs.add(Drugs(
                                drug: dataBaseValue[i].id,
                                qty: dataBaseValue[i].cardCount,
                              ))
                            },
                          createOrder = new CreateOrderModel(
                            location: myAddress.lat + "," + myAddress.lng,
                            device: Platform.isIOS ? "IOS" : "Android",
                            address: myAddress.street,
                            type: "shipping",
                            shippingTime: shippingId,
                            drugs: drugs,
                          ),
                          Repository()
                              .fetchCheckOrder(createOrder)
                              .then((response) => {
                                    if (response.status == 1)
                                      {
                                        setState(() {
                                          loading = false;
                                          error = false;
                                        }),
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoreListScreen(
                                              createOrder: createOrder,
                                              checkOrderModel: response,
                                            ),
                                          ),
                                        ),
                                      }
                                    else
                                      {
                                        setState(() {
                                          error = true;
                                          loading = false;
                                          errorText = response.msg;
                                        }),
                                        Timer(Duration(milliseconds: 100), () {
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 200),
                                          );
                                        }),
                                      }
                                  }),
                        });
                  } else {
                    setState(() {
                      error = true;
                      errorText = translate("not_time");
                    });
                  }
                } else {
                  setState(() {
                    error = true;
                    errorText = translate("not_address");
                  });
                }
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
    );
  }
}
