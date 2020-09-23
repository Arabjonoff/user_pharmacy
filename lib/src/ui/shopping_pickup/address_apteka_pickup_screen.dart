import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_list_pickup.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_map_pickup.dart';

import '../../app_theme.dart';
import 'order_card_pickup.dart';

class AddressAptekaPickupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressAptekaScreenState();
  }
}

class _AddressAptekaScreenState extends State<AddressAptekaPickupScreen>
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
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Container(
              height: 20,
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
          child: Column(
            children: [
              Container(
                height: 56,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: OrderCardPickupScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          margin: EdgeInsets.only(left: 4),
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
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              translate("pharmacy_title"),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          margin: EdgeInsets.only(right: 4),
                          color: AppTheme.arrow_examp_back,
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
                  ],
                ),
              ),
              Expanded(
                child: ListView(
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
                          AddressAptekaMapPickupScreen(),
                          AddressAptekaListPickupScreen(),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
