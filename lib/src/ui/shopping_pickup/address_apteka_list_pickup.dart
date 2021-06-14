import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/blocs/store_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import 'order_card_pickup.dart';

class AddressStoreListPickupScreen extends StatefulWidget {
  final List<ProductsStore> drugs;

  AddressStoreListPickupScreen(this.drugs);

  @override
  State<StatefulWidget> createState() {
    return _AddressStoreListPickupScreenState();
  }
}

class _AddressStoreListPickupScreenState
    extends State<AddressStoreListPickupScreen>
    with AutomaticKeepAliveClientMixin<AddressStoreListPickupScreen> {
  @override
  bool get wantKeepAlive => true;

  DatabaseHelper dataBase = new DatabaseHelper();

  bool loading = false;

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: StreamBuilder(
        stream: blocStore.allExistStore,
        builder: (context, AsyncSnapshot<List<LocationModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 16, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                        child: Text(
                          snapshot.data[index].name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6, left: 16, right: 16),
                        child: Text(
                          snapshot.data[index].address,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 19, left: 16, right: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data[index].mode,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  var url = "tel:" +
                                      snapshot.data[index].phone
                                          .replaceAll(" ", "")
                                          .replaceAll("-", "")
                                          .replaceAll("(", "")
                                          .replaceAll(")", "");
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Text(
                                  Utils.numberFormat(
                                    snapshot.data[index].phone
                                        .replaceAll(" ", "")
                                        .replaceAll("+", "")
                                        .replaceAll("-", "")
                                        .replaceAll("(", "")
                                        .replaceAll(")", ""),
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, bottom: 20, left: 16, right: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                translate("map.work"),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_transparent_text,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Text(
                                translate("auth.number_auth"),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_transparent_text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16),
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
                                priceFormat.format(snapshot.data[index].total) +
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
                          SizedBox(width: 16),
                        ],
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
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
                                  device: Platform.isIOS ? "IOS" : "Android",
                                  type: "self",
                                  storeId: snapshot.data[index].id,
                                  drugs: drugs,
                                ),
                                Repository()
                                    .fetchCreateOrder(createOrder)
                                    .then((response) => {
                                          if (response.status == 1)
                                            {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderCardPickupScreen(
                                                    response.data.orderId,
                                                    response
                                                        .data.expireSelfOrder,
                                                  ),
                                                ),
                                              ),
                                              setState(() {
                                                loading = false;
                                              }),
                                              dataBase.clear(),
                                            }
                                          else if (response.status == -1)
                                            {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    content: Container(
                                                      width: 239.0,
                                                      height: 64.0,
                                                      child: Center(
                                                        child: Text(
                                                          response.msg,
                                                          style: TextStyle(
                                                            fontFamily: AppTheme
                                                                .fontRubik,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: AppTheme
                                                                .black_text,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              setState(() {
                                                loading = false;
                                              }),
                                            }
                                          else
                                            {
                                              setState(() {
                                                loading = false;
                                              }),
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    content: Container(
                                                      width: 239.0,
                                                      height: 64.0,
                                                      child: Center(
                                                        child: Text(
                                                          response.msg == ""
                                                              ? translate(
                                                                  "error_distanse")
                                                              : response.msg,
                                                          style: TextStyle(
                                                            fontFamily: AppTheme
                                                                .fontRubik,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: AppTheme
                                                                .black_text,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            }
                                        }),
                              });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          margin:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.blue_app_color,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              translate("orders.map_add_order"),
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
                      )
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
              itemBuilder: (_, __) => Container(
                height: 124,
                margin: EdgeInsets.only(top: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              itemCount: 10,
            ),
          );
        },
      ),
    );
  }

  Future<void> _requestPermission() async {
    Permission.locationWhenInUse.request().then(
      (value) async {
        if (value.isGranted) {
          _getLocation();
        } else {
          _defaultLocation();
        }
      },
    );
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      Utils.saveLocation(position.latitude, position.longitude);
      AccessStore addModel = new AccessStore(
          lat: position.latitude,
          lng: position.longitude,
          products: widget.drugs);
      blocStore.fetchAccessStore(addModel);
    } else {
      AccessStore addModel =
          new AccessStore(lat: null, lng: null, products: widget.drugs);
      blocStore.fetchAccessStore(addModel);
    }
  }

  Future<void> _defaultLocation() async {
    AccessStore addModel =
        new AccessStore(lat: null, lng: null, products: widget.drugs);
    blocStore.fetchAccessStore(addModel);
  }
}
