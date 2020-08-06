import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibrate/vibrate.dart';

// ignore: must_be_immutable
class DeleteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeleteScreenState();
  }
}

class _DeleteScreenState extends State<DeleteScreen> {
//  bool _canVibrate = true;
//
//  @override
//  initState() {
//    super.initState();
//    init();
//  }
//
//  init() async {
//    bool canVibrate = await Vibrate.canVibrate;
//    setState(() {
//      _canVibrate = canVibrate;
//      _canVibrate
//          ? print("This device can vibrate")
//          : print("This device cannot vibrate");
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Haptic Feedback Example')),
      body: new Center(
        child: new Column(children: <Widget>[
          new ListTile(
            title: new Text("Error"),
            leading: new Icon(Icons.error, color: Colors.red),
//              onTap: !_canVibrate
//                  ? null
//                  : () {
//                      Vibrate.feedback(FeedbackType.error);
//                    },
            onTap: () {
              Vibrate.feedback(FeedbackType.error);
            },
          ),
        ]),
      ),
    );
  }
}
