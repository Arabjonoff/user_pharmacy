import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/ui/search/search_screen.dart';

import '../../app_theme.dart';

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
        duration: const Duration(milliseconds: 5000), vsync: this);
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
    'https://img4.postila.ru/storage/2432000/2417963/5fe49b9e07b3cd441cf26c11171939cb.jpg'
  ];
  final List<String> imgSale = [
    'https://littleone.com/uploads/publication/6133/_840/5cf6754c5b7533.84660925.jpg',
    'http://apteka999.uz/img_product/563.jpg',
    'https://i0.wp.com/oldlekar.ru/wp-content/uploads/citramon.jpg',
    'https://www.sandoz.ru/sites/www.sandoz.ru/files/linex-16-32-48_0.png'
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
                      Container(
                        width: 1000.0,
                        height: 150,
                        child: CachedNetworkImage(
                          imageUrl: item,
                          placeholder: (context, url) => Icon(Icons.camera_alt),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
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
                              color: AppTheme.white,
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
      backgroundColor: AppTheme.background,
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            color: AppTheme.red_app_color,
          ),
          Container(
            margin: EdgeInsets.only(top: 104),
            height: size.height - 104,
            child: ListView(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 20),
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
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 20),
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
                    style: TextStyle(
                      color: AppTheme.black_text,
                      fontSize: 21,
                    ),
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
                  margin: EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: Row(
                    children: <Widget>[
                      Text(
                        translate("home.sale"),
                        style: TextStyle(
                          color: AppTheme.black_text,
                          fontSize: 19,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        translate("home.all"),
                        style: TextStyle(
                          color: AppTheme.black_transparent_text,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 180.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 15, left: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: imgSale.length,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          imgSale.length > 10 ? 10 : imgSale.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
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
                              child: Container(
                                width: 170,
                                height: 170,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: Material(
                                        elevation: 5,
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        child: CachedNetworkImage(
                                          imageUrl: imgSale[index],
                                          placeholder: (context, url) =>
                                              Icon(Icons.camera_alt),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        top: 16,
                                        bottom: 16,
                                        right: 9,
                                      ),
                                      width: 170,
                                      height: 170,
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
                  height: 80,
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
                          curve: Interval((1 / count) * index, 1.0,
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
                                height: 70,
                                width: 150,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          left: 8,
                                          right: 8,
                                          bottom: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.grey,
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
                        color: AppTheme.red_app_color,
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
