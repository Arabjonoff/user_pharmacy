import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/note_data_block.dart';
import 'package:pharmacy/src/database/database_helper_note.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class NoteAllListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteAllListScreenState();
  }
}

class _NoteAllListScreenState extends State<NoteAllListScreen> {
  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Widget slideRightBackground() {
    return Container(
      height: 68,
      margin: EdgeInsets.only(top: 16, left: 12, right: 12),
      decoration: BoxDecoration(
        color: AppTheme.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              translate("note.delete"),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      height: 68,
      margin: EdgeInsets.only(top: 16, left: 12, right: 12),
      decoration: BoxDecoration(
        color: AppTheme.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              translate("note.delete"),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  DatabaseHelperNote notes = new DatabaseHelperNote();

  @override
  Widget build(BuildContext context) {
    blocNote.fetchAllNote();
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: StreamBuilder(
        stream: blocNote.allNote,
        builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) {
                return Dismissible(
                  key: Key(snapshot.data[position].id.toString()),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 68,
                      margin: EdgeInsets.only(top: 16, left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  child: Text(
                                    snapshot.data[position].name,
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppTheme.fontRubik,
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
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: AppTheme.fontRubik,
                                      color: AppTheme.background,
                                      height: 1.27,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 16, bottom: 16),
                            child: Text(
                              snapshot.data[position].time,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontRubik,
                                color: AppTheme.black_text,
                                height: 1.23,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  // ignore: missing_return
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      notes
                          .getProductsGroup(snapshot.data[position].groupsName)
                          .then((value) => {
                                setState(() {
                                  notes.deleteProductsGroup(
                                      snapshot.data[position].groupsName);
                                }),
                                for (int i = 0; i < value.length; i++)
                                  {
                                    _cancelNotification(value[i].id),
                                  }
                              });
                      // snapshot.data.removeAt(position);
                    } else {
                      notes
                          .getProductsGroup(snapshot.data[position].groupsName)
                          .then((value) => {
                                setState(() {
                                  notes.deleteProductsGroup(
                                      snapshot.data[position].groupsName);
                                }),
                                for (int i = 0; i < value.length; i++)
                                  {
                                    _cancelNotification(value[i].id),
                                  }
                              });
                      // snapshot.data.removeAt(position);
                    }
                  },
                );
              },
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
}
