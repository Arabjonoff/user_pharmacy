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
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  final List<placemark.Placemark> placemarks = <placemark.Placemark>[];

  var myLongitude, myLatitude;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getPosition();
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

  _getLocation() async {
    geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      if (position != null) {
        myLatitude = position.latitude;
        myLongitude = position.longitude;
        _addMarkers(Repository().fetchApteka());
      } else {
        _addMarkers(Repository().fetchApteka());
      }
    });
  }

  void _addMarkers(Future<List<LocationModel>> response) async {
    if (placemarks != null)
      for (int i = 0; i < placemarks.length; i++)
        await mapController.removePlacemark(placemarks[i]);
    response.then((somedata) {
      _addMarkerData(somedata);
    });
  }

  void _addMarkerData(List<LocationModel> data) {
    for (int i = 0; i < data.length; i++) {
      mapController.addPlacemark(placemark.Placemark(
        point: Point(
          latitude: data[i].location.coordinates[1],
          longitude: data[i].location.coordinates[0],
        ),
        opacity: 0.95,
        iconName: 'assets/map/user.png',
        onTap: (double latitude, double longitude) => {
          BottomDialog.mapBottom(data[i], context),
        },
      ));
    }
  }

  Future<void> _getPosition() async {
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        _point = new Point(
            latitude: position.latitude, longitude: position.longitude);
        mapController.move(
          point: _point,
          zoom: 12,
          animation: const MapAnimation(smooth: true, duration: 0.5),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      mapController.showUserLayer(
          iconName: 'assets/map/user.png',
          arrowName: 'assets/map/arrow.png',
          accuracyCircleFillColor: Colors.blue.withOpacity(0.5));
      _getPosition();
    }

    _getLocation();

    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              mapController = yandexMapController;
            },
          ),
//          Align(
//            alignment: Alignment.bottomRight,
//            child: Container(
//              margin: EdgeInsets.only(right: 16, bottom: 32),
//              width: 48,
//              height: 200,
//              child: Column(
//                children: <Widget>[
//                  IconButton(
//                    icon: Icon(
//                      Icons.add_circle_outline,
//                      color: Color.fromRGBO(59, 62, 77, 1.0),
//                      size: 36.0,
//                    ),
//                    onPressed: () {
//                      mapController.zoomIn();
//                    },
//                  ),
//                  IconButton(
//                    icon: Icon(
//                      Icons.remove_circle_outline,
//                      color: Color.fromRGBO(59, 62, 77, 1.0),
//                      size: 36.0,
//                    ),
//                    onPressed: () {
//                      mapController.zoomOut();
//                    },
//                  ),
//                  SizedBox(
//                    height: 36,
//                  ),
//                  IconButton(
//                    icon: Icon(
//                      Icons.my_location,
//                      color: Color.fromRGBO(59, 62, 77, 1.0),
//                      size: 36.0,
//                    ),
//                    onPressed: () {
//                      mapController.move(
//                        point: _point,
//                        animation:
//                            const MapAnimation(smooth: true, duration: 0.5),
//                      );
//                    },
//                  )
//                ],
//              ),
//            ),
//          )
        ],
      ),
    );
  }
}
