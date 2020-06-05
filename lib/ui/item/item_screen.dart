import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/app_theme.dart';
import 'package:pharmacy/ui/item/description_screen.dart';

class ItemScreen extends StatefulWidget {
  int id;
  String name;

  ItemScreen(this.id, this.name);

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
          backgroundColor: AppTheme.red_app_color,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
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
            labelColor: AppTheme.red_app_color,
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
          DescriptionScreen(widget.id),
          DescriptionScreen(widget.id),
        ]),
      ),
    );
  }
}
