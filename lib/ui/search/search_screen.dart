import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/ui/view/item_search_history_view.dart';
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
        automaticallyImplyLeading: false,
        title: Container(
          height: 36,
          width: size.width,
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
                        child: Container(
                          height: 36,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              textInputAction: TextInputAction.search,
                              autofocus: true,
                              onFieldSubmitted: (value) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ItemListScreen(
                                      translate("search.result"),
                                      1,
                                      0,
                                    ),
                                  ),
                                );
                              },
                              cursorColor: AppTheme.notWhite,
                              style: TextStyle(
                                color: AppTheme.black_text,
                                fontSize: 15,
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: translate("search_real"),
                                hintStyle: TextStyle(
                                  color: AppTheme.notWhite,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              controller: searchController,
                            ),
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
                    fontFamily: AppTheme.fontRoboto,
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
          Container(
            width: size.width,
            child: isSearchText
                ? items.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemSearchView(items[index]);
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/empty.svg",
                            height: 155,
                            width: 155,
                          ),
                          Container(
                            width: 210,
                            child: Text(
                              translate("search.empty"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.search_empty,
                              ),
                            ),
                          )
                        ],
                      )
                : ListView(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              translate("search.history"),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontRoboto,
                                color: AppTheme.black_text,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            GestureDetector(
                              child: Container(
                                child: Icon(
                                  Icons.clear,
                                  size: 19,
                                  color: AppTheme.arrow_catalog,
                                ),
                              ),
                              onTap: () {},
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(
                            left: 20, right: 20.41, bottom: 12, top: 12),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemSearchHistoryView(items[index]);
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
