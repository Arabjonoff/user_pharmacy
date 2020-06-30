import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                        Text(
                          translate("item.tovar"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppTheme.black_transparent_text,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
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
                    text: "На карте",
                  ),
                  new Tab(
                    text: "Список",
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
