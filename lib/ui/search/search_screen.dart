import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/view/item_search_view.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  String name;

  SearchScreen(this.name);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

final List<ItemModel> items = ItemModel.itemsModel;

class _SearchScreenState extends State<SearchScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;

  List<ItemModel> itemCard = new List();
  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    searchController.text = widget.name;
    dataBase.getAllProducts().then((products) {
      setState(() {
        products.forEach((products) {
          itemCard.add(ItemModel.fromMap(products));
        });
        for (var i = 0; i < items.length; i++) {
          for (var j = 0; j < itemCard.length; j++) {
            if (items[i].id == itemCard[j].id) {
              items[i].cardCount = itemCard[j].cardCount;
              items[i].favourite = itemCard[j].favourite;
            }
          }
        }
      });
    });
    super.initState();
  }

  _SearchScreenState() {
    searchController.addListener(() {
      if (searchController.text.length > 0) {
        setState(() {
          isSearchText = true;
        });
      } else {
        setState(() {
          isSearchText = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Container(
          height: 36,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: AppTheme.black_transparent,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: new Icon(
                          Icons.search,
                          size: 24,
                          color: AppTheme.notWhite,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextFormField(
                            autofocus: true,
                            cursorColor: AppTheme.notWhite,
                            style: TextStyle(
                              color: AppTheme.black_catalog,
                              fontSize: 17,
                              fontFamily: AppTheme.fontSFProText,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: translate("search_hint"),
                            ),
                            controller: searchController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  translate("search.cancel"),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppTheme.blue_app_color,
                    fontFamily: AppTheme.fontSFProText,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          isSearchText
              ? Container(
                  child: ListView(
                    children: [
                      Text("AAAAAAAAAAAAAA"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemSearchView(items[index]);
                        },
                      ),
                    ],
                  ),
                )
              : Container(
                  child: ListView(
                    children: [
                      Text("false"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemSearchView(items[index]);
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
