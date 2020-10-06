import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int k = 0;

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text("SSSSSSSSSSSS"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                startTimer();
              },
              child: Icon(
                Icons.edit,
                color: Colors.red,
                size: 36,
              ),
            ),
            SizedBox(height: 36),
            Text(k.toString()),
            SizedBox(height: 36),
            Text(_timer == null ? "Null" : _timer.isActive.toString())
          ],
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 600);
    if (_timer != null) {
      _timer.isActive
          // ignore: unnecessary_statements
          ? {
              _timer.cancel(),
              setState(() {
                k = 0;
              }),
            }
          : _timer = new Timer.periodic(
              oneSec,
              (Timer timer) => setState(
                () {
                  k++;
                },
              ),
            );
    } else {
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            k++;
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
