import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyExampleApp extends StatefulWidget {
  @override
  _MyExampleAppState createState() => _MyExampleAppState();
}

class _MyExampleAppState extends State<MyExampleApp> {

  @override
  Widget build(BuildContext context) {
    const decorator = DotsDecorator(
      activeColor: Colors.red,
      activeSize: Size.square(50.0),
      activeShape: RoundedRectangleBorder(),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dots indicator example'),
        ),
        body: Center(
          child: new DotsIndicator(
            dotsCount: 15,
            position: 3,
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
