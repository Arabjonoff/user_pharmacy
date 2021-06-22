import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/database/database_helper_note.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen(this.id);

  final int id;

  @override
  State<StatefulWidget> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  DatabaseHelperNote databaseHelperNote = new DatabaseHelperNote();

  String name = "", eda = "", time = "", fullName = "";

  NoteModel items = new NoteModel();

  @override
  void initState() {
    getInfo();
    super.initState();
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
                    color: AppTheme.red,
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Container(
              height: 36,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(right: 6),
                      color: AppTheme.blue,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: SvgPicture.asset(
                                "assets/images/arrow_close.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SvgPicture.asset("assets/images/icon_item_drug.svg"),
            ),
            Container(
              height: 390,
              color: AppTheme.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 13,
                                  height: 1.23,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppTheme.fontRubik,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                eda,
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11,
                                  height: 1.23,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: AppTheme.fontRubik,
                                  color: AppTheme.background,
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontRubik,
                            color: AppTheme.text_dark,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      fullName == ""
                          ? translate("note.one_title")
                          : fullName + ", " + translate("note.one_title"),
                      style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          color: AppTheme.text_dark,
                          height: 1.38),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        translate("note.one_message"),
                        style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.text_dark,
                            height: 1.85),
                      ),
                    ),
                  ),
                  widget.id != -1
                      ? GestureDetector(
                          onTap: () {
                            items.mark = 2;
                            _cancelNotification(items.id);
                            databaseHelperNote.updateProduct(items);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            height: 44,
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppTheme.blue, width: 1)),
                            child: Center(
                              child: Text(
                                translate("note.next"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.blue,
                                  height: 1.29,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  widget.id != -1
                      ? GestureDetector(
                          onTap: () {
                            items.mark = 1;
                            _cancelNotification(items.id);
                            databaseHelperNote.updateProduct(items);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 32,
                              top: 16,
                            ),
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                translate("note.now"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.white,
                                  height: 1.29,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.id != -1)
      databaseHelperNote.getProducts(widget.id).then((value) => {
            setState(() {
              items = value;
              name = value.name;
              eda = value.eda;
              time = value.dateItem.split(" ")[1].split(":")[0] +
                  ":" +
                  value.dateItem.split(" ")[1].split(":")[1];
            }),
          });
    setState(() {
      var name = prefs.getString("name");
      if (name != null) {
        fullName = name;
      }
    });
  }
}
