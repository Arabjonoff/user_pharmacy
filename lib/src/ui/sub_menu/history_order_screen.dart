import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/history_bloc.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class HistoryOrderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryOrderScreenState();
  }
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  @override
  Widget build(BuildContext context) {
    blocHistory.fetchAllHistory();
    return Scaffold(
        backgroundColor: AppTheme.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1.0,
            backgroundColor: AppTheme.white,
            brightness: Brightness.light,
            title: Container(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3.5),
                    child: GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 24,
                        color: AppTheme.blue_app_color,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 3.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translate("menu.history"),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontCommons,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: blocHistory.allHistory,
          builder: (context, AsyncSnapshot<HistoryModel> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.results.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.results.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          height: 260,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: Text(
                                  "№" +
                                      snapshot.data.results[index].id
                                          .toString(),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 2),
                                child: Text(
                                  snapshot.data.results[index].shipdate,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: AppTheme.black_linear_category,
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 17),
                              ),
                              Container(
                                height: 25,
                                margin: EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      snapshot.data.results[index].type ==
                                              "self"
                                          ? translate("history.somviz")
                                          : translate("history.dostavka"),
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRoboto,
                                        color: AppTheme.black_text,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          color: snapshot.data.results[index]
                                                      .status ==
                                                  "pending"
                                              ? Color(0xFF792EC0)
                                              : Color(0xFFA3ADB8)),
                                      height: 24,
                                      width: 85,
                                      child: Center(
                                        child: Text(
                                          translate(
                                              "history.${snapshot.data.results[index].status}"),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRoboto,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color: AppTheme.white,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: Text(
                                  translate("history.date") +
                                      snapshot.data.results[index].shipdate,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 4),
                                child: Text(
                                  translate("history.price") +
                                      " " +
                                      priceFormat.format(
                                          snapshot.data.results[index].total) +
                                      translate("sum"),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.black_transparent_text,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 16, bottom: 16),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      bottom: 0,
                                      right: 16,
                                      left: 16,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot
                                        .data.results[index].items.length,
                                    itemBuilder:
                                        (BuildContext context, int subindex) {
                                      return Container(
                                        width: 56,
                                        height: 56,
                                        margin: EdgeInsets.only(right: 16),
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot
                                                .data
                                                .results[index]
                                                .items[subindex]
                                                .drug
                                                .imageThumbnail,
                                            placeholder: (context, url) =>
                                                Icon(Icons.camera_alt),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 153,
                          width: 153,
                          child: SvgPicture.asset(
                              "assets/images/empty_history.svg"),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25, left: 16, right: 16),
                          alignment: Alignment.center,
                          child: Text(
                            translate("menu_sub.history_title"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_text,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                          child: Text(
                            translate("menu_sub.history_message"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_transparent_text,
                            ),
                          ),
                        ),
                      ],
                    );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    height: 260,
                  );
                },
              ),
            );
          },
        ));
  }
}
