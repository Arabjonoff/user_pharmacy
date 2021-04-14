import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/model/ramadan_model.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';

class MyAppDelete extends StatefulWidget {
  @override
  _MyAppDeleteState createState() => _MyAppDeleteState();
}

class _MyAppDeleteState extends State<MyAppDelete> {
  List<RamadanModel> list = [
    RamadanModel(
      id: 1,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 15, 4, 22),
    ),
    RamadanModel(
      id: 2,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 15, 19, 05),
    ),
    RamadanModel(
      id: 3,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 16, 4, 20),
    ),
    RamadanModel(
      id: 4,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 16, 19, 06),
    ),
    RamadanModel(
      id: 5,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 17, 4, 18),
    ),
    RamadanModel(
      id: 6,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 17, 19, 07),
    ),
    RamadanModel(
      id: 7,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 18, 4, 16),
    ),
    RamadanModel(
      id: 8,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 18, 19, 08),
    ),
    RamadanModel(
      id: 9,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 19, 4, 14),
    ),
    RamadanModel(
      id: 10,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 19, 19, 09),
    ),
    RamadanModel(
      id: 11,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 20, 4, 13),
    ),
    RamadanModel(
      id: 12,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 20, 19, 10),
    ),
    RamadanModel(
      id: 13,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 21, 4, 11),
    ),
    RamadanModel(
      id: 14,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 21, 19, 11),
    ),
    RamadanModel(
      id: 15,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 22, 4, 09),
    ),
    RamadanModel(
      id: 16,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 22, 19, 13),
    ),
    RamadanModel(
      id: 17,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 23, 4, 07),
    ),
    RamadanModel(
      id: 18,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 23, 19, 14),
    ),
    RamadanModel(
      id: 19,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 24, 4, 05),
    ),
    RamadanModel(
      id: 20,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 24, 19, 15),
    ),
    RamadanModel(
      id: 21,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 25, 4, 04),
    ),
    RamadanModel(
      id: 22,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 25, 19, 16),
    ),
    RamadanModel(
      id: 23,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 26, 4, 02),
    ),
    RamadanModel(
      id: 24,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 26, 19, 17),
    ),
    RamadanModel(
      id: 25,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 27, 4, 00),
    ),
    RamadanModel(
      id: 26,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 27, 19, 18),
    ),
    RamadanModel(
      id: 27,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 28, 3, 58),
    ),
    RamadanModel(
      id: 28,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 28, 19, 19),
    ),
    RamadanModel(
      id: 29,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 29, 3, 57),
    ),
    RamadanModel(
      id: 30,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 29, 19, 20),
    ),
    RamadanModel(
      id: 31,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 30, 3, 55),
    ),
    RamadanModel(
      id: 32,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 4, 30, 19, 21),
    ),
    RamadanModel(
      id: 33,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 1, 3, 53),
    ),
    RamadanModel(
      id: 34,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 1, 19, 22),
    ),
    RamadanModel(
      id: 35,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 2, 3, 51),
    ),
    RamadanModel(
      id: 36,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 2, 19, 23),
    ),
    RamadanModel(
      id: 37,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 3, 3, 50),
    ),
    RamadanModel(
      id: 38,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 3, 19, 24),
    ),
    RamadanModel(
      id: 39,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 4, 3, 48),
    ),
    RamadanModel(
      id: 40,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 4, 19, 25),
    ),
    RamadanModel(
      id: 41,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 5, 3, 46),
    ),
    RamadanModel(
      id: 42,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 5, 19, 26),
    ),
    RamadanModel(
      id: 43,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 6, 3, 45),
    ),
    RamadanModel(
      id: 44,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 6, 19, 27),
    ),
    RamadanModel(
      id: 45,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 7, 3, 43),
    ),
    RamadanModel(
      id: 46,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 7, 19, 28),
    ),
    RamadanModel(
      id: 47,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 8, 3, 42),
    ),
    RamadanModel(
      id: 48,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 8, 19, 29),
    ),
    RamadanModel(
      id: 49,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 9, 3, 40),
    ),
    RamadanModel(
      id: 50,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 9, 19, 31),
    ),
    RamadanModel(
      id: 51,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 10, 3, 39),
    ),
    RamadanModel(
      id: 52,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 10, 19, 32),
    ),
    RamadanModel(
      id: 53,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 11, 3, 37),
    ),
    RamadanModel(
      id: 54,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 11, 19, 33),
    ),
    RamadanModel(
      id: 55,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 12, 3, 36),
    ),
    RamadanModel(
      id: 56,
      title: "Title",
      message: "Message",
      dateTime: DateTime(2021, 5, 12, 19, 34),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              scheduleNotification(
                1,
                "groupName",
                "nameController.text.toString()",
                DateTime(2021, 4, 14, 16, 18),
              );
            },
            child: Container(
              height: 56,
              width: double.infinity,
              color: AppTheme.red_fav_color,
            ),
          )
        ],
      ),
    );
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime time,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id.toString(),
      title,
      title + " " + body,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      body,
      time,
      platformChannelSpecifics,
    );
  }
}
