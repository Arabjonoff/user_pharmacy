import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteEmptyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteEmptyScreenState();
  }
}

class _FavoriteEmptyScreenState extends State<FavoriteEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
    );
  }
}
