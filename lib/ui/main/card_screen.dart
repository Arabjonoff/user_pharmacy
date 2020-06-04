import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/database/database_helper_card.dart';

class CardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardScreenState();
  }
}

class _CardScreenState extends State<CardScreen> {
  DatabaseHelperCard dbCard = new DatabaseHelperCard();

  @override
  void initState() {
    super.initState();
    dbCard.getAllProducts().then((products) {
      setState(() {
      //  print(products.length.toString());
      });
    });
  }

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
