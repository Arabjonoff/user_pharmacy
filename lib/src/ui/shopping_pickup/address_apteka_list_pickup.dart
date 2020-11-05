import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/blocs/aptek_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/eventBus/all_item_isopen.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import 'order_card_pickup.dart';

class AddressAptekaListPickupScreen extends StatefulWidget {
  List<ProductsStore> drugs;

  AddressAptekaListPickupScreen(this.drugs);

  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaListPickupScreenState();
  }
}

class _AddressAptekaListPickupScreenState
    extends State<AddressAptekaListPickupScreen>
    with AutomaticKeepAliveClientMixin<AddressAptekaListPickupScreen> {
  @override
  bool get wantKeepAlive => true;

  DatabaseHelperApteka db = new DatabaseHelperApteka();
  DatabaseHelper dataBase = new DatabaseHelper();

  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  var geolocator = Geolocator();
  static StreamSubscription _getPosSub;

  bool loading = false;

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    _getPosSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      _getLocation();
    } else {
      _defaultLocation();
    }
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: StreamBuilder(
        stream: blocApteka.allExistStorea,
        builder: (context, AsyncSnapshot<List<AptekaModel>> snapshot) {
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data[index].name,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              child: Container(
                                child: snapshot.data[index].fav
                                    ? Icon(
                                        Icons.favorite,
                                        size: 24,
                                        color: AppTheme.red_fav_color,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 24,
                                        color: AppTheme.arrow_catalog,
                                      ),
                              ),
                              onTap: () {
                                if (!snapshot.data[index].fav) {
                                  db.saveProducts(snapshot.data[index]);
                                  setState(() {
                                    snapshot.data[index].fav = true;
                                  });
                                } else {
                                  db.deleteProducts(snapshot.data[index].id);
                                  setState(() {
                                    snapshot.data[index].fav = false;
                                  });
                                }
                              },
                            ),
                          ],
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
                            fontFamily: AppTheme.fontRoboto,
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
                                snapshot.data[index].open,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
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
                              child: Text(
                                snapshot.data[index].number,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
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
                                  fontFamily: AppTheme.fontRoboto,
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
                                  fontFamily: AppTheme.fontRoboto,
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
                                  store_id: snapshot.data[index].id,
                                  drugs: drugs,
                                ),
                                Repository()
                                    .fetchCreateOrder(createOrder)
                                    .then((response) => {
                                          if (response.status == 1)
                                            {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: OrderCardPickupScreen(
                                                      response.orderId),
                                                ),
                                              ),
                                              setState(() {
                                                loading = false;
                                              }),
                                              for (int i = 0;
                                                  i < dataBaseValue.length;
                                                  i++)
                                                {
                                                  if (dataBaseValue[i]
                                                      .favourite)
                                                    {
                                                      dataBaseValue[i]
                                                          .cardCount = 0,
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
                                                    tag:
                                                        "EVENT_ITEM_LIST_SEARCH"),
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
                                                                .fontRoboto,
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
                                                                .fontRoboto,
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
                                fontFamily: AppTheme.fontRoboto,
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
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.location
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    setState(() {
      _permissionStatus = permissionRequestResult[PermissionGroup.location];
    });
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      locationPermissionLevel: GeolocationPermission.locationWhenInUse,
    );
    if (position.latitude != null && position.longitude != null) {
      lat = position.latitude;
      lng = position.longitude;
      Utils.saveLocation(lat, lng);
      AccessStore addModel =
          new AccessStore(lat: lat, lng: lng, products: widget.drugs);
      blocApteka.fetchAccessApteka(addModel);
    } else {
      AccessStore addModel =
          new AccessStore(lat: null, lng: null, products: widget.drugs);
      blocApteka.fetchAccessApteka(addModel);
    }
  }

  Future<void> _defaultLocation() async {
    AccessStore addModel =
        new AccessStore(lat: null, lng: null, products: widget.drugs);
    blocApteka.fetchAccessApteka(addModel);
  }
}
