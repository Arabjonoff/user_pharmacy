import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/filter_block.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class FilterItemScreen extends StatefulWidget {
  int type;

  FilterItemScreen(this.type);

  @override
  State<StatefulWidget> createState() {
    return _FilterItemScreenState();
  }
}

class _FilterItemScreenState extends State<FilterItemScreen> {
  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  int lastPosition = 0;

  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
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
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: blocFilter.filterItem,
                  builder:
                      (context, AsyncSnapshot<List<FilterResults>> snapshot) {
                    if (snapshot.hasData) {
                      lastPosition == snapshot.data.length
                          ? isLoading = true
                          : isLoading = false;
                      lastPosition = snapshot.data.length;

                      return snapshot.data.length > 0
                          ? ListView.builder(
                              controller: _sc,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length + 1,
                              itemBuilder: (context, index) {
                                if (index == snapshot.data.length) {
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
                                    height: 90,
                                    color: AppTheme.white,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text("${index}" +
                                                snapshot.data[index].name),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          margin: EdgeInsets.only(
                                              left: 8, right: 8),
                                          color: AppTheme.black_linear,
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
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
          ],
        ),
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        blocFilter.fetchAllFilter(widget.type, index);
        isLoading = false;
        page++;
      });
    }
  }
}
