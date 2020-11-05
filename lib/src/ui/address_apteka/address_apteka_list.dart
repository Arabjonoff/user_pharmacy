import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/blocs/aptek_block.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class AddressAptekaListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaListScreenState();
  }
}

class _AddressAptekaListScreenState extends State<AddressAptekaListScreen>
    with AutomaticKeepAliveClientMixin<AddressAptekaListScreen> {
  @override
  bool get wantKeepAlive => true;
  DatabaseHelperApteka db = new DatabaseHelperApteka();

  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  static StreamSubscription _getPosSub;

  @override
  void initState() {
    super.initState();
    _requestPermission();
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
        stream: blocApteka.allApteka,
        builder: (context, AsyncSnapshot<List<AptekaModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.only(bottom: 56),
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
                height: 200,
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
      Utils.saveLocation(position.latitude, position.longitude);
      blocApteka.fetchAllApteka(position.latitude, position.longitude);
    } else {
      blocApteka.fetchAllApteka(null, null);
    }
  }

  Future<void> _defaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble("coordLat") != null) {
      blocApteka.fetchAllApteka(
          prefs.getDouble("coordLat"), prefs.getDouble("coordLng"));
    } else {
      blocApteka.fetchAllApteka(null, null);
    }
  }
}
