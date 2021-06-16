import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/check_order_model_new.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/order_card_curer.dart';

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
              translate("card.choose_store"),
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
      body: Stack(
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
                      // Repository()
                      //     .fetchCreateOrder(widget.createOrder)
                      //     .then(
                      //       (response) => {
                      //         if (response.status == 1)
                      //           {
                      //             dataBase.clear(),
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     OrderCardCurerScreen(
                      //                   orderId: response.data.orderId,
                      //                   price: response.data.total,
                      //                   cash: response.data.cash,
                      //                   deliveryPrice: response
                      //                           .data.isUserPay
                      //                       ? response.data.deliverySum
                      //                       : 0.0,
                      //                 ),
                      //               ),
                      //             ),
                      //           }
                      //         else
                      //           {
                      //             setState(() {
                      //               loading = false;
                      //               error = response.msg;
                      //             }),
                      //           }
                      //       },
                      //     );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Row(
                            children: [
                              SizedBox(width: 16),
                              Image.asset(
                                "assets/img/store.png",
                                height: 64,
                                width: 64,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.checkOrderModel.data.stores[index].name,
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
                                      widget.checkOrderModel.data.stores[index].address,
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
                          SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(width: 16),
                              Text(
                                translate("card.phone"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.3,
                                  color: AppTheme.textGray,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                "Utils.numberFormat(snapshot.data[index].phone)",
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.6,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(width: 16),
                              Text(
                                translate("card.price"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.3,
                                  color: AppTheme.textGray,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                priceFormat.format(widget.checkOrderModel.data.stores[index].total) +
                                    translate("sum"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.6,
                                  color: AppTheme.text_dark,
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
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                color: AppTheme.blue_app_color,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  translate("card.choose_store_info"),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppTheme.white,
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.checkOrderModel.data.stores[index].name,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.black_text,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.checkOrderModel.data.stores[index].address,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
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
                                  fontFamily: AppTheme.fontRubik,
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
                                    priceFormat.format(widget.checkOrderModel
                                            .data.stores[index].total) +
                                        translate("sum"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
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
                                  fontFamily: AppTheme.fontRubik,
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
                                    priceFormat.format(widget.checkOrderModel
                                            .data.stores[index].deliverySum) +
                                        translate("sum"),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
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
                                  fontFamily: AppTheme.fontRubik,
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
                                    widget.checkOrderModel.data.stores[index]
                                        .text,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
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
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    error,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
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
    );
  }
}
