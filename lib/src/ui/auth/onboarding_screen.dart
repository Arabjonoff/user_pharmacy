import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/ui/login_region_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';

class OnBoarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingState();
  }
}

class _OnBoardingState extends State<OnBoarding> {
  PageController _pageController;
  int currentIndex = 0;

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
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: 24,
              top: 24,
            ),
            height: 56,
            child: GestureDetector(
              onTap: () {
                Utils.saveFirstOpen("yes");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginRegionScreen(),
                  ),
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Пропустить",
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF6E80B0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              controller: _pageController,
              children: <Widget>[
                makePage(
                  image: 'assets/images/step-one.png',
                  title: "Добро пожаловать",
                  content:
                      "В GoPharm - интернет аптека с доставкой по Узбекистану",
                  index: 0,
                ),
                makePage(
                  image: 'assets/images/step-two.png',
                  title: "Широкий ассортимент",
                  content:
                      "Более 12 000 видов препаратов находятся в онлайн аптеке Go Pharm",
                  index: 1,
                ),
                makePage(
                  image: 'assets/images/step-three.png',
                  title: "Быстрая доставка",
                  content:
                      "Заказ доставляется до вашего дома или офиса в кратчайщие сроки",
                  index: 2,
                ),
                makePage(
                  image: 'assets/images/step-four.png',
                  title: "Поиск аптек",
                  content:
                      "Благодаря приложению, вы легко можете определить ближайщую аптеку для вас",
                  index: 3,
                ),
                makePage(
                  image: 'assets/images/step-five.png',
                  title: "Расписание приема лекарств",
                  content:
                      "Приложение будет напоминать вам о приеме лекарств в нужное вам время",
                  index: 4,
                ),
                makePage(
                  image: 'assets/images/step-six.png',
                  title: "Бонусная программа",
                  content:
                      "Зарабатывай баллы от каждой сделанной покупки через наше приложение",
                  index: 5,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 24,
              top: 24,
              left: 25,
              right: 25,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: _buildIndicator(),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == 0) {
                setState(() {
                  currentIndex = 1;
                  _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  // _pageController.jumpToPage(1);
                });
              } else if (currentIndex == 1) {
                setState(() {
                  currentIndex = 2;
                  _pageController.animateToPage(
                    2,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  //_pageController.jumpToPage(2);
                });
              } else if (currentIndex == 2) {
                setState(() {
                  currentIndex = 3;
                  _pageController.animateToPage(
                    3,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  //_pageController.jumpToPage(2);
                });
              } else if (currentIndex == 3) {
                setState(() {
                  currentIndex = 4;
                  _pageController.animateToPage(
                    4,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  //_pageController.jumpToPage(2);
                });
              } else if (currentIndex == 4) {
                setState(() {
                  currentIndex = 5;
                  _pageController.animateToPage(
                    5,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  //_pageController.jumpToPage(2);
                });
              } else if (currentIndex == 5) {
                Utils.saveFirstOpen("yes");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginRegionScreen(),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(
                bottom: 24,
                left: 24,
                right: 24,
              ),
              height: 44,
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == 5 ? "Начать поиск" : "Далее",
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget makePage({image, title, content, index}) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Image.asset(
              image,
              fit: BoxFit.fitWidth,
              width: index == 0 ? 190 : MediaQuery.of(context).size.width,
              height: index == 0 ? 141 : MediaQuery.of(context).size.width,
            ),
          ),
        ),
        SizedBox(
          height: 53,
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: AppTheme.fontRubik,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            height: 1.1,
            color: AppTheme.darkText,
          ),
        ),
        Container(
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontRubik,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              height: 1.3,
              color: Color(0xFF6E80B0),
            ),
          ),
          margin: EdgeInsets.only(
            top: 16,
            left: 42,
            right: 42,
          ),
        ),
      ],
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 16 : 8,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.blue : Color(0xFFE2E6EF),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 6; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
