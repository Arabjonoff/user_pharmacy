import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
