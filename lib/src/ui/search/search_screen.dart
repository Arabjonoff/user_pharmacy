import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_history.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/utils/api.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/view/item_search_history_view.dart';
import 'package:pharmacy/src/ui/view/item_search_view.dart';

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
                                      obj,
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
                ? FutureBuilder<ItemModel>(
                    future: Repository().fetchSearchItemList(obj),
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
                            return snapshot.data.results.length > 0
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.results.length,
                                    itemBuilder: (context, index) {
                                      return ItemSearchView(
                                          snapshot.data.results[index]);
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

                            return data.length > 0
                                ? Container(
                                    width: size.width,
                                    height: size.height - 40,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              searchController.text =
                                                  data[index];
                                            });
                                          },
                                          child: Container(
                                            height: 48.5,
                                            color: AppTheme.white,
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: 20,
                                                          right: 14.25,
                                                          top: 14.25,
                                                          bottom: 14.75,
                                                        ),
                                                        height: 19.5,
                                                        width: 19.5,
                                                        child: SvgPicture.asset(
                                                          "assets/images/clock.svg",
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            data[index],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: AppTheme
                                                                  .black_text,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily: AppTheme
                                                                  .fontRoboto,
                                                              fontSize: 15,
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 12,
                                                            right: 20.41),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 19,
                                                            color: AppTheme
                                                                .arrow_catalog,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  height: 1,
                                                  color: AppTheme.black_linear,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container();
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
