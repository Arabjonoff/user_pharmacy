import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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

  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;
  String obj = "";

  _AddressAptekaMapScreenState() {
    searchController.addListener(() {
      if (searchController.text != obj) {
        if (searchController.text.length > 0) {
          setState(() {
            obj = searchController.text;
            isSearchText = true;
          });
        } else {
          setState(() {
            obj = "";
            isSearchText = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getLocation();
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
//        myLatitude = position.latitude;
//        myLongitude = position.longitude;
//        _addMarkers(API.getLocation(myLatitude, myLongitude));
      } else {
//        _addMarkers(API.getLocation(41.316452, 69.245773));
      }
    });
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

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 36,
                margin: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          color: AppTheme.black_transparent,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: new Icon(
                                Icons.search,
                                size: 24,
                                color: AppTheme.notWhite,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 36,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) {
//                                                Navigator.push(
//                                                  context,
//                                                  PageTransition(
//                                                    type:
//                                                        PageTransitionType.fade,
//                                                    child: ItemListScreen(
//                                                      translate(
//                                                          "search.result"),
//                                                      3,
//                                                      obj,
//                                                    ),
//                                                  ),
//                                                );
                                    },
                                    cursorColor: AppTheme.notWhite,
                                    style: TextStyle(
                                      color: AppTheme.black_text,
                                      fontSize: 15,
                                      fontFamily: AppTheme.fontRoboto,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: translate("search_real"),
                                      hintStyle: TextStyle(
                                        color: AppTheme.notWhite,
                                        fontSize: 15,
                                        fontFamily: AppTheme.fontRoboto,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    controller: searchController,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: YandexMap(
                onMapCreated: (YandexMapController yandexMapController) async {
                  mapController = yandexMapController;
                },
              )),
            ],
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
