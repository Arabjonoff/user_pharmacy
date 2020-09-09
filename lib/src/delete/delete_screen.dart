import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharmacy/main.dart';
import 'package:pharmacy/src/app_theme.dart';

class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PaddedRaisedButton({
    @required this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed),
    );
  }
}

// ignore: must_be_immutable
class DeleteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeleteScreenState();
  }
}

class _DeleteScreenState extends State<DeleteScreen> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                PaddedRaisedButton(
                  buttonText:
                      'Repeat notification every day at approximately 12:16:00 am',
                  onPressed: () async {
                    await _showDailyAtTime();
                  },
                ),
                PaddedRaisedButton(
                  buttonText:
                      'Repeat notification every day at approximately 12:17:00 am',
                  onPressed: () async {
                    await _showDailyAtTim();
                  },
                ),
                PaddedRaisedButton(
                  buttonText: '5',
                  onPressed: () async {
                    await scheduleNotification(0, second: 5);
                  },
                ),
                PaddedRaisedButton(
                  buttonText: 'cancel',
                  onPressed: () async {
                    await _cancelNotification();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDailyAtTime() async {
    var time = Time(13, 41, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title w11',
        'Daily at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }

  Future<void> _showDailyAtTim() async {
    var time = Time(13, 41, 30);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id 2', 'channel name2 ', 'description2 ');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1,
        'show daily title 222',
        'Daily 2 shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }

  Future<void> scheduleNotification(int id,
      {int, days, int hour, int minute, int second}) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));

    for (var i = 0; i < 5; i++) {
      print(DateTime.now()
          .add(Duration(days: i, hours: 14, minutes: 56, seconds: 5)));
      print("//////////////////////////////");
      print("//////////////////////////////");
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dfvdbdgb other channel id',
      'your other csdcsd name',
      'your other scsdcsdc description',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        'Dori ichish vaqti: ${_toTwoDigitString(scheduledNotificationDateTime.hour)}:${_toTwoDigitString(scheduledNotificationDateTime.minute)}',
        'Dori: Aspirin   Dozasi: 0.5',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen with payload: ${(_payload ?? '')}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
