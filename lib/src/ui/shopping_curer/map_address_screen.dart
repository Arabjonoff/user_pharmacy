import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/blocs/order_options_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/send/check_order.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/shopping_pickup/order_card_pickup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart' as placemark;

import '../../app_theme.dart';
import 'order_card_curer.dart';

class MapAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapAddressScreenState();
  }
}

var myLongitude, myLatitude;
List<PaymentTypes> paymentTypes;
int realShippingId;

class _MapAddressScreenState extends State<MapAddressScreen> {
  bool loading = false;
  int shippingId;
  YandexMapController controller;
  placemark.Placemark lastPlaceMark;
  Point _point;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getLanguage();
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

  Future<void> _getPosition() async {
    if (lat == null && lng == null) {
      geolocator.getPositionStream(locationOptions).listen(
        (Position position) {
          if (position != null) {
            lng = position.longitude;
            lat = position.latitude;
            _point = new Point(
                latitude: position.latitude, longitude: position.longitude);
            controller.move(
              point: _point,
              zoom: 12,
              animation: const MapAnimation(smooth: true, duration: 0.5),
            );
          }
        },
      );
    } else {
      _point = new Point(latitude: lat, longitude: lng);
      controller.move(
        point: _point,
        zoom: 12,
        animation: const MapAnimation(smooth: true, duration: 0.5),
      );
    }
  }

  Future<void> addMarker() async {
    final Point currentTarget = await controller.enableCameraTracking(
      placemark.Placemark(
        point: const Point(latitude: 0, longitude: 0),
        iconName: 'assets/map/user.png',
        opacity: 0.9,
      ),
      cameraPositionChanged,
    );
    await addUserPlacemark(currentTarget);
  }

  Future<void> cameraPositionChanged(dynamic arguments) async {
    final bool bFinal = arguments['final'];
    if (bFinal) {
      await addUserPlacemark(Point(
          latitude: arguments['latitude'], longitude: arguments['longitude']));
    }
  }

  Future<void> addUserPlacemark(Point point) async {
    if (lastPlaceMark != null) {
      controller.removePlacemark(lastPlaceMark);
    }
    lastPlaceMark = placemark.Placemark(
      point: point,
      iconName: 'assets/map/place.png',
      opacity: 0.9,
    );
    await controller.addPlacemark(
      lastPlaceMark,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      controller.showUserLayer(
          iconName: 'assets/map/user.png',
          arrowName: 'assets/map/arrow.png',
          accuracyCircleFillColor: Colors.blue.withOpacity(0.5));
      _getPosition();
      addMarker();
    }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 48,
              margin: EdgeInsets.only(bottom: 16, right: 12),
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
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(3),
                            child: SvgPicture.asset(
                                "assets/images/arrow_back.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
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
                bottom: 24,
                top: 16,
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
                              AptekaModel(-1, "", "", "", "", 0.0, 0.0, false),
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
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 4),
              child: Text(
                translate("address.choose_time"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: AppTheme.black_text,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: blocOrderOptions.orderOptions,
                builder: (context, AsyncSnapshot<OrderOptionsModel> snapshot) {
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
                      itemBuilder: (_, __) => Container(
                        height: 48,
                        padding: EdgeInsets.only(top: 6, bottom: 6),
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
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
            ),
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 16),
              child: Text(
                translate("address.choose_address"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: AppTheme.black_text,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                child: YandexMap(
                  onMapCreated:
                      (YandexMapController yandexMapController) async {
                    controller = yandexMapController;
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (shippingId != null) {
                  realShippingId = shippingId;
                  myLatitude = lastPlaceMark.point.latitude;
                  myLongitude = lastPlaceMark.point.longitude;

                  setState(() {
                    loading = true;
                  });

                  CheckOrderModel check = new CheckOrderModel();
                  List<Drugs> drugs = new List();

                  dataBase.getProdu(true).then((value) => {
                        for (int i = 0; i < value.length; i++)
                          {
                            drugs.add(Drugs(
                                drug: value[i].id, qty: value[i].cardCount))
                          },
                        check = new CheckOrderModel(
                          location: myLatitude.toString() +
                              "," +
                              myLongitude.toString(),
                          type: "shipping",
                          shipping_time: realShippingId,
                          drugs: drugs,
                        ),
                        Repository().fetchCheckOrder(check).then((response) => {
                              if (response.status == 1)
                                {
                                  setState(() {
                                    loading = false;
                                  }),
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.downToUp,
                                      child: OrderCardCurerScreen(
                                        response.data.address,
                                        response.data.total,
                                        response.data.deliverySum,
                                      ),
                                    ),
                                  ),
                                }
                              else
                                {
                                  setState(() {
                                    loading = false;
                                  }),
                                }
                            }),
                      });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: shippingId == null
                      ? AppTheme.blue_app_color_transparent
                      : AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 16,
                  left: 16,
                  right: 16,
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
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 17,
                            color: AppTheme.white,
                          ),
                        ),
                ),
              ),
            ),
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
