import 'package:flutter/material.dart';
import 'package:pharmacy/app_theme.dart';

class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  double cardWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Text('Animate!'),
              onPressed: () {
                setState(() {
                  cardWidth = 250.0;
                });
              },
            ),
            AnimatedContainer(
              duration: Duration(seconds: 10),
              width: cardWidth,
              height: 40,
              color: Colors.red,
              child: Center(
                child: Text("salom"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
