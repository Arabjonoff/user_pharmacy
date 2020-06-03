import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/app_theme.dart';
import 'package:pharmacy/ui/item/description_screen.dart';
import 'package:pharmacy/ui/item/price_aviable_screen.dart';

class ItemScreen extends StatefulWidget {
  String name;

  ItemScreen(this.name);

  @override
  State<StatefulWidget> createState() {
    return _ItemScreenState();
  }
}

class _ItemScreenState extends State<ItemScreen> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Row(
              children: [
                Text(
                  widget.name,
                ),
              ],
            ),
            bottom: TabBar(
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("item.description"),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      translate("item.price"),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            DescriptionScreen(),
            PriceAvailabilityScreen(),
          ]),
        ));
  }
}
