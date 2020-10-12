import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/provider/home_screen_provider.dart';
import 'package:provider/provider.dart';

class MyAppDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<HomeScreenProvider>(
      create: (context) => HomeScreenProvider(),
      child: Consumer<HomeScreenProvider>(
        builder: (context, myModel, child) {
          return ValueListenableProvider<String>.value(
            value: myModel.cityName,
            child: Scaffold(
              appBar: AppBar(title: Text('My App')),
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.green[200],
                      child: Consumer<HomeScreenProvider>(
                        builder: (context, myModel, child) {
                          return RaisedButton(
                            child: Text('something'),
                            onPressed: () {
                              myModel.getCityName();
                            },
                          );
                        },
                      )),
                  Container(
                    padding: const EdgeInsets.all(35),
                    color: Colors.blue[200],
                    child: Consumer<String>(
                      builder: (context, myValue, child) {
                        return Text(myValue);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
