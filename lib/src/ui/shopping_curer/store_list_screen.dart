import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/check_order_model_new.dart';
import 'package:pharmacy/src/model/eventBus/all_item_isopen.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/order_card_curer.dart';
import 'package:rxbus/rxbus.dart';

class StoreListScreen extends StatefulWidget {
  final CreateOrderModel createOrder;
  final CheckOrderModelNew checkOrderModel;

  StoreListScreen({this.createOrder, this.checkOrderModel});

  @override
  State<StatefulWidget> createState() {
    return _StoreListScreenState();
  }
}

class _StoreListScreenState extends State<StoreListScreen> {
  DatabaseHelper dataBase = new DatabaseHelper();
  bool loading = false;
  ScrollController _scrollController = new ScrollController();
  String error = "";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        ),
      ),
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
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        color: AppTheme.arrow_examp_back,
                        padding: EdgeInsets.all(13),
                        margin: EdgeInsets.only(left: 4),
                        child: SvgPicture.asset("assets/images/arrow_back.svg"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("choose_store"),
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
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
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
              child: Stack(
                children: [
                  ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: widget.checkOrderModel.data.stores.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return GestureDetector(
                            onTap: () {
                              widget.createOrder.storeId =
                                  widget.checkOrderModel.data.stores[index].id;
                              setState(() {
                                loading = true;
                              });
                              Repository()
                                  .fetchCreateOrder(widget.createOrder)
                                  .then(
                                    (response) => {
                                      if (response.status == 1)
                                        {
                                          dataBase.clear(),
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
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderCardCurerScreen(
                                                orderId: response.data.orderId,
                                                price: response.data.total,
                                                cash: response.data.cash,
                                                deliveryPrice: response
                                                        .data.isUserPay
                                                    ? response.data.deliverySum
                                                    : 0.0,
                                              ),
                                            ),
                                          ),
                                        }
                                      else
                                        {
                                          setState(() {
                                            loading = false;
                                            error = response.msg;
                                          }),
                                        }
                                    },
                                  );
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 24, left: 12, right: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 24,
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                  ),
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(
                                top: 20,
                                left: 16,
                                right: 16,
                                bottom: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.checkOrderModel.data
                                              .stores[index].name,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRoboto,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: AppTheme.black_text,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        ((widget
                                                            .checkOrderModel
                                                            .data
                                                            .stores[index]
                                                            .distance ~/
                                                        100) /
                                                    10.0)
                                                .toString() +
                                            " km",
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11,
                                          height: 1.3,
                                          color: AppTheme.search_empty,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.checkOrderModel.data.stores[index]
                                        .address,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: AppTheme.black_text,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        translate("order"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                          height: 1.3,
                                          color: AppTheme.search_empty,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Align(
                                          child: Text(
                                            priceFormat.format(widget
                                                    .checkOrderModel
                                                    .data
                                                    .stores[index]
                                                    .total) +
                                                translate("sum"),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppTheme.black_text,
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        translate("delivery"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                          height: 1.3,
                                          color: AppTheme.search_empty,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Align(
                                          child: Text(
                                            priceFormat.format(widget
                                                    .checkOrderModel
                                                    .data
                                                    .stores[index]
                                                    .deliverySum) +
                                                translate("sum"),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppTheme.black_text,
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        translate("time"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                          height: 1.3,
                                          color: AppTheme.search_empty,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Align(
                                          child: Text(
                                            widget.checkOrderModel.data
                                                .stores[index].text,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppTheme.black_text,
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 24,
                          left: 12,
                          right: 12,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            error,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              color: AppTheme.red_fav_color,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  loading
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: AppTheme.black_text.withOpacity(0.15),
                          child: Center(
                            child: Container(
                              height: 36,
                              width: 36,
                              child: CircularProgressIndicator(
                                backgroundColor: AppTheme.blue,
                                strokeWidth: 5.0,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
