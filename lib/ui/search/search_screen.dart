import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/view/item_view.dart';

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
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            width: size.width,
            color: AppTheme.red_app_color,
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 3, bottom: 24),
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      translate("search_hint"),
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 104),
            height: size.height - 104,
            width: size.width,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemView(items[index]);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80, left: 15, right: 15, bottom: 15),
            height: 48,
            width: double.infinity,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(9.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: new Icon(
                      Icons.search,
                      size: 24,
                      color: AppTheme.red_app_color,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 3,
                          right: 3,
                        ),
                        hintText: translate("search_hint"),
                      ),
                      controller: searchController,
                    ),
                  ),
                  isSearchText
                      ? IconButton(
                          icon: new Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            setState(() {
                              searchController.text = "";
                            });
                          },
                        )
                      : IconButton(
                          icon: new Icon(
                            Icons.scanner,
                            size: 24,
                            color: Colors.black45,
                          ),
                          onPressed: () {},
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
