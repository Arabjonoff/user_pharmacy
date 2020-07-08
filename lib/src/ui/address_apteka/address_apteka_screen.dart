import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';

import '../../app_theme.dart';
import 'address_apteka_list.dart';

class AddressAptekaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaScreenState();
  }
}

class _AddressAptekaScreenState extends State<AddressAptekaScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Size size;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        backgroundColor: AppTheme.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(76.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: AppTheme.white,
            brightness: Brightness.light,
            title: Container(
              height: 56,
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(top: 3.5),
                      color: AppTheme.arrow_examp_back,
                      child: GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: AppTheme.blue_app_color,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      height: 48,
                      width: 48,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Аптеке",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontCommons,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: 40,
              width: 350,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.tab_transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.blue_app_color,
                unselectedLabelColor: AppTheme.search_empty,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontRoboto,
                  fontSize: 13,
                  color: AppTheme.blue_app_color,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                tabs: <Widget>[
                  new Tab(
                    text: translate("map.tab_one"),
                  ),
                  new Tab(
                    text: translate("map.tab_two"),
                  ),
                ],
              ),
            ),
            Container(
              height: size.height - 140,
              child: TabBarView(
                controller: _tabController,
                children: [
                  AddressAptekaMapScreen(),
                  AddressAptekaListScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
