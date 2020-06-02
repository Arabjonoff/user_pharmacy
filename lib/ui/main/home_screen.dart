import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/ui/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var animationController;
  Size size;
  TextEditingController searchController = TextEditingController();
  bool isSearchText = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _HomeScreenState() {
    searchController.addListener(() {
      if (searchController.text.length > 0) {
        setState(() {
          isSearchText = true;
        });
      } else {
        setState(() {
          isSearchText = false;
        });
      }
      print(searchController.text);
    });
  }

  final List<String> imgList = [
    'https://cdn.bmwblog.com/wp-content/uploads/2020/05/2020-BMW-X1-xDrive20i-67-1260x608.jpg',
    'http://cdn.motorpage.ru/Photos/800/110BD.jpg',
    'https://img4.postila.ru/storage/2432000/2417963/5fe49b9e07b3cd441cf26c11171939cb.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    int _current = 0;
    final List<Widget> imageSliders = imgList
        .map(
          (item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: 1000.0,
                        height: 150,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF2F3F8),
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            color: Color(0xFFD00B52),
          ),
          Container(
            margin: EdgeInsets.only(top: 104),
            height: size.height - 104,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  height: 105,
                  child: Image.asset(
                    "assets/karta_aptika.jpg",
                    height: 105,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: 180,
                  child: Column(
                    children: [
                      CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            height: 150,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.map((url) {
                          int index = imgList.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  height: 120,
                  child: Image.asset(
                    "assets/give_karta.jpg",
                    height: 105,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    translate("home.question"),
                    style: TextStyle(color: Colors.black87, fontSize: 21),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  height: 75,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(9.0),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.message,
                                  color: Colors.green,
                                  size: 48,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      translate("home.message"),
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(9.0),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.message,
                                  color: Colors.green,
                                  size: 48,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      translate("home.call"),
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 15, left: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: imgList.length * 3,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          imgList.length > 10 ? 10 : imgList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / 10) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                            opacity: animation,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  100 * (1.0 - animation.value), 0.0, 0.0),
                              child: SizedBox(
                                width: 130,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 32,
                                          left: 8,
                                          right: 8,
                                          bottom: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  height: 45,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80, left: 15, right: 15, bottom: 15),
            height: 48,
            width: double.infinity,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(9.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: SearchScreen(),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: new Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        translate("search_hint"),
                      ),
                    ),
                    IconButton(
                      icon: new Icon(
                        Icons.scanner,
                        size: 24,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        print("click");
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
