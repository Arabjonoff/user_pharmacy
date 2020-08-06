import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DeleteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeleteScreenState();
  }
}

String selectedUrl = 'https://flutter.io';

class _DeleteScreenState extends State<DeleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
      ),
      body: GestureDetector(
        onTap: () async {
          var url = 'https://api.gopharm.uz/terms';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Container(
          height: 450,
          color: AppTheme.white,
          width: double.infinity,
        ),
      ),
    );
  }
}
