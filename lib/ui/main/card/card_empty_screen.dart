import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardEmptyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardEmptyScreenState();
  }
}

class _CardEmptyScreenState extends State<CardEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
    );
  }
}
