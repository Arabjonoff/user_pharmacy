import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/list/item_view_list.dart';

import '../../app_theme.dart';

class SearchScreen extends StatefulWidget {
  String name;

  SearchScreen(this.name);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

final List<ItemModel> items = [
  ItemModel(
    0,
    'https://littleone.com/uploads/publication/6133/_840/5cf6754c5b7533.84660925.jpg',
    'Aмиксин таблетки 125 мг 6 шт',
    'Противовирусные',
    'Описание препарата Амиксин®',
    '125 000 so\'m',
    0,
  ),
  ItemModel(
    1,
    'http://apteka999.uz/img_product/563.jpg',
    'Aмиксин таблетки 125 мг 6 шт',
    'Противовирусные',
    'Описание препарата Амиксин®',
    '125 000 so\'m',
    0,
  ),
  ItemModel(
    2,
    'https://i0.wp.com/oldlekar.ru/wp-content/uploads/citramon.jpg',
    'Aмиксин таблетки 125 мг 6 шт',
    'Противовирусные',
    'Описание препарата Амиксин®',
    '125 000 so\'m',
    0,
  ),
  ItemModel(
    3,
    'https://www.sandoz.ru/sites/www.sandoz.ru/files/linex-16-32-48_0.png',
    'Aмиксин таблетки 125 мг 6 шт',
    'Противовирусные',
    'Описание препарата Амиксин®',
    '125 000 so\'m',
    0,
  ),
  ItemModel(
    4,
    'https://interchem.ua/uploads/drugs/andipa10.png',
    'Aмиксин таблетки 125 мг 6 шт',
    'Противовирусные',
    'Описание препарата Амиксин®',
    '125 000 so\'m',
    0,
  ),
];

class _SearchScreenState extends State<SearchScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;

  @override
  void initState() {
    searchController.text = widget.name;
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
      print(searchController.text);
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
            child: ItemViewList(items),
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
                          onPressed: () {
                            print("click");
                          },
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
