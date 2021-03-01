import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/src/blocs/search_bloc.dart';
import 'package:pharmacy/src/database/database_helper_history.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/view/item_search_view.dart';

import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

int barcode;

class SearchScreen extends StatefulWidget {
  final String name;
  final int barcode;
  final int searchPosition;

  SearchScreen(
    this.name,
    this.barcode,
    this.searchPosition,
  );

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

  String cancelText = "";

  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  var durationTime = Duration(
    milliseconds: 300,
  );
  var height;
  var width = 38.0;

  DatabaseHelperHistory dataHistory = new DatabaseHelperHistory();

  Timer _timer;

  @override
  void initState() {
    barcode = widget.barcode;
    if (widget.searchPosition == 1) {
      height = 130.0;
    } else {
      height = 80.0;
    }
    Timer(Duration(milliseconds: 1), () {
      setState(() {
        height = 36.0;
        width = translate("search.cancel").length * 10.0 + 16.0;
      });
    });
    Timer(durationTime, () {
      setState(() {
        cancelText = translate("search.cancel");
      });
    });
    searchController.text = widget.name;
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  _SearchScreenState() {
    const oneSec = const Duration(milliseconds: 500);
    searchController.addListener(() {
      if (searchController.text.length > 2) {
        if (_timer == null) {
          _timer = new Timer(oneSec, () {
            obj = searchController.text;
            if (obj.length > 2) {
              setState(() {
                _timer.cancel();
                page = 1;
                isLoading = false;
                isSearchText = true;
                this._getMoreData(1);
              });
            } else {
              setState(() {
                page = 1;
                obj = "";
                isSearchText = false;
              });
            }
          });
        } else {
          _timer.cancel();
          _timer = new Timer(oneSec, () {
            obj = searchController.text;
            if (obj.length > 2) {
              setState(() {
                _timer.cancel();
                page = 1;
                isSearchText = true;
                isLoading = false;
                this._getMoreData(1);
              });
            } else {
              setState(() {
                page = 1;
                obj = "";
                isSearchText = false;
              });
            }
          });
        }
      } else {
        setState(() {
          page = 1;
          obj = "";
          isSearchText = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          if (widget.searchPosition == 1) {
            height = 130.0;
          } else {
            height = 80.0;
          }
          width = 38;
        });
        Timer(durationTime, () {
          Navigator.pop(context);
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: Column(
          children: [
            AnimatedContainer(
              height: height,
              duration: durationTime,
              curve: Curves.easeInOut,
              color: AppTheme.white,
            ),
            Theme(
              data: ThemeData(
                platform: Platform.isAndroid
                    ? TargetPlatform.android
                    : TargetPlatform.iOS,
              ),
              child: Container(
                height: 36,
                margin: EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                color: AppTheme.white,
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
                            SizedBox(width: 8),
                            Icon(
                              Icons.search,
                              size: 24,
                              color: AppTheme.notWhite,
                            ),
                            SizedBox(width: 8),
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
                                        MaterialPageRoute(
                                          builder: (context) => ItemListScreen(
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
                    AnimatedContainer(
                      width: width,
                      duration: durationTime,
                      curve: Curves.easeInOut,
                      color: AppTheme.white,
                      child: GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          setState(() {
                            cancelText = "";
                            if (widget.searchPosition == 1) {
                              height = 130.0;
                            } else {
                              height = 80.0;
                            }
                            width = 38;
                          });
                          Timer(durationTime, () {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 12),
                          child: Text(
                            cancelText,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppTheme.blue_app_color,
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: isSearchText
                  ? StreamBuilder(
                      stream: blocSearch.searchOptions,
                      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                        if (snapshot.hasData) {
                          snapshot.data.next == null
                              ? isLoading = true
                              : isLoading = false;

                          return snapshot.data.results.length > 0
                              ? ListView.builder(
                                  itemCount: snapshot.data.results.length + 1,
                                  controller: _sc,
                                  itemBuilder: (context, index) {
                                    if (index == snapshot.data.results.length) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Center(
                                          child: new Opacity(
                                            opacity: isLoading ? 0.0 : 1.0,
                                            child: Container(
                                              height: 64,
                                              child: Lottie.asset(
                                                  'assets/anim/item_load_animation.json'),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ItemSearchView(
                                          snapshot.data.results[index], index);
                                    }
                                  },
                                )
                              : Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Column(
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
                                  ),
                                );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (_, __) => Container(
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 16,
                                    margin:
                                        EdgeInsets.only(left: 16, right: 16),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 8,
                                      left: 16,
                                      right: 16,
                                    ),
                                    height: 16,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
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
                                onTap: () {
                                  setState(() {
                                    dataHistory.clear();
                                  });
                                },
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
                              List<String> data = snapshots.data;
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
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 20,
                                                            right: 14.25,
                                                            top: 14.25,
                                                            bottom: 14.75,
                                                          ),
                                                          height: 19.5,
                                                          width: 19.5,
                                                          child:
                                                              SvgPicture.asset(
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
                                                          margin:
                                                              EdgeInsets.only(
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
                                                    color:
                                                        AppTheme.black_linear,
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
            )
          ],
        ),
      ),
    );
  }

  void _getMoreData(int index) async {
    if (obj.length > 2) {
      if (!isLoading) {
        blocSearch.fetchSearch(index, obj, widget.barcode);
        page++;
      }
    }
  }
}
