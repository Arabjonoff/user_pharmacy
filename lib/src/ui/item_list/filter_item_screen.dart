import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/filter_block.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/ui/item_list/fliter_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class FilterItemScreen extends StatefulWidget {
  final int type;

  FilterItemScreen(this.type);

  @override
  State<StatefulWidget> createState() {
    return _FilterItemScreenState();
  }
}

List<FilterResults> dataM = new List();
List<FilterResults> dataI = new List();

class _FilterItemScreenState extends State<FilterItemScreen> {
  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  String obj = "";
  Timer _timer;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMoreData(1, obj);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page, obj);
      }
    });
  }

  _FilterItemScreenState() {
    const oneSec = const Duration(seconds: 1);
    searchController.addListener(() {
      if (_timer == null) {
        _timer = new Timer(oneSec, () {
          _timer.cancel();
          page = 1;
          obj = searchController.text;
          isLoading = false;
          _getMoreData(1, obj);
        });
      } else {
        _timer.cancel();
        _timer = new Timer(oneSec, () {
          _timer.cancel();
          page = 1;
          obj = searchController.text;
          isLoading = false;
          _getMoreData(1, obj);
        });
      }
    });
  }

  @override
  void dispose() {
    page = 1;
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Container(
              height: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.item_navigation,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 48,
              margin: EdgeInsets.only(bottom: 16),
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.type == 1
                          ? translate("release")
                          : widget.type == 2
                              ? translate("manifac")
                              : translate("mnn"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 36,
                        width: 48,
                        color: AppTheme.arrow_examp_back,
                        padding: EdgeInsets.all(9),
                        margin: EdgeInsets.only(left: 5),
                        child: SvgPicture.asset("assets/images/arrow_back.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 36,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0),
                color: AppTheme.black_transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: blocFilter.filterItem,
                  builder: (context, AsyncSnapshot<FilterModel> snapshot) {
                    if (snapshot.hasData) {
                      snapshot.data.next == null
                          ? isLoading = true
                          : isLoading = false;
                      return snapshot.data.results.length > 0
                          ? ListView.builder(
                              controller: _sc,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.results.length + 1,
                              itemBuilder: (context, index) {
                                if (index == snapshot.data.results.length) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Center(
                                      child: new Opacity(
                                        opacity: isLoading ? 0.0 : 1.0,
                                        child: new CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    color: AppTheme.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        CheckboxListTile(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          title: Text(
                                            snapshot.data.results[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              color: AppTheme.black_text,
                                            ),
                                          ),
                                          value: snapshot
                                              .data.results[index].isClick,
                                          onChanged: (bool value) {
                                            if (widget.type == 2) {
                                              int k = 0;
                                              for (int i = 0;
                                                  i < dataM.length;
                                                  i++) {
                                                if (dataM[i].id ==
                                                    snapshot.data.results[index]
                                                        .id) {
                                                  dataM[i].isClick =
                                                      !dataM[i].isClick;
                                                  break;
                                                } else {
                                                  k++;
                                                }
                                              }
                                              if (k == dataM.length) {
                                                dataM.add(
                                                  FilterResults(
                                                    id: snapshot
                                                        .data.results[index].id,
                                                    name: snapshot.data
                                                        .results[index].name,
                                                    isClick: true,
                                                  ),
                                                );
                                              }
                                            } else {
                                              int k = 0;
                                              for (int i = 0;
                                                  i < dataI.length;
                                                  i++) {
                                                if (dataI[i].id ==
                                                    snapshot.data.results[index]
                                                        .id) {
                                                  dataI[i].isClick =
                                                      !dataI[i].isClick;
                                                  break;
                                                } else {
                                                  k++;
                                                }
                                              }
                                              if (k == dataI.length) {
                                                dataI.add(
                                                  FilterResults(
                                                    id: snapshot
                                                        .data.results[index].id,
                                                    name: snapshot.data
                                                        .results[index].name,
                                                    isClick: true,
                                                  ),
                                                );
                                              }
                                            }
                                            setState(() {
                                              snapshot.data.results[index]
                                                      .isClick =
                                                  !snapshot.data.results[index]
                                                      .isClick;
                                            });
                                          },
                                        ),
                                        Container(
                                          height: 1,
                                          margin: EdgeInsets.only(
                                              left: 8, right: 8),
                                          color: AppTheme.black_linear_category,
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: ListView(
                                children: [
                                  SizedBox(height: 75),
                                  SvgPicture.asset(
                                    "assets/images/empty.svg",
                                    height: 155,
                                    width: 155,
                                  ),
                                  Container(
                                    width: 210,
                                    margin:
                                        EdgeInsets.only(left: 16, right: 16),
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
                        itemCount: 20,
                        itemBuilder: (_, __) => Container(
                          height: 60,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Container(
                                    height: 35,
                                    color: AppTheme.white,
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(left: 15, right: 25),
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                margin: EdgeInsets.only(left: 8, right: 8),
                                color: AppTheme.black_linear,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              color: AppTheme.black_linear_category,
            ),
            GestureDetector(
              onTap: () {
                if (widget.type == 2) {
                  manufacturerFilter = new List();
                  for (int i = 0; i < dataM.length; i++) {
                    if (dataM[i].isClick) {
                      manufacturerFilter.add(dataM[i]);
                    }
                  }
                } else {
                  internationalNameFilter = new List();
                  for (int i = 0; i < dataI.length; i++) {
                    if (dataI[i].isClick) {
                      internationalNameFilter.add(dataI[i]);
                    }
                  }
                }
                blocFilter.fitchInterName();
                blocFilter.fitchMan();
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 24,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: Text(
                    translate("save"),
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 17,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getMoreData(int index, String search) async {
    if (!isLoading) {
      blocFilter.fetchAllFilter(widget.type, index, search);
      isLoading = false;
      page++;
    }
  }
}
