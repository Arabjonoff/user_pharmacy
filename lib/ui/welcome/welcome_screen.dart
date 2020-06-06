import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/app_theme.dart';

import '../main_screen.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PageController _pageController;
  int currentIndex = 0;
  Size size;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: GestureDetector(
              child: Text(
                translate("welcome.skip"),
                style: TextStyle(
                  color: AppTheme.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return MainScreen();
                }));
              },
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              makePage(
                image: 'assets/images/step-one.png',
                title: translate("welcome.one_title"),
                content: translate("welcome.one_content"),
              ),
              makePage(
                reverse: true,
                image: 'assets/images/step-two.png',
                title: translate("welcome.two_title"),
                content: translate("welcome.two_content"),
              ),
              makePage(
                image: 'assets/images/step-three.png',
                title: translate("welcome.three_title"),
                content: translate("welcome.three_content"),
              ),
            ],
          ),
          currentIndex < 2
              ? Container(
                  margin: EdgeInsets.only(bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator(),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 60, left: 120),
                  height: 56,
                  width: size.width - 120,
                  child: Material(
                    elevation: 5,
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9.0),
                        topLeft: Radius.circular(9.0)),
                    child: MaterialButton(
                      child: Text(
                        translate("welcome.login"),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) {
                          return MainScreen();
                        }));
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            style: TextStyle(
                color: AppTheme.dark_grey,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.grey,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          reverse
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 9,
      width: isActive ? 45 : 9,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
