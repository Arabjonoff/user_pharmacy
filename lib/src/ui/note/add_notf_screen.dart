import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/database/database_helper_note.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/model/note/time_note.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';

import '../../app_theme.dart';

class AddNotifyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddNotifyScreenState();
  }
}

class _AddNotifyScreenState extends State<AddNotifyScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController dozaController = TextEditingController();
  TextEditingController edaController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  DatabaseHelperNote dataBase = new DatabaseHelperNote();

  List<TimeNote> timeList = List();

  _AddNotifyScreenState() {
    durationController.addListener(() {
      if (durationController.text.isNotEmpty) {
        if (int.parse(durationController.text) > 365) {
          durationController.text = "365";
        }
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool errorName = false;
  bool errorDoza = false;
  bool errorEda = false;
  bool errorDuration = false;
  bool errorTime = false;

  List<String> edaExamp = [
    "     ",
    translate("eda.empty"),
    translate("eda.before"),
    translate("eda.while"),
    translate("eda.after"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
            padding: EdgeInsets.all(19),
            child: SvgPicture.asset("assets/images/arrow_back.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("note.add_notf"),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.text_dark,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontRubik,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppTheme.auth_login,
                    border: Border.all(
                      color: errorName
                          ? AppTheme.red
                          : AppTheme.auth_border,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 15,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: translate('note.name'),
                        labelStyle: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6D7885),
                          fontSize: 11,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.auth_login,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.auth_login,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: Text(
                    translate("note.reception"),
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTheme.fontRubik,
                      height: 1.2,
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppTheme.auth_login,
                    border: Border.all(
                      color: errorDoza
                          ? AppTheme.red
                          : AppTheme.auth_border,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 15,
                      ),
                      controller: dozaController,
                      decoration: InputDecoration(
                        labelText: translate('note.doza'),
                        labelStyle: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6D7885),
                          fontSize: 11,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.auth_login,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.auth_login,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Picker picker = new Picker(
                        adapter:
                            PickerDataAdapter<String>(pickerdata: edaExamp),
                        changeToFirst: true,
                        textAlign: TextAlign.left,
                        columnPadding: const EdgeInsets.all(8.0),
                        onConfirm: (Picker picker, List value) {
                          setState(() {
                            edaController.text = picker.getSelectedValues()[0];
                          });
                        });
                    picker.show(_scaffoldKey.currentState);
                  },
                  child: Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppTheme.auth_login,
                      border: Border.all(
                        color: errorEda
                            ? AppTheme.red
                            : AppTheme.auth_border,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, left: 24, right: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  translate("note.eda"),
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: AppTheme.fontRubik,
                                    color: Color(0xFF6D7885),
                                    height: 1.27,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      edaController.text,
                                      style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          color: AppTheme.text_dark),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFB8C1CC),
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppTheme.auth_login,
                    border: Border.all(
                      color: errorDuration
                          ? AppTheme.red
                          : AppTheme.auth_border,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 15,
                      ),
                      controller: durationController,
                      decoration: InputDecoration(
                        labelText: translate('note.duration'),
                        labelStyle: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6D7885),
                          fontSize: 11,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.auth_login,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.auth_login,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: Text(
                    translate("note.time"),
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTheme.fontRubik,
                      height: 1.2,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: timeList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      height: 56,
                      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppTheme.auth_login,
                        border: Border.all(
                          color: AppTheme.auth_border,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 12, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              translate("note.reception") +
                                  " " +
                                  (index + 1).toString(),
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRubik,
                                color: Color(0xFF6D7885),
                                height: 1.27,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _toTwoDigitString(timeList[index].hour) +
                                      ":" +
                                      _toTwoDigitString(timeList[index].minute),
                                  style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      color: AppTheme.text_dark),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        setState(() {
                          timeList.add(TimeNote(
                            hour: date.hour,
                            minute: date.minute,
                          ));
                          errorTime = false;
                        });
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                    height: 48,
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: errorTime
                                ? AppTheme.red
                                : AppTheme.blue,
                            width: 1)),
                    child: Icon(
                      Icons.add,
                      color: AppTheme.blue,
                      size: 24,
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (nameController.text.isNotEmpty) {
                if (dozaController.text.isNotEmpty) {
                  if (edaController.text.isNotEmpty) {
                    if (durationController.text.isNotEmpty) {
                      if (timeList.length > 0) {
                        var groupName =
                            (DateTime.now().millisecondsSinceEpoch / 1000)
                                .toString();
                        var time = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);

                        var times = "";
                        for (int i = 0; i < timeList.length; i++) {
                          if (i != timeList.length - 1)
                            times += _toTwoDigitString(timeList[i].hour) +
                                ":" +
                                _toTwoDigitString(timeList[i].minute)
                                    .toString() +
                                ", ";
                          else
                            times += _toTwoDigitString(timeList[i].hour) +
                                ":" +
                                _toTwoDigitString(timeList[i].minute)
                                    .toString();
                        }

                        for (int j = 0;
                            j < int.parse(durationController.text);
                            j++) {
                          for (int i = 0; i < timeList.length; i++) {
                            dataBase
                                .saveProducts(
                                  NoteModel(
                                    name: nameController.text.toString(),
                                    doza: dozaController.text.toString(),
                                    eda: edaController.text.toString(),
                                    time: times,
                                    groupsName: groupName,
                                    dateItem: time
                                        .add(Duration(
                                          days: j,
                                          hours: timeList[i].hour,
                                          minutes: timeList[i].minute,
                                        ))
                                        .toString(),
                                    mark: 0,
                                  ),
                                )
                                .then((value) => {
                                      scheduleNotification(
                                        value,
                                        groupName,
                                        nameController.text.toString(),
                                        dozaController.text.toString(),
                                        time.add(
                                          Duration(
                                            days: j,
                                            hours: timeList[i].hour,
                                            minutes: timeList[i].minute,
                                          ),
                                        ),
                                      ),
                                    });
                          }
                        }

                        Navigator.pop(context);
                      } else {
                        setState(() {
                          errorTime = true;
                        });
                      }
                    } else {
                      setState(() {
                        errorDuration = true;
                      });
                    }
                  } else {
                    setState(() {
                      errorEda = true;
                    });
                  }
                } else {
                  setState(() {
                    errorDoza = true;
                  });
                }
              } else {
                setState(() {
                  errorName = true;
                });
              }
            },
            child: Container(
              height: 44,
              margin: EdgeInsets.only(top: 24, left: 12, right: 12, bottom: 28),
              decoration: BoxDecoration(
                color: AppTheme.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  translate("note.add"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    fontStyle: FontStyle.normal,
                    color: AppTheme.white,
                    height: 1.29,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> scheduleNotification(
      int id, String groupName, String name, String doza, DateTime time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupName,
      name,
      name + " " + doza,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        translate("note.notf_title") +
            ' ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}',
        translate("note.drug") +
            " " +
            name +
            "   " +
            translate("note.dozasi") +
            " " +
            doza,
        time,
        platformChannelSpecifics);
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
}
