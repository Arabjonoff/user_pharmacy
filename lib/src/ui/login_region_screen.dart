import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class LoginRegionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginRegionScreenState();
  }
}

class _LoginRegionScreenState extends State<LoginRegionScreen> {
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  var geolocator = Geolocator();
  static StreamSubscription _getPosSub;
  List<RegionModel> users = new List();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool isLoading = true;
  bool isFirst = true;
  bool isFirstData = true;

  @override
  void initState() {
    _requestPermission();
    _getMoreData();
    super.initState();
  }

  @override
  void dispose() {
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

  Future<void> _getPosition() async {
    _getPosSub = geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10))
        .listen((Position position) async {
      if (position != null) {
        lat = position.latitude;
        lng = position.longitude;
        var response = Repository().fetchGetRegion("$lng,$lat");
        response.then((value) => {
              if (value.status == 1)
                {
                  isLoading = false,
                  Utils.saveRegion(value.region, value.msg, lat, lng),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  ),
                }
            });
      }
    });
  }

  Future<void> _initPlatformState(BuildContext context) async {
    Map<String, dynamic> deviceData;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("deviceData") == null) {
      try {
        if (Platform.isAndroid) {
          deviceData = _readAndroidBuildData(
              await deviceInfoPlugin.androidInfo, context);
        } else if (Platform.isIOS) {
          deviceData =
              _readIosDeviceInfo(await deviceInfoPlugin.iosInfo, context);
        }
        Utils.saveDeviceData(deviceData);
      } on PlatformException {
        deviceData = <String, dynamic>{
          'Error:': 'Failed to get platform version.'
        };
      }
    }

    if (!mounted) return;
  }

  Map<String, dynamic> _readAndroidBuildData(
      AndroidDeviceInfo build, BuildContext context) {
    return <String, dynamic>{
      'platform': "Android",
      'model': build.model,
      'systemVersion': build.version.release,
      'brand': build.brand,
      'isPhysicalDevice': build.isPhysicalDevice,
      'identifierForVendor': build.androidId,
      'device': build.device,
      'product': build.product,
      'version.incremental': build.version.incremental,
      'displaySize': MediaQuery.of(context).size,
      'displayPixel': window.physicalSize,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(
      IosDeviceInfo data, BuildContext context) {
    return <String, dynamic>{
      'platform': "IOS",
      'model': data.name,
      'systemVersion': data.systemVersion,
      'brand': data.model,
      'isPhysicalDevice': data.isPhysicalDevice,
      'identifierForVendor': data.identifierForVendor,
      'systemName': data.systemName,
      'displaySize': MediaQuery.of(context).size,
      'displayPixel': window.physicalSize,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      if (isFirst) {
        _getPosition();
        isFirst = false;
      }
    }
    if (isFirstData) {
      _initPlatformState(context);
      isFirstData = false;
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
          )),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 14),
        child: Container(
          width: double.infinity,
          color: AppTheme.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  translate("menu.city"),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppTheme.black_text,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontCommons,
                    fontSize: 17,
                  ),
                ),
              ),
              isLoading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.blue_app_color,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 24),
                        child: ListView.builder(
                          itemCount: users.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return users[index].childs.length == 0
                                ? GestureDetector(
                                    onTap: () async {
                                      Utils.saveRegion(
                                        users[index].id,
                                        users[index].name,
                                        users[index].coords[0],
                                        users[index].coords[1],
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen()),
                                      );

                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   PageTransition(
                                      //     type: PageTransitionType.rightToLeft,
                                      //     child: MainScreen(),
                                      //   ),
                                      // );
                                      // SharedPreferences prefs =
                                      //     await SharedPreferences.getInstance();
                                      // prefs.setString(
                                      //     "city", users[index].name);
                                      // prefs.setInt("cityId", users[index].id);
                                      // prefs.commit();
                                    },
                                    child: Container(
                                      color: AppTheme.white,
                                      height: 60,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              height: 59,
                                              margin: EdgeInsets.only(
                                                  left: 16, right: 20),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  users[index].name,
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontSize: 15,
                                                    color: AppTheme.black_text,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color:
                                                AppTheme.black_linear_category,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            if (users[index].isOpen == null ||
                                                users[index].isOpen == false) {
                                              users[index].isOpen = true;
                                            } else {
                                              users[index].isOpen = false;
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16),
                                          color: AppTheme.white,
                                          height: 60,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  users[index].name,
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontSize: 15,
                                                    color: AppTheme.black_text,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                users[index].isOpen == null
                                                    ? Icons.keyboard_arrow_down
                                                    : users[index].isOpen
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                size: 24,
                                                color: AppTheme.black_text,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      (users[index].isOpen == null ||
                                              users[index].isOpen == false)
                                          ? Container()
                                          : ListView.builder(
                                              itemCount:
                                                  users[index].childs.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, position) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    Utils.saveRegion(
                                                      users[index]
                                                          .childs[position]
                                                          .id,
                                                      users[index]
                                                          .childs[position]
                                                          .name,
                                                      users[index]
                                                          .childs[position]
                                                          .coords[0],
                                                      users[index]
                                                          .childs[position]
                                                          .coords[1],
                                                    );
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MainScreen()),
                                                    );

                                                    // SharedPreferences prefs =
                                                    //     await SharedPreferences
                                                    //         .getInstance();
                                                    // prefs.setString(
                                                    //     "city",
                                                    //     users[index]
                                                    //         .childs[position]
                                                    //         .name);
                                                    // prefs.setInt(
                                                    //     "cityId",
                                                    //     users[index]
                                                    //         .childs[position]
                                                    //         .id);
                                                    // prefs.commit();
                                                    // Navigator.pushReplacement(
                                                    //   context,
                                                    //   PageTransition(
                                                    //     type: PageTransitionType
                                                    //         .rightToLeft,
                                                    //     child: MainScreen(),
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Container(
                                                    color: AppTheme.white,
                                                    height: 60,
                                                    width: double.infinity,
                                                    margin: EdgeInsets.only(
                                                        left: 32, right: 20),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        users[index]
                                                            .childs[position]
                                                            .name,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                          fontSize: 15,
                                                          color: AppTheme
                                                              .black_text,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                      Container(
                                        height: 1,
                                        color: AppTheme.black_linear_category,
                                      )
                                    ],
                                  );
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void _getMoreData() async {
    var response = Repository().fetchRegions("");

    response.then((value) => {
          if (value != null)
            {
              setState(() {
                isLoading = false;
                users = new List();
                users = value;
              }),
            }
          else
            {
              setState(() {
                isLoading = false;
              }),
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    content: Container(
                      width: 239.0,
                      height: 64.0,
                      child: Center(
                        child: Text(
                          translate("internet_error"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            }
        });
  }
}
