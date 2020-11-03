import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/app_theme.dart';

class MyAppDelete extends StatefulWidget {
  @override
  _MyAppDeleteState createState() => _MyAppDeleteState();
}

class _MyAppDeleteState extends State<MyAppDelete> {
  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  PermissionStatus _permissionStatus = PermissionStatus.unknown;

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

  Future<void> _openPermissionSettings() async {
    bool isOpened = await PermissionHandler().openAppSettings();
    print(isOpened);
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == PermissionStatus.granted) {
      print(_permissionStatus);
    } else if (_permissionStatus == PermissionStatus.disabled) {
      print(_permissionStatus);
      AppSettings.openLocationSettings();
    } else if (_permissionStatus == PermissionStatus.denied) {
      print(_permissionStatus);
      _openPermissionSettings();
    }
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(title: Text('My App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              openLocationSetting();
            },
            child: Container(
              height: 56,
              width: double.infinity,
              color: AppTheme.red_fav_color,
              child: Text('settings'),
            ),
          ),
          GestureDetector(
            onTap: () async {
              bool isOpened = await PermissionHandler().openAppSettings();
              print(isOpened);
            },
            child: Container(
              margin: EdgeInsets.only(top: 32),
              height: 56,
              width: double.infinity,
              color: AppTheme.red_fav_color,
              child: Text('permission'),
            ),
          ),
          GestureDetector(
            onTap: () async {
              AppSettings.openLocationSettings();
            },
            child: Container(
              margin: EdgeInsets.only(top: 32),
              height: 56,
              width: double.infinity,
              color: AppTheme.red_fav_color,
              child: Text('app settings Location'),
            ),
          ),
        ],
      ),
    );
  }
}

class AskForPermission extends StatefulWidget {
  @override
  _AskForPermissionState createState() => _AskForPermissionState();
}

class _AskForPermissionState extends State<AskForPermission> {
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;

  void initState() {
    super.initState();
    //requestLocationPermission();
    _gpsService();
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

/*Checking if your App has been Given Permission*/
  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }

/*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    var k = await Geolocator().isLocationServiceEnabled();
    print(k);
    if (!(await Geolocator().isLocationServiceEnabled())) {
      print(TargetPlatform.android);

      print("SSSSSSSSSSSS");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Can't get gurrent location"),
            content:
                const Text('Please make sure you enable GPS and try again'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                    _gpsService();
                  })
            ],
          );
        },
      );
    }
  }

/*Check if gps service is enabled or not*/
  Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    _gpsService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask for permisions'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("All Permission Granted"),
          ],
        ),
      ),
    );
  }
}
