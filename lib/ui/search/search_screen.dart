import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/database/database_helper_history.dart';
import 'package:pharmacy/model/api/item_model.dart';
import 'package:pharmacy/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/ui/view/item_search_history_view.dart';
import 'package:pharmacy/ui/view/item_search_view.dart';
import 'package:pharmacy/utils/api.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  String name;
  int barcode;

  SearchScreen(this.name, this.barcode);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;
  String obj = "";

  List<ItemResult> itemCard = new List();

  //List<ItemResult> items = new List();

  DatabaseHelper dataBase = new DatabaseHelper();
  DatabaseHelperHistory dataHistory = new DatabaseHelperHistory();

  @override
  void initState() {
    searchController.text = widget.name;

    super.initState();
  }

  _SearchScreenState() {
    searchController.addListener(() {
      if (searchController.text != obj) {
        if (searchController.text.length > 0) {
          setState(() {
            obj = searchController.text;
            isSearchText = true;
          });
        } else {
          setState(() {
            obj = "";
            isSearchText = false;
          });
        }
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
                                if (searchController.text.length > 0) {
                                  var data = dataHistory
                                      .getProducts(searchController.text);
                                  data.then(
                                    (value) => {
                                      if (value == 0)
                                        {
                                          dataHistory.saveProducts(
                                              searchController.text),
                                        }
                                      else
                                        {
                                          dataHistory.updateProduct(
                                              searchController.text),
                                        },
                                    },
                                  );
                                }
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ItemListScreen(
                                      translate("search.result"),
                                      3,
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
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
                ? FutureBuilder<List<ItemResult>>(
                    future: API.getSearchItems(obj),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return SizedBox(
                          child: Text(
                            "нет интернета",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                          {
                            dataBase.getAllProducts().then((products) {
                              products.forEach((products) {
                                itemCard.add(ItemResult.fromMap(products));
                              });
                              for (var i = 0; i < snapshot.data.length; i++) {
                                for (var j = 0; j < itemCard.length; j++) {
                                  if (snapshot.data[i].id == itemCard[j].id) {
                                    snapshot.data[i].cardCount =
                                        itemCard[j].cardCount;
                                    snapshot.data[i].favourite =
                                        itemCard[j].favourite;
                                  }
                                }
                              }
                            });
                            return snapshot.data.length > 0
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return ItemSearchView(
                                          snapshot.data[index]);
                                    },
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  );
                          }
                        default:
                      }
                    },
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
                        height: 15,
                      ),
                      Container(
                        width: size.width,
                        height: size.height - 40,
                        child: FutureBuilder<List<String>>(
                          future: dataHistory.getProdu(),
                          // ignore: missing_return
                          builder: (context, snapshots) {
                            var data = snapshots.data;
                            if (data == null) {
                              return Container(
                                child: Center(
                                  child: Text("error"),
                                ),
                              );
                            }
                            if (data.length > 0)
                              return Container(
                                width: size.width,
                                height: size.height - 40,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return ItemSearchHistoryView(
                                      data[index],
                                    );
                                  },
                                ),
                              );
                          },
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
