import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';

import '../../app_theme.dart';

class ScannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScannerScreenState();
  }
}

class _ScannerScreenState extends State<ScannerScreen> {
  Size size;


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 80,
            width: size.width,
            color: AppTheme.red_app_color,
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 3),
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      translate("search_hint"),
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
