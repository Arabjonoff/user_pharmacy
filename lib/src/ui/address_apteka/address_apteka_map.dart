import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart' as placemark;
import '../../app_theme.dart';

var lat = 41.311081, lng = 69.240562;

class AddressAptekaMapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaMapScreenState();
  }
}

class _AddressAptekaMapScreenState extends State<AddressAptekaMapScreen>
    with AutomaticKeepAliveClientMixin<AddressAptekaMapScreen> {
  @override
  bool get wantKeepAlive => true;
  YandexMapController mapController;
  Point _point;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  final List<placemark.Placemark> placemarks = <placemark.Placemark>[];

  var myLongitude, myLatitude;
  bool isGranted = true;
  bool isLoading = true;
  bool isFirstGrant = true;
  bool isFirstDisabled = true;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
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

  Future<void> _updateLocation() async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.location
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    if (permissionRequestResult[PermissionGroup.location] ==
        PermissionStatus.granted) {
      Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        locationPermissionLevel: GeolocationPermission.locationWhenInUse,
      );
      if (position != null) {
        lat = position.latitude;
        lng = position.longitude;
        Utils.saveLocation(position.latitude, position.longitude);
        _point = new Point(
            latitude: position.latitude, longitude: position.longitude);
        mapController.move(
          point: _point,
          animation: const MapAnimation(smooth: true, duration: 0.5),
        );
        setState(() {
          isFirstGrant = false;
          isGranted = true;
        });
      }
    }
  }

  void _addMarkers(Future<List<LocationModel>> response) async {
    if (placemarks != null && response != null)
      for (int i = 0; i < placemarks.length; i++)
        await mapController.removePlacemark(placemarks[i]);
    response.then((somedata) {
      if (somedata != null) {
        _isLoading(false);
        _addMarkerData(somedata);
      } else {
        _isLoading(false);
      }
    });
  }

  void _isLoading(bool response) async {
    setState(() {
      isLoading = response;
    });
  }

  void _addMarkerData(List<LocationModel> data) {
    double latOr = 0.0, lngOr = 0.0;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        latOr += data[i].location.coordinates[1];
        lngOr += data[i].location.coordinates[0];
        mapController.addPlacemark(
          placemark.Placemark(
            point: Point(
              latitude: data[i].location.coordinates[1],
              longitude: data[i].location.coordinates[0],
            ),
            opacity: 1.0,
            iconName: 'assets/map/selected_order.png',
            onTap: (Point point) => {
              BottomDialog.mapBottom(data[i], context),
            },
          ),
        );
      }
      if (mapController != null)
        mapController.move(
          point: new Point(
              latitude: latOr / data.length, longitude: lngOr / data.length),
          zoom: 11,
          animation: const MapAnimation(smooth: true, duration: 0.5),
        );
    }
  }

  Future<void> _getPosition() async {
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      locationPermissionLevel: GeolocationPermission.locationWhenInUse,
    );
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      _addMarkers(
          Repository().fetchStore(position.latitude, position.longitude));
      Utils.saveLocation(position.latitude, position.longitude);
      _point =
          new Point(latitude: position.latitude, longitude: position.longitude);
    } else {
      _addMarkers(Repository().fetchStore(41.311081, 69.240562));
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      if (isFirstGrant) {
        isGranted = true;
        isFirstGrant = false;
        Timer(Duration(milliseconds: 250), () {
          _getPosition();
        });
        if (mapController != null) {
          mapController.showUserLayer(
            iconName: 'assets/map/user.png',
            arrowName: 'assets/map/arrow.png',
            accuracyCircleFillColor: Colors.blue.withOpacity(0.5),
          );
          mapController.move(
            point: Point(latitude: 41.311081, longitude: 69.240562),
            zoom: 11,
            animation: const MapAnimation(smooth: true, duration: 0.5),
          );
        }
      }
    } else if (_permissionStatus != PermissionStatus.unknown) {
      if (isFirstDisabled) {
        isGranted = false;
        isFirstDisabled = false;
        Timer(Duration(milliseconds: 500), () {
          _defaultLocation();
        });
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              mapController = yandexMapController;
            },
          ),
          isGranted
              ? Container()
              : GestureDetector(
                  onTap: () async {
                    if (_permissionStatus == PermissionStatus.disabled) {
                      AppSettings.openLocationSettings();
                    } else if (_permissionStatus == PermissionStatus.denied) {
                      await PermissionHandler().openAppSettings();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    width: double.infinity,
                    height: 72,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Color.fromRGBO(0, 0, 0, 0.12),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                          spreadRadius: 7,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/icon_map_disabled.svg"),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            translate("disabled"),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_text,
                              height: 1.4,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                if (_point != null) {
                  mapController.move(
                    point: _point,
                    animation: const MapAnimation(smooth: true, duration: 0.5),
                  );
                } else {
                  _updateLocation();
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16, right: 16),
                width:
                    (translate("what_me").length * 9 + 24 + 32 + 12).toDouble(),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/icon_my_location.svg"),
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
          ),
          isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color:
                          AppTheme.blue_app_color_transparent.withOpacity(0.3),
                    ),
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 5.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.blue_app_color),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> _defaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble("coordLat") != null) {
      _addMarkers(Repository().fetchStore(null, null));
      if (mapController != null) {
        mapController.move(
          point: Point(
              latitude: prefs.getDouble("coordLat"),
              longitude: prefs.getDouble("coordLng")),
          zoom: 11,
          animation: const MapAnimation(smooth: true, duration: 0.5),
        );
      }
    } else {
      _addMarkers(Repository().fetchStore(null, null));
      if (mapController != null) {
        mapController.move(
          point: Point(latitude: 41.311081, longitude: 69.240562),
          zoom: 11,
          animation: const MapAnimation(smooth: true, duration: 0.5),
        );
      }
    }
  }
}
