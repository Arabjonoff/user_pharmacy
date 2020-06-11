import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/app_theme.dart';
import 'package:pharmacy/ui/item/description_screen.dart';

// ignore: must_be_immutable
class ItemScreen extends StatefulWidget {
  int id;
  String name;
  String image;


  ItemScreen(this.id, this.name, this.image);


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
          backgroundColor: AppTheme.green_app_color,
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          bottom: TabBar(
            labelColor: AppTheme.green_app_color,
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
          DescriptionScreen(widget.id,widget.image),
          DescriptionScreen(widget.id,widget.image),
        ]),
      ),
    );
  }
}
