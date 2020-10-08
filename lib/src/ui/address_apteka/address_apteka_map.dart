import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
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

class _AddressAptekaMapScreenState extends State<AddressAptekaMapScreen> {
  YandexMapController mapController;
  Point _point;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  var geolocator = Geolocator();
  var geolocatornew = Geolocator();
  static StreamSubscription _getPosSub;
  final List<placemark.Placemark> placemarks = <placemark.Placemark>[];

  var myLongitude, myLatitude;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    mapController.dispose();
    _getPosSub?.cancel();
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

  void _addMarkers(Future<List<LocationModel>> response) async {
    if (placemarks != null && response != null)
      for (int i = 0; i < placemarks.length; i++)
        await mapController.removePlacemark(placemarks[i]);
    response.then((somedata) {
      _addMarkerData(somedata);
    });
  }

  void _addMarkerData(List<LocationModel> data) {
    if (data != null)
      for (int i = 0; i < data.length; i++) {
        mapController.addPlacemark(
          placemark.Placemark(
            point: Point(
              latitude: data[i].location.coordinates[1],
              longitude: data[i].location.coordinates[0],
            ),
            opacity: 1.0,
            iconName: 'assets/map/selected_order.png',
            onTap: (double latitude, double longitude) => {
              BottomDialog.mapBottom(data[i], context),
            },
          ),
        );
      }
  }

  Future<void> _getPosition() async {
    if (lat == 41.311081 && lng == 69.240562) {
      _getPosSub = geolocator
          .getPositionStream(LocationOptions(
              accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10))
          .listen((Position position) {
        if (position != null) {
          lat = position.latitude;
          lng = position.longitude;
          _addMarkers(Repository().fetchApteka(lat, lng));
          _point = new Point(
              latitude: position.latitude, longitude: position.longitude);
          mapController.move(
            point: _point,
            zoom: 11,
            animation: const MapAnimation(smooth: true, duration: 0.5),
          );
        } else {
          _addMarkers(Repository().fetchApteka(41.311081, 69.240562));
          mapController.move(
            point: Point(latitude: 41.311081, longitude: 69.240562),
            zoom: 11,
            animation: const MapAnimation(smooth: true, duration: 0.5),
          );
        }
      });
    } else {
      _point = new Point(latitude: lat, longitude: lng);
      _addMarkers(Repository().fetchApteka(lat, lng));
      mapController.move(
        point: _point,
        zoom: 11,
        animation: const MapAnimation(smooth: true, duration: 0.5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      _getPosition();
      if (mapController != null)
        mapController.showUserLayer(
          iconName: 'assets/map/user.png',
          arrowName: 'assets/map/arrow.png',
          accuracyCircleFillColor: Colors.blue.withOpacity(0.5),
        );
    }

    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              mapController = yandexMapController;
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                mapController.move(
                  point: _point,
                  animation: const MapAnimation(smooth: true, duration: 0.5),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 12, right: 12),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(18)),
                child: Icon(
                  Icons.my_location,
                  color: Color.fromRGBO(59, 62, 77, 1.0),
                  size: 28.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
