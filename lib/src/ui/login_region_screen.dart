import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/blocs/region_bloc.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/utils/accordion.dart';
import 'package:pharmacy/src/utils/utils.dart';

import '../app_theme.dart';

class LoginRegionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginRegionScreenState();
  }
}

class _LoginRegionScreenState extends State<LoginRegionScreen> {
  RegionModel data = RegionModel(id: -1);
  var duration = Duration(milliseconds: 270);

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  Future<void> _requestPermission() async {
    Permission.locationWhenInUse.request().then(
      (value) async {
        if (value.isGranted) {
          _getPosition();
        } else {
          blocRegion.fetchAllRegion();
        }
      },
    );
  }

  Future<void> _getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      var response = await Repository().fetchGetRegion("$lng,$lat");
      if (response.isSuccess) {
        var result = OrderStatusModel.fromJson(response.result);
        if (result.status == 1) {
          Utils.saveRegion(result.region, result.msg, lat, lng);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        } else {
          blocRegion.fetchAllRegion();
        }
      } else {
        blocRegion.fetchAllRegion();
      }
    } else {
      blocRegion.fetchAllRegion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.white,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              translate(""),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.black_text,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontRubik,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: blocRegion.allRegion,
              builder: (context, AsyncSnapshot<List<RegionModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return snapshot.data[index].childs.length == 0
                          ? GestureDetector(
                              onTap: () async {
                                setState(() {
                                  data = RegionModel(
                                    id: snapshot.data[index].id,
                                    name: snapshot.data[index].name,
                                    coords: [
                                      snapshot.data[index].coords[0],
                                      snapshot.data[index].coords[1]
                                    ],
                                  );
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.only(
                                  bottom: 1,
                                  left: 12,
                                  right: 12,
                                ),
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          height: 1.2,
                                          color: AppTheme.black_text,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    AnimatedContainer(
                                      duration: duration,
                                      curve: Curves.easeInOut,
                                      height: 16,
                                      width: 16,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color:
                                              data.id == snapshot.data[index].id
                                                  ? AppTheme.blue
                                                  : AppTheme.gray,
                                        ),
                                      ),
                                      child: AnimatedContainer(
                                        duration: duration,
                                        curve: Curves.easeInOut,
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color:
                                              data.id == snapshot.data[index].id
                                                  ? AppTheme.blue
                                                  : AppTheme.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            )
                          : Accordion(
                              title: snapshot.data[index].name,
                              childs: snapshot.data[index].childs,
                              data: data,
                              onChoose: (choose) {
                                setState(() {
                                  data = RegionModel(
                                    id: choose.id,
                                    name: choose.name,
                                    coords: [
                                      choose.coords[0],
                                      choose.coords[1]
                                    ],
                                  );
                                });
                              },
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
          Container(
            padding: EdgeInsets.only(top: 12, left: 22, right: 22, bottom: 24),
            color: AppTheme.white,
            child: GestureDetector(
              onTap: () {
                if (data.id != -1) {
                  Utils.saveRegion(
                    data.id,
                    data.name,
                    data.coords[0],
                    data.coords[1],
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                }
              },
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: data.id == -1 ? AppTheme.gray : AppTheme.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Выбрать",
                    style: TextStyle(
                      fontFamily: AppTheme.fontRubik,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.25,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
