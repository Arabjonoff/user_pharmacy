import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart' as placemark;

import '../../app_theme.dart';
import 'curer_address_card.dart';

class MapAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapAddressScreenState();
  }
}

class _MapAddressScreenState extends State<MapAddressScreen> {
  YandexMapController controller;
  placemark.Placemark lastPlaceMark;
  Point _point;
  TextEditingController addressController = TextEditingController();

  DatabaseHelperAddress db = new DatabaseHelperAddress();

  bool error = false;
  bool isFirst = true;
  bool isFirstNo = true;
  double height;
  String address = "";
  bool isGranted = true;

  _MapAddressScreenState() {
    addressController.addListener(() {
      if (addressController.text.replaceAll(" ", "").length > 0) {
        setState(() {
          address = addressController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 44,
              margin: EdgeInsets.only(bottom: 4),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 44,
                        width: 44,
                        color: AppTheme.arrow_examp_back,
                        margin: EdgeInsets.only(right: 4),
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.arrow_back,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                                "assets/images/arrow_close.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurerAddressCardScreen(false),
                          ),
                        );
                      },
                      child: Container(
                        height: 44,
                        width: 44,
                        color: AppTheme.arrow_examp_back,
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(3),
                            child: SvgPicture.asset(
                                "assets/images/arrow_back.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("orders.new_add_address"),
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontFamily: AppTheme.fontRubik,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.black_text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 44,
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 8,
              ),
              padding: EdgeInsets.only(left: 6, right: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppTheme.auth_login,
                border: Border.all(
                  color: AppTheme.auth_border,
                  width: 1.0,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 2,
                ),
                child: Center(
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    autofocus: false,
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.black_text,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: translate("address.delivery_address"),
                      hintStyle: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF6D7885),
                        fontSize: 15,
                      ),
                    ),
                    controller: addressController,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    YandexMap(
                      onMapCreated:
                          (YandexMapController yandexMapController) async {
                        controller = yandexMapController;
                      },
                    ),
                    isGranted
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              // if (_permissionStatus ==
                              //     PermissionStatus.disabled) {
                              //   AppSettings.openLocationSettings();
                              // } else if (_permissionStatus ==
                              //     PermissionStatus.denied) {
                              //   await PermissionHandler().openAppSettings();
                              // }
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: 16, right: 16, top: 16),
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
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/icon_map_disabled.svg"),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      translate("disabled"),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
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
                            controller.move(
                              point: _point,
                              animation: const MapAnimation(
                                  smooth: true, duration: 0.5),
                            );
                          } else {
                            //_requestPermission();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16, right: 16),
                          width:
                              (translate("what_me").length * 9 + 24 + 32 + 12)
                                  .toDouble(),
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/icon_my_location.svg"),
                              SizedBox(width: 12),
                              Text(
                                translate("what_me"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontRubik,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (address != "") {
                  db.saveProducts(
                    AddressModel(
                      street: address,
                      lat: lastPlaceMark.point.latitude.toString(),
                      lng: lastPlaceMark.point.longitude.toString(),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurerAddressCardScreen(true),
                    ),
                  );
                } else {
                  setState(() {
                    error = true;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: address == ""
                      ? AppTheme.blue_app_color.withOpacity(0.3)
                      : AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: Text(
                    translate("address.save_address"),
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRubik,
                      fontSize: 17,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
