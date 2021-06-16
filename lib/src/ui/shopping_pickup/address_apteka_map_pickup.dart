import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/http_result.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart' as placemark;
import '../../app_theme.dart';

class AddressStoreMapPickupScreen extends StatefulWidget {
  final List<ProductsStore> drugs;
  final Function(LocationModel store) chooseStore;

  AddressStoreMapPickupScreen(
    this.drugs,
    this.chooseStore,
  );

  @override
  State<StatefulWidget> createState() {
    return _AddressStoreMapPickupScreenState();
  }
}

class _AddressStoreMapPickupScreenState
    extends State<AddressStoreMapPickupScreen>
    with AutomaticKeepAliveClientMixin<AddressStoreMapPickupScreen> {
  @override
  bool get wantKeepAlive => true;

  YandexMapController mapController;
  final List<placemark.Placemark> placemarks = <placemark.Placemark>[];
  DatabaseHelper dataBase = new DatabaseHelper();

  bool isGranted = true;
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            YandexMap(
              onMapCreated: (YandexMapController yandexMapController) async {
                mapController = yandexMapController;
              },
            ),
            Positioned(
              child: GestureDetector(
                onTap: () async {
                  Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.best,
                  ).then((position) async {
                    mapController.move(
                      point: Point(
                        latitude: position.latitude,
                        longitude: position.longitude,
                      ),
                      zoom: 16,
                      animation: const MapAnimation(
                        smooth: true,
                        duration: 0.5,
                      ),
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        translate("address.me"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: AppTheme.text_dark,
                        ),
                      ),
                      SizedBox(width: 5),
                      SvgPicture.asset("assets/icons/gps.svg")
                    ],
                  ),
                ),
              ),
              bottom: 12,
              right: 12,
            ),
            isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppTheme.blue.withOpacity(0.3),
                      ),
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 5.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.blue,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    Permission.locationWhenInUse.request().then(
      (value) async {
        if (value.isGranted) {
          _getPosition();
        } else {
          _defaultLocation();
        }
      },
    );
  }

  void _addMarkers(HttpResult response) async {
    if (response.isSuccess) {
      _isLoading(false);
      if (placemarks != null)
        for (int i = 0; i < placemarks.length; i++)
          await mapController.removePlacemark(placemarks[i]);
      _addMarkerData(locationModelFromJson(json.encode(response.result)));
    } else {
      _isLoading(false);
    }
  }

  void _isLoading(bool response) async {
    setState(() {
      isLoading = response;
    });
  }

  void _addMarkerData(List<LocationModel> data) {
    double latOr = 0.0, lngOr = 0.0;
    for (int i = 0; i < data.length; i++) {
      latOr += data[i].location.coordinates[1];
      lngOr += data[i].location.coordinates[0];

      mapController.addPlacemark(
        placemark.Placemark(
          point: Point(
            latitude: data[i].location.coordinates[1],
            longitude: data[i].location.coordinates[0],
          ),
          style: PlacemarkStyle(
            opacity: 1,
            iconName: 'assets/map/selected_order.png',
          ),
          onTap: (Placemark placemark, Point point) {
            BottomDialog.showStoreInfo(
              context,
              data[i],
              (value) {
                widget.chooseStore(value);
              },
            );
          },
        ),
      );
    }
    if (mapController != null)
      mapController.move(
        point: new Point(
          latitude: latOr / data.length,
          longitude: lngOr / data.length,
        ),
        zoom: 11,
        animation: const MapAnimation(smooth: true, duration: 0.5),
      );
  }

  Future<void> _getPosition() async {
    AccessStore addModel = new AccessStore();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      addModel = new AccessStore(
        lat: position.latitude,
        lng: position.longitude,
        products: widget.drugs,
      );
      Utils.saveLocation(position.latitude, position.longitude);
      _addMarkers(await Repository().fetchAccessStore(addModel));
    } else {
      addModel = new AccessStore(
        lat: 41.311081,
        lng: 69.240562,
        products: widget.drugs,
      );
      _addMarkers(await Repository().fetchAccessStore(addModel));
    }
  }

  Future<void> _defaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lat = prefs.getDouble("coordLat") ?? 41.311081;
    var lng = prefs.getDouble("coordLng") ?? 69.240562;

    AccessStore addModel = new AccessStore(products: widget.drugs);
    _addMarkers(await Repository().fetchAccessStore(addModel));
    if (mapController != null) {
      mapController.move(
        point: Point(
          latitude: lat,
          longitude: lng,
        ),
        zoom: 11,
        animation: const MapAnimation(smooth: true, duration: 0.5),
      );
    }
  }
}
