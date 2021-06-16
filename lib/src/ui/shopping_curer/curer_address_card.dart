import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/blocs/store_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/check_order_model_new.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/shopping_curer/store_list_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class CurerAddressCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurerAddressCardScreenState();
  }
}

class _CurerAddressCardScreenState extends State<CurerAddressCardScreen> {
  int shippingId = 0;
  AddressModel myAddress;
  bool isFirst = true;
  var duration = Duration(milliseconds: 270);
  String firstName = "", lastName = "", number = "";
  bool loading = false;
  String errorText = "";

  DatabaseHelper dataBase = new DatabaseHelper();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _getFullName();
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
                                        ),
                                        SizedBox(width: 8),
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
                      if (isFirst && snapshot.data.shippingTimes.length > 0) {
                        isFirst = false;
                        shippingId = snapshot.data.shippingTimes[0].id;
                      }
                      return Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 24,
                                right: 24,
                              ),
                              child: Text(
                                translate("card.type"),
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
                              margin: EdgeInsets.only(top: 16),
                              height: 1,
                              width: double.infinity,
                              color: AppTheme.background,
                            ),
                            ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              itemCount: snapshot.data.shippingTimes.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (snapshot.data.shippingTimes[index].id !=
                                        shippingId) {
                                      setState(() {
                                        shippingId = snapshot
                                            .data.shippingTimes[index].id;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 16),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 8,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/time.svg"),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            snapshot
                                                .data.shippingTimes[index].name,
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
                                          curve: Curves.easeInOut,
                                          duration: duration,
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            color: AppTheme.background,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: shippingId ==
                                                      snapshot
                                                          .data
                                                          .shippingTimes[index]
                                                          .id
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
                                              color: shippingId ==
                                                      snapshot
                                                          .data
                                                          .shippingTimes[index]
                                                          .id
                                                  ? AppTheme.blue
                                                  : AppTheme.background,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(3),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 24,
                              right: 24,
                            ),
                            child: Text(
                              translate("card.type"),
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
                            margin: EdgeInsets.only(top: 16),
                            height: 1,
                            width: double.infinity,
                            color: AppTheme.background,
                          ),
                          ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            itemCount: 1,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Shimmer.fromColors(
                                child: Container(
                                  margin: EdgeInsets.only(top: 16),
                                  height: 48,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
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
                          translate("card.detail_user"),
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
                errorText != ""
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
          Container(
            color: AppTheme.white,
            padding: EdgeInsets.only(
              top: 12,
              left: 22,
              right: 22,
              bottom: 24,
            ),
            child: GestureDetector(
              onTap: () async {
                if (!loading && myAddress != null) {
                  setState(() {
                    loading = true;
                    errorText = "";
                  });

                  List<Drugs> drugs = new List();

                  var cardItem = await dataBase.getProdu(true);
                  for (int i = 0; i < cardItem.length; i++) {
                    drugs.add(Drugs(
                      drug: cardItem[i].id,
                      qty: cardItem[i].cardCount,
                    ));
                  }
                  CreateOrderModel createOrder = new CreateOrderModel(
                    location: myAddress.lat + "," + myAddress.lng,
                    device: Platform.isIOS ? "IOS" : "Android",
                    address: myAddress.street,
                    type: "shipping",
                    shippingTime: shippingId,
                    drugs: drugs,
                    fullName: firstName + " " + lastName,
                    phone: number,
                  );
                  var response =
                      await Repository().fetchCheckOrder(createOrder);
                  if (response.isSuccess) {
                    var result = CheckOrderModelNew.fromJson(response.result);
                    if (result.status == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreListScreen(
                            createOrder: createOrder,
                            checkOrderModel: result,
                          ),
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                    } else {
                      setState(() {
                        loading = false;
                        errorText = result.msg;
                      });
                    }
                  } else if (response.status == -1) {
                    setState(() {
                      loading = false;
                      errorText = translate("network.network_title");
                    });
                  } else {
                    setState(() {
                      loading = false;
                      errorText = response.result["msg"];
                    });
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: myAddress == null ? AppTheme.gray : AppTheme.blue,
                ),
                height: 44,
                width: double.infinity,
                child: Center(
                  child: loading
                      ? CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.white),
                        )
                      : Text(
                          translate("card.next"),
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

  Future<void> _getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('name') ?? "";
      lastName = prefs.getString('surname') ?? "";
      number = Utils.numberFormat(prefs.getString('number') ?? "");
    });
  }
}
