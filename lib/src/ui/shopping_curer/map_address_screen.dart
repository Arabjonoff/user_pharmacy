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
import 'package:pharmacy/src/database/database_helper_address.dart';
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
import 'curer_address_card.dart';
import 'order_card_curer.dart';

class MapAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapAddressScreenState();
  }
}

class _MapAddressScreenState extends State<MapAddressScreen> {
  YandexMapController controller;
  placemark.Placemark lastPlaceMark;
  Point _point;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  TextEditingController homeController = TextEditingController();

  DatabaseHelperAddress db = new DatabaseHelperAddress();

  @override
  void initState() {
    super.initState();
    _requestPermission();
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("orders.new_add_address"),
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
            Container(
              height: 56,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppTheme.auth_login,
                border: Border.all(
                  color: AppTheme.auth_border,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: AppTheme.fontRoboto,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.black_text,
                    fontSize: 15,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  controller: homeController,
                  decoration: InputDecoration(
                    labelText: translate('address.dom'),
                    labelStyle: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF6D7885),
                      fontSize: 11,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: AppTheme.auth_login,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: AppTheme.auth_login,
                      ),
                    ),
                  ),
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
                chooseLat = lastPlaceMark.point.latitude;
                chooseLng = lastPlaceMark.point.longitude;
                print(chooseLat);
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
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: Text(
                    translate("address.save_address"),
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
}
