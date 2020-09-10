import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/aptek_block.dart';
import 'package:pharmacy/src/blocs/note_data_block.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import 'notification_screen.dart';

class NoteOneScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteOneScreenState();
  }
}

class _NoteOneScreenState extends State<NoteOneScreen> {
  @override
  Widget build(BuildContext context) {
    blocNote.fetchOneNote(DateTime.now());
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: StreamBuilder(
        stream: blocNote.oneNote,
        builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    DateTime.now().day.toString() +
                        " " +
                        getTimeFormat(
                          DateTime.now().month,
                        ),
                    style: TextStyle(
                      fontFamily: AppTheme.fontRoboto,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      color: AppTheme.black_text,
                      height: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 16),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, position) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          position == 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 16, right: 16, top: 16),
                                  child: Text(
                                    snapshot.data[position].dateItem
                                            .split(" ")[1]
                                            .split(":")[0] +
                                        ":" +
                                        snapshot.data[position].dateItem
                                            .split(" ")[1]
                                            .split(":")[1],
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: AppTheme.fontRoboto,
                                      color: AppTheme.black_transparent_text,
                                      height: 1.08,
                                    ),
                                  ),
                                  height: 16,
                                )
                              : snapshot.data[position - 1].dateItem
                                              .split(" ")[1]
                                              .split(":")[0] +
                                          ":" +
                                          snapshot.data[position - 1].dateItem
                                              .split(" ")[1]
                                              .split(":")[1] !=
                                      snapshot.data[position].dateItem
                                              .split(" ")[1]
                                              .split(":")[0] +
                                          ":" +
                                          snapshot.data[position].dateItem
                                              .split(" ")[1]
                                              .split(":")[1]
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left: 16, right: 16, top: 16),
                                      child: Text(
                                        snapshot.data[position].dateItem
                                                .split(" ")[1]
                                                .split(":")[0] +
                                            ":" +
                                            snapshot.data[position].dateItem
                                                .split(" ")[1]
                                                .split(":")[1],
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: AppTheme.fontRoboto,
                                          color:
                                              AppTheme.black_transparent_text,
                                          height: 1.08,
                                        ),
                                      ),
                                      height: 16,
                                    )
                                  : Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: NotificationScreen(
                                      snapshot.data[position].id),
                                ),
                              );
                            },
                            child: Container(
                              height: 68,
                              margin:
                                  EdgeInsets.only(top: 16, left: 12, right: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Text(
                                            snapshot.data[position].name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: AppTheme.fontRoboto,
                                              color: AppTheme.black_text,
                                              height: 1.23,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 3, left: 16, right: 16),
                                          child: Text(
                                            snapshot.data[position].eda,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: AppTheme.fontRoboto,
                                              color: AppTheme
                                                  .black_transparent_text,
                                              height: 1.27,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  snapshot.data[position].mark == 1
                                      ? Text(translate("note.prin"))
                                      : snapshot.data[position].mark == 2
                                          ? Text(translate("note.cancel"))
                                          : Container(),
                                  SizedBox(width: 8),
                                  snapshot.data[position].mark == 1
                                      ? SvgPicture.asset(
                                          "assets/images/icon_yes.svg")
                                      : snapshot.data[position].mark == 2
                                          ? SvgPicture.asset(
                                              "assets/images/icon_no.svg")
                                          : Container(),
                                  SizedBox(width: 12)
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
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
              padding: EdgeInsets.only(top: 8),
              itemBuilder: (_, __) => Container(
                height: 68,
                padding: EdgeInsets.only(top: 6, bottom: 6),
                margin: EdgeInsets.only(left: 15, top: 16, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppTheme.white,
                  ),
                ),
              ),
              itemCount: 20,
            ),
          );
        },
      ),
    );
  }

  getTimeFormat(int date) {
    switch (date) {
      case 1:
        return translate("month.january");
        break;
      case 2:
        return translate("month.february");
        break;
      case 3:
        return translate("month.march");
        break;
      case 4:
        return translate("month.april");
        break;
      case 5:
        return translate("month.may");
        break;
      case 6:
        return translate("month.june");
        break;
      case 7:
        return translate("month.july");
        break;
      case 8:
        return translate("month.august");
        break;
      case 9:
        return translate("month.september");
        break;
      case 10:
        return translate("month.october");
        break;
      case 11:
        return translate("month.november");
        break;
      case 12:
        return translate("month.december");
        break;
    }
  }
}
