import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/eventBus/card_item_change_model.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/map_address_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/order_card_curer.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_pickup_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import '../shopping_curer/curer_address_card.dart';
import '../shopping_web_screen.dart';

// ignore: must_be_immutable
class OrderCardPickupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderCardPickupScreenState();
  }
}

AptekaModel aptekaModel;

class CheckboxList {
  String number;
  int index;

  CheckboxList({this.number, this.index});
}

class _OrderCardPickupScreenState extends State<OrderCardPickupScreen> {
  double allPrice = 0;
  int paymentType;

  String fullName = "";
  String number = "";

  bool loading = false;
  bool error = false;
  bool edit = true;

  String error_text = "";

  DatabaseHelper dataBase = new DatabaseHelper();
  DateTime date = new DateTime.now();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+998 ## ### ## ##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    blocCard.fetchAllCard();
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
                      translate("orders.chechout"),
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
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: CurerAddressCardScreen(),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.only(
                right: 16,
                top: 24,
                left: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppTheme.white,
                ),
//                child: StreamBuilder(
//                  stream: blocCard.allCard,
//                  builder: (context, AsyncSnapshot<List<ItemResult>> snapshot) {
//                    if (snapshot.hasData) {
////                      allPrice = 0.0;
////                      for (int i = 0; i < snapshot.data.length; i++) {
////                        allPrice += (snapshot.data[i].cardCount *
////                            snapshot.data[i].price);
////                      }
////                      print(allPrice);
//                      return Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          aptekaModel == null
//                              ? Container(
//                                  margin: EdgeInsets.only(
//                                      top: 16, bottom: 3, left: 16, right: 16),
//                                  child: Text(
//                                    translate("orders.to_picup"),
//                                    maxLines: 1,
//                                    style: TextStyle(
//                                      fontWeight: FontWeight.w600,
//                                      fontSize: 16,
//                                      fontStyle: FontStyle.normal,
//                                      color: AppTheme.black_text,
//                                      fontFamily: AppTheme.fontRoboto,
//                                    ),
//                                  ),
//                                )
//                              : Container(
//                                  margin: EdgeInsets.only(
//                                      top: 24, left: 16, right: 16),
//                                  child: Text(
//                                    aptekaModel.address,
//                                    overflow: TextOverflow.ellipsis,
//                                    maxLines: 2,
//                                    style: TextStyle(
//                                      fontWeight: FontWeight.normal,
//                                      fontSize: 13,
//                                      fontStyle: FontStyle.normal,
//                                      color: AppTheme.black_text,
//                                      fontFamily: AppTheme.fontRoboto,
//                                    ),
//                                  ),
//                                ),
//                          aptekaModel == null
//                              ? Container()
//                              : Container(
//                                  margin: EdgeInsets.only(
//                                      bottom: 3, left: 16, right: 16),
//                                  child: Text(
//                                    translate("orders.now") +
//                                        ", " +
//                                        aptekaModel.open,
//                                    overflow: TextOverflow.ellipsis,
//                                    maxLines: 1,
//                                    style: TextStyle(
//                                      fontWeight: FontWeight.normal,
//                                      fontSize: 13,
//                                      fontStyle: FontStyle.normal,
//                                      color: AppTheme.black_text,
//                                      fontFamily: AppTheme.fontRoboto,
//                                    ),
//                                  ),
//                                ),
//                          GestureDetector(
//                            child: Container(
//                              margin: EdgeInsets.only(
//                                  left: 16, right: 16, bottom: 16, top: 16),
//                              width: 150,
//                              decoration: BoxDecoration(
//                                color: aptekaModel == null
//                                    ? AppTheme.blue_app_color
//                                    : AppTheme.white,
//                                borderRadius: BorderRadius.circular(10.0),
//                                border: aptekaModel == null
//                                    ? Border.all(
//                                        color: AppTheme.blue_app_color,
//                                        width: 0.0,
//                                      )
//                                    : Border.all(
//                                        color: AppTheme.blue_app_color,
//                                        width: 2.0,
//                                      ),
//                              ),
//                              child: Center(
//                                child: Text(
//                                  aptekaModel == null
//                                      ? translate("orders.edit_aptek_choose")
//                                      : translate("orders.edit_aptek"),
//                                  style: TextStyle(
//                                    fontFamily: AppTheme.fontRoboto,
//                                    fontStyle: FontStyle.normal,
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.w600,
//                                    color: aptekaModel == null
//                                        ? AppTheme.white
//                                        : AppTheme.blue_app_color,
//                                  ),
//                                ),
//                              ),
//                              padding: EdgeInsets.only(
//                                  left: 12, right: 12, top: 8, bottom: 8),
//                            ),
//                            onTap: () {
//                              Navigator.pushReplacement(
//                                context,
//                                PageTransition(
//                                  type: PageTransitionType.rightToLeft,
//                                  child: AddressAptekaPickupScreen(),
//                                ),
//                              );
//                            },
//                          )
//                        ],
//                      );
//                    } else if (snapshot.hasError) {
//                      return Text(snapshot.error.toString());
//                    }
//                    return Container();
//                  },
//                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    aptekaModel == null
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 16, bottom: 3, left: 16, right: 16),
                            child: Text(
                              translate("orders.to_picup"),
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_text,
                                fontFamily: AppTheme.fontRoboto,
                              ),
                            ),
                          )
                        : Container(
                            margin:
                                EdgeInsets.only(top: 24, left: 16, right: 16),
                            child: Text(
                              aptekaModel.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_text,
                                fontFamily: AppTheme.fontRoboto,
                              ),
                            ),
                          ),
                    aptekaModel == null
                        ? Container()
                        : Container(
                            margin:
                                EdgeInsets.only(bottom: 3, left: 16, right: 16),
                            child: Text(
                              translate("orders.now") + ", " + aptekaModel.open,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_text,
                                fontFamily: AppTheme.fontRoboto,
                              ),
                            ),
                          ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 16),
                        width: 150,
                        decoration: BoxDecoration(
                          color: aptekaModel == null
                              ? AppTheme.blue_app_color
                              : AppTheme.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: aptekaModel == null
                              ? Border.all(
                                  color: AppTheme.blue_app_color,
                                  width: 0.0,
                                )
                              : Border.all(
                                  color: AppTheme.blue_app_color,
                                  width: 2.0,
                                ),
                        ),
                        child: Center(
                          child: Text(
                            aptekaModel == null
                                ? translate("orders.edit_aptek_choose")
                                : translate("orders.edit_aptek"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: aptekaModel == null
                                  ? AppTheme.white
                                  : AppTheme.blue_app_color,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: AddressAptekaPickupScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 24,
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Row(
                children: [
                  Text(
                    translate("orders.your_data"),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black_text,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  edit
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              edit = false;
                            });
                          },
                          child: Text(
                            translate("orders.edit"),
                            style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRoboto,
                                color: AppTheme.blue_app_color),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            edit
                ? Container(
                    margin: EdgeInsets.only(top: 26, left: 16, right: 16),
                    child: Text(
                      fullName,
                      style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: AppTheme.black_catalog),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 26, left: 3, right: 3),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRoboto,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: AppTheme.black_catalog,
                      ),
                      controller: fullNameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 3, left: 16, right: 16),
              child: Text(
                translate("orders.name"),
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: AppTheme.black_transparent_text),
              ),
            ),
            edit
                ? Container(
                    margin: EdgeInsets.only(top: 26, left: 16, right: 16),
                    child: Text(
                      number,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRoboto,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: AppTheme.black_catalog,
                      ),
                    ),
                  )
                : TextFormField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: AppTheme.black_catalog,
                    ),
                    controller: numberController,
                    inputFormatters: [maskFormatter],
                    decoration: InputDecoration(
                      hintText: translate("orders.number"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AppTheme.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 3, left: 16, right: 16),
              child: Text(
                translate("orders.number"),
                style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: AppTheme.black_transparent_text),
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
            (paymentTypes != null && paymentTypes.length > 0)
                ? Column(
                    children: paymentTypes
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
                                ],
                              ),
                              activeColor: AppTheme.blue_app_color,
                              groupValue: paymentType,
                              value: data.id,
                              onChanged: (val) {
                                setState(() {
                                  paymentType = data.id;
                                });
                              },
                            ))
                        .toList(),
                  )
                : Container(),
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
//            Container(
//              margin: EdgeInsets.only(
//                top: 23,
//                left: 16,
//                right: 16,
//              ),
//              child: Row(
//                children: [
//                  Text(
//                    translate("card.all_card"),
//                    style: TextStyle(
//                      fontSize: 13,
//                      fontFamily: AppTheme.fontRoboto,
//                      fontWeight: FontWeight.normal,
//                      color: AppTheme.black_transparent_text,
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(),
//                  ),
//                  Text(
//                    allCount.toString(),
//                    style: TextStyle(
//                      fontSize: 13,
//                      fontFamily: AppTheme.fontRoboto,
//                      fontWeight: FontWeight.normal,
//                      color: AppTheme.black_transparent_text,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Container(
//              margin: EdgeInsets.only(
//                top: 18,
//                left: 16,
//                right: 16,
//              ),
//              child: Row(
//                children: [
//                  Text(
//                    translate("card.tovar_sum"),
//                    style: TextStyle(
//                      fontSize: 13,
//                      fontFamily: AppTheme.fontRoboto,
//                      fontWeight: FontWeight.normal,
//                      color: AppTheme.black_transparent_text,
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(),
//                  ),
//                  Text(
//                    priceFormat.format(allPrice) + translate(translate("sum")),
//                    style: TextStyle(
//                      fontSize: 13,
//                      fontFamily: AppTheme.fontRoboto,
//                      fontWeight: FontWeight.normal,
//                      color: AppTheme.black_transparent_text,
//                    ),
//                  ),
//                ],
//              ),
//            ),
            Container(
              margin: EdgeInsets.only(
                top: 26,
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
            Container(
              height: 1,
              margin: EdgeInsets.only(top: 35),
              color: AppTheme.black_linear_category,
            ),
            GestureDetector(
              onTap: () {
                if (!loading) {
                  if (aptekaModel != null && paymentType != null) {
                    setState(() {
                      loading = true;
                    });

                    if (fullNameController.text.isNotEmpty) {
                      fullName = fullNameController.text;
                    }
                    var num = numberController.text
                        .replaceAll('+', '')
                        .replaceAll(' ', '');
                    if (num.length == 12) {
                      number = numberController.text;
                    }

                    AddOrderModel addModel = new AddOrderModel();
                    List<Drugs> drugs = new List();
                    dataBase.getProdu(true).then((value) => {
                          for (int i = 0; i < value.length; i++)
                            {
                              drugs.add(Drugs(
                                  drug: value[i].id, qty: value[i].cardCount))
                            },
                          addModel = new AddOrderModel(
                            type: "self",
                            full_name: fullName,
                            phone: number,
                            store_id: aptekaModel.id,
                            payment_type: paymentType,
                            drugs: drugs,
                          ),
                          Repository()
                              .fetchRAddOrder(addModel)
                              .then((response) => {
                                    if (response.status == 1)
                                      {
                                        setState(() {
                                          loading = false;
                                          error = false;
                                        }),
                                        for (int i = 0; i < value.length; i++)
                                          {
                                            if (value[i].favourite)
                                              {
                                                value[i].cardCount = 0,
                                                dataBase.updateProduct(value[i])
                                              }
                                            else
                                              {
                                                dataBase
                                                    .deleteProducts(value[i].id)
                                              }
                                          },
                                        RxBus.post(CardItemChangeModel(true),
                                            tag: "EVENT_CARD"),
                                        if (response.data.return_url != "")
                                          {
                                            Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child: ShoppingWebScreen(
                                                    response.data.return_url),
                                              ),
                                            )
                                          }
                                        else
                                          {
                                            Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child: HistoryOrderScreen(),
                                              ),
                                            )
                                          }
                                      }
                                    else
                                      {
                                        setState(() {
                                          error = true;
                                          loading = false;
                                          error_text = translate("not_product");
                                        }),
                                      }
                                  }),
                        });
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: (aptekaModel == null || paymentType == null)
                      ? AppTheme.blue_app_color_transparent
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
    Repository().databaseCardItem(true).then((value) => {
          allPrice = 0,
          setState(() {
            for (int i = 0; i < value.length; i++) {
              allPrice += (value[i].cardCount * value[i].price);
            }
          }),
        });
    setState(() {
      var num = "+";
      for (int i = 0; i < prefs.getString("number").length; i++) {
        if (i == 3 || i == 5 || i == 8 || i == 10) {
          num += " ";
        }
        num += prefs.getString("number")[i];
      }
      number = num;

      var name = prefs.getString("name");
      var surName = prefs.getString("surname");

      fullName = name + " " + surName;
      fullNameController.text = name + " " + surName;
    });
  }
}
