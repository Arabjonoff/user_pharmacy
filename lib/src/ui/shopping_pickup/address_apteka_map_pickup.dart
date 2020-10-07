import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart' as placemark;
import '../../app_theme.dart';
import 'order_card_pickup.dart';

class AddressAptekaMapPickupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaMapPickupScreenState();
  }
}

class _AddressAptekaMapPickupScreenState
    extends State<AddressAptekaMapPickupScreen> {
  YandexMapController mapController;
  Point _point;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  final List<placemark.Placemark> placemarks = <placemark.Placemark>[];
  DatabaseHelper dataBase = new DatabaseHelper();

  var myLongitude, myLatitude;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    //_getPosition();
    //   _addMarkerData(widget.data);
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
    if (placemarks != null)
      for (int i = 0; i < placemarks.length; i++)
        await mapController.removePlacemark(placemarks[i]);
    response.then((somedata) {
      if (somedata != null) _addMarkerData(somedata);
    });
  }

  void _addMarkerData(List<LocationModel> data) {
    for (int i = 0; i < data.length; i++) {
      mapController.addPlacemark(placemark.Placemark(
        point: Point(
          latitude: data[i].location.coordinates[1],
          longitude: data[i].location.coordinates[0],
        ),
        opacity: 1,
        iconName: 'assets/map/selected_order.png',
        onTap: (double latitude, double longitude) => {
          //BottomDialog.mapBottom(data[i], context),
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                margin: EdgeInsets.only(left: 4, right: 4, bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: Container(
                    height: 252,
                    color: AppTheme.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          height: 4,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.bottom_dialog,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12, top: 25),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data[i].name,
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
                              Text(
                                data[i].distance.toString() + " m",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_transparent_text,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                          width: double.infinity,
                          child: Text(
                            data[i].address,
                            textAlign: TextAlign.start,
                            maxLines: 1,
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
                          margin: EdgeInsets.only(left: 12, right: 12, top: 17),
                          child: Row(
                            children: [
                              Text(
                                translate("map.work") + " : ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_transparent_text,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Text(
                                  data[i].mode,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                          child: Row(
                            children: [
                              Text(
                                translate("auth.number_auth") + " : ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_transparent_text,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Text(
                                  data[i].phone,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.blue_app_color,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: OrderCardPickupScreen(AptekaModel(
                                      data[i].id,
                                      data[i].name,
                                      data[i].address,
                                      data[i].mode,
                                      data[i].phone,
                                      data[i].location.coordinates[1],
                                      data[i].location.coordinates[0],
                                      false,
                                    )),
                                  ),
                                );
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
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        },
      ));
    }
  }

  Future<void> _getPosition() async {
    AccessStore addModel = new AccessStore();
    List<ProductsStore> drugs = new List();
    dataBase.getProdu(true).then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              drugs.add(
                  ProductsStore(drugId: value[i].id, qty: value[i].cardCount))
            },
        });

    if (lat == null && lng == null) {
      geolocator.getPositionStream(locationOptions).listen((Position position) {
        if (position != null) {
          lat = position.latitude;
          lng = position.longitude;
          addModel = new AccessStore(lat: lat, lng: lng, products: drugs);
          _addMarkers(Repository().fetchAccessApteka(addModel));
          _point = new Point(
              latitude: position.latitude, longitude: position.longitude);
          mapController.move(
            point: _point,
            zoom: 11,
            animation: const MapAnimation(smooth: true, duration: 0.5),
          );
        } else {
          addModel =
              new AccessStore(lat: 41.311081, lng: 69.240562, products: drugs);
          _addMarkers(Repository().fetchAccessApteka(addModel));
          mapController.move(
            point: Point(latitude: 41.311081, longitude: 69.240562),
            zoom: 11,
            animation: const MapAnimation(smooth: true, duration: 0.5),
          );
        }
      });
    } else {
      addModel = new AccessStore(lat: lat, lng: lng, products: drugs);
      _addMarkers(Repository().fetchAccessApteka(addModel));
      _point = new Point(latitude: lat, longitude: lng);
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
      if (mapController != null)
        mapController.showUserLayer(
          iconName: 'assets/map/user.png',
          arrowName: 'assets/map/arrow.png',
          accuracyCircleFillColor: Colors.blue.withOpacity(0.5),
        );
      _getPosition();
//      _getLocation();
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
