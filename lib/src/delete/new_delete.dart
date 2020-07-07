import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/delete/delete_examp.dart';

class NewDelete extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewDeleteState();
  }
}

class _NewDeleteState extends State<NewDelete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: GestureDetector(
        onTap: () {
          setData();
        },
        child: Container(
          height: 450,
          color: AppTheme.red_fav_color,
        ),
      ),
    );
  }
}
