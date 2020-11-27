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
import 'package:pharmacy/src/blocs/region_bloc.dart';
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
  PermissionStatus _permissionStatus;
  Position position;

  //List<RegionModel> users = new List();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool isFirstData = true;

  @override
  void initState() {
    _requestPermission();
    Timer(Duration(seconds: 10), () {
      if (position == null) {
        blocRegion.fetchAllRegion();
      }
    });
    super.initState();
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
    position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      locationPermissionLevel: GeolocationPermission.locationWhenInUse,
    );
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      var response = Repository().fetchGetRegion("$lng,$lat");
      response.then(
        (value) => {
          if (value.status == 1)
            {
              Utils.saveRegion(value.region, value.msg, lat, lng),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              ),
            }
          else
            {
              blocRegion.fetchAllRegion(),
            }
        },
      );
    } else {
      blocRegion.fetchAllRegion();
      //_getMoreData();
    }
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
    if (_permissionStatus != null) {
      if (_permissionStatus == PermissionStatus.granted) {
        _getPosition();
      } else {
        blocRegion.fetchAllRegion();
        //_getMoreData();
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
              Expanded(
                child: StreamBuilder(
                  stream: blocRegion.allRegion,
                  builder:
                      (context, AsyncSnapshot<List<RegionModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return snapshot.data[index].childs.length == 0
                              ? GestureDetector(
                                  onTap: () async {
                                    Utils.saveRegion(
                                      snapshot.data[index].id,
                                      snapshot.data[index].name,
                                      snapshot.data[index].coords[0],
                                      snapshot.data[index].coords[1],
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()),
                                    );
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
                                                snapshot.data[index].name,
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.normal,
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
                                          color: AppTheme.black_linear_category,
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
                                          if (snapshot.data[index].isOpen ==
                                                  null ||
                                              snapshot.data[index].isOpen ==
                                                  false) {
                                            snapshot.data[index].isOpen = true;
                                          } else {
                                            snapshot.data[index].isOpen = false;
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
                                                snapshot.data[index].name,
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontSize: 15,
                                                  color: AppTheme.black_text,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              snapshot.data[index].isOpen ==
                                                      null
                                                  ? Icons.keyboard_arrow_down
                                                  : snapshot.data[index].isOpen
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                              size: 24,
                                              color: AppTheme.black_text,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    (snapshot.data[index].isOpen == null ||
                                            snapshot.data[index].isOpen ==
                                                false)
                                        ? Container()
                                        : ListView.builder(
                                            itemCount: snapshot
                                                .data[index].childs.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, position) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  Utils.saveRegion(
                                                    snapshot.data[index]
                                                        .childs[position].id,
                                                    snapshot.data[index]
                                                        .childs[position].name,
                                                    snapshot
                                                        .data[index]
                                                        .childs[position]
                                                        .coords[0],
                                                    snapshot
                                                        .data[index]
                                                        .childs[position]
                                                        .coords[1],
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainScreen()),
                                                  );
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
                                                      snapshot
                                                          .data[index]
                                                          .childs[position]
                                                          .name,
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily:
                                                            AppTheme.fontRoboto,
                                                        fontSize: 15,
                                                        color:
                                                            AppTheme.black_text,
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
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.blue_app_color,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
