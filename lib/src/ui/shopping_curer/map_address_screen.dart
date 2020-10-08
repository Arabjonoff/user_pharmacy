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

  // TextEditingController homeController = TextEditingController();

  DatabaseHelperAddress db = new DatabaseHelperAddress();

  bool error = false;
  bool isFirst = true;
  double height;
  String address = "";

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
    if (lat == 41.311081 && lng == 69.240562) {
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
          } else {
            _point = new Point(latitude: lat, longitude: lng);
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
        iconName: 'assets/map/location_red.png',
        opacity: 0.9,
      ),
      cameraPositionChanged,
    );
    await addUserPlacemark(currentTarget);
  }

  Future<void> cameraPositionChanged(dynamic arguments) async {
    if (lastPlaceMark != null) {
      controller.removePlacemark(lastPlaceMark);
    }
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
      iconName: 'assets/map/location_red.png',
      opacity: 0.9,
    );
    await controller.addPlacemark(
      lastPlaceMark,
    );
    var responce =
        Repository().fetchLocationAddress(point.latitude, point.longitude);
    responce.then((value) => {
          if (responce != null)
            {
              print(value.results[0].formattedAddress),
              if (value.results.length > 0)
                {
                  setState(() {
                    address = value.results[0].formattedAddress;
                  }),
                }
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    if (_permissionStatus == PermissionStatus.granted) {
      if (controller != null)
        controller.showUserLayer(
          iconName: 'assets/map/user.png',
          arrowName: 'assets/map/arrow.png',
          accuracyCircleFillColor: Colors.blue.withOpacity(0.5),
        );
      if (isFirst) {
        _getPosition();
        addMarker();
        isFirst = false;
      }
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
        padding: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 48,
              margin: EdgeInsets.only(bottom: 4),
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
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.downToUp,
                            child: CurerAddressCardScreen(false),
                          ),
                        );
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
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    YandexMap(
                      onMapCreated:
                          (YandexMapController yandexMapController) async {
                        controller = yandexMapController;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 24, right: 24, top: height / 5 - 15),
                      child: Text(
                        address,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRoboto,
                          fontSize: 20,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black_text,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          controller.move(
                            point: _point,
                            animation:
                                const MapAnimation(smooth: true, duration: 0.5),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16, right: 16),
                          width: 112,
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/icon_my_location.svg"),
                              SizedBox(width: 12),
                              Text(
                                translate("what_me"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (address != "") {
                  db.saveProducts(
                    AddressModel(
                      street: address,
                      lat: lastPlaceMark.point.latitude.toString(),
                      lng: lastPlaceMark.point.longitude.toString(),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: CurerAddressCardScreen(true),
                    ),
                  );
                } else {
                  setState(() {
                    error = true;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: address == ""
                      ? AppTheme.blue_app_color.withOpacity(0.3)
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
