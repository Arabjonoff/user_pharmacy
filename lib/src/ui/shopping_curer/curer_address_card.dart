import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/map_address_screen.dart';
import 'package:pharmacy/src/ui/shopping_pickup/order_card_pickup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

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

double chooseLat,chooseLng;

class _CurerAddressCardScreenState extends State<CurerAddressCardScreen> {
  DatabaseHelperAddress db = new DatabaseHelperAddress();

  int shippingId;
  int id = 1;

  List<CheckboxList> nList = new List();
  List<AddressModel> data = new List();

  @override
  void initState() {
    _getLanguage();
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
            Expanded(
              child: ListView(
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
                  Container(
                    margin: EdgeInsets.only(
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
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: OrderCardPickupScreen(
                                    AptekaModel(
                                        -1, "", "", "", "", 0.0, 0.0, false),
                                  ),
                                ),
                              );
                            },
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
                        address = snapshot.data[0].street;
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
                                              address = data.number;
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
                                  child: MapAddressScreen(),
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
                  Container(
                    margin: EdgeInsets.only(
                        left: 16, right: 16, bottom: 4, top: 25),
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
                  ),
                  StreamBuilder(
                    stream: blocOrderOptions.orderOptions,
                    builder:
                        (context, AsyncSnapshot<OrderOptionsModel> snapshot) {
                      if (snapshot.hasData) {
                        paymentTypes = new List();
                        paymentTypes.addAll(snapshot.data.paymentTypes);
                        return Column(
                          children: snapshot.data.shippingTimes
                              .map((data) => RadioListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${data.name}",
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
                                        SizedBox(
                                          width: 9,
                                        ),
                                        Text(
                                          data.isUserPay
                                              ? priceFormat.format(data.price) +
                                                  translate("sum_km")
                                              : translate("address.free"),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontFamily: AppTheme.fontRoboto,
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    activeColor: AppTheme.blue_app_color,
                                    groupValue: shippingId,
                                    value: data.id,
                                    onChanged: (val) {
                                      setState(() {
                                        shippingId = data.id;
                                      });
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
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print(address);
                shippedId = shippingId;
                print(shippedId);
                print(paymentTypes.length);

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
