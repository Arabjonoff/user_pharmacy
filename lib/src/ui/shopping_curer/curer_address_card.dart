import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/eventBus/all_item_isopen.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';

//import 'package:pharmacy/src/model/send/check_order.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/map_address_screen.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import 'order_card_curer.dart';

// ignore: must_be_immutable
class CurerAddressCardScreen extends StatefulWidget {
  bool isAddress;

  CurerAddressCardScreen(this.isAddress);

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
  double chooseLat = 0.0, chooseLng = 0.0;
  int shippingId = 0;
  int positionId = 0;
  int id;
  String myAddress;
  bool isAddress = false;
  bool isFirst = true;

  bool error = false;
  bool loading = false;
  String error_text = "";

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    _getLanguage();
    isAddress = widget.isAddress;
    super.initState();
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("orders.choose_address"),
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontFamily: AppTheme.fontCommons,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.black_text,
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
                    margin: EdgeInsets.only(top: 24, left: 16, bottom: 24),
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
                      } else {
                        if (isAddress) {
                          myAddress = data[data.length - 1].street;
                          chooseLat = double.parse(data[data.length - 1].lat);
                          chooseLng = double.parse(data[data.length - 1].lng);
                          id = data[data.length - 1].id;
                          isAddress = false;
                        }
                      }
                      return snapshot.data.length > 0
                          ? ListView(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              children: snapshot.data
                                  .map((data) => Container(
                                        height: 60,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: RadioListTile(
                                                title: Align(
                                                  child: Text(
                                                    "${data.street}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          AppTheme.fontRoboto,
                                                      color:
                                                          AppTheme.black_text,
                                                    ),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                ),
                                                activeColor:
                                                    AppTheme.blue_app_color,
                                                groupValue: id,
                                                value: data.id,
                                                onChanged: (val) {
                                                  setState(() {
                                                    myAddress = data.street;
                                                    chooseLat =
                                                        double.parse(data.lat);
                                                    chooseLng =
                                                        double.parse(data.lng);
                                                    id = data.id;
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                              height: 1,
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              color: AppTheme
                                                  .black_linear_category,
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            )
                          : Container();
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: MapAddressScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 31,
                      color: AppTheme.white,
                      margin: EdgeInsets.only(
                          left: 25, right: 16, top: 20, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 21,
                            width: 21,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: AppTheme.blue_app_color,
                            ),
                          ),
                          SizedBox(width: 25),
                          Text(
                            translate("orders.new_address"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: AppTheme.blue_app_color,
                            ),
                          )
                        ],
                      ),
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
                            payment_id: snapshot.data.paymentTypes[i].id,
                            card_id: snapshot.data.paymentTypes[i].card_id,
                            card_token:
                                snapshot.data.paymentTypes[i].card_token,
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
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 24),
                                    child: Text(
                                      translate("address.choose_time"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRoboto,
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
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
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
                                  fontFamily: AppTheme.fontRoboto,
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
                                itemCount: snapshot
                                    .data
                                    .shippingTimes[positionId]
                                    .descriptions
                                    .length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 16, bottom: 16),
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
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
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
                              location: chooseLat.toString() +
                                  "," +
                                  chooseLng.toString(),
                              device: Platform.isIOS ? "IOS" : "Android",
                              address: myAddress,
                              type: "shipping",
                              shipping_time: shippingId,
                              drugs: drugs,
                            ),
                            Repository()
                                .fetchCreateOrder(createOrder)
                                .then((response) => {
                                      if (response.status == 1)
                                        {
                                          setState(() {
                                            loading = false;
                                            error = false;
                                          }),
                                          for (int i = 0;
                                              i < dataBaseValue.length;
                                              i++)
                                            {
                                              if (dataBaseValue[i].favourite)
                                                {
                                                  dataBaseValue[i].cardCount =
                                                      0,
                                                  dataBase.updateProduct(
                                                      dataBaseValue[i])
                                                }
                                              else
                                                {
                                                  dataBase.deleteProducts(
                                                      dataBaseValue[i].id)
                                                }
                                            },
                                          if (isOpenCategory)
                                            RxBus.post(AllItemIsOpen(true),
                                                tag:
                                                    "EVENT_ITEM_LIST_CATEGORY"),
                                          if (isOpenBest)
                                            RxBus.post(AllItemIsOpen(true),
                                                tag: "EVENT_ITEM_LIST"),
                                          if (isOpenIds)
                                            RxBus.post(AllItemIsOpen(true),
                                                tag: "EVENT_ITEM_LIST_IDS"),
                                          if (isOpenSearch)
                                            RxBus.post(AllItemIsOpen(true),
                                                tag: "EVENT_ITEM_LIST_SEARCH"),
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: OrderCardCurerScreen(
                                                orderId: response.orderId,
                                                price: response.data.total,
                                                cash: response.data.cash,
                                                deliveryPrice:
                                                    response.data.deliverySum,
                                              ),
                                            ),
                                          ),
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
                                    }),
                          });
                    } else {
                      setState(() {
                        error = true;
                        error_text = translate("not_time");
                      });
                    }
                  } else {
                    setState(() {
                      error = true;
                      error_text = translate("not_address");
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

  Future<void> _getLanguage() async {
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
