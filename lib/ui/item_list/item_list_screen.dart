import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/ui/search/search_screen.dart';

import '../../app_theme.dart';

class ItemListScreen extends StatefulWidget {
  String name;

  ItemListScreen(this.name);

  @override
  State<StatefulWidget> createState() {
    return _ItemListScreenState();
  }
}

class _ItemListScreenState extends State<ItemListScreen> {
  Size size;

  final List<String> imgSale = [
    'https://littleone.com/uploads/publication/6133/_840/5cf6754c5b7533.84660925.jpg',
    'http://apteka999.uz/img_product/563.jpg',
    'https://i0.wp.com/oldlekar.ru/wp-content/uploads/citramon.jpg',
    'https://www.sandoz.ru/sites/www.sandoz.ru/files/linex-16-32-48_0.png'
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 104,
            width: size.width,
            color: AppTheme.red_app_color,
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 3, bottom: 24),
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 104),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 56,
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.sort,
                              color: AppTheme.red_app_color,
                              size: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                translate("item.sort"),
                                style: TextStyle(
                                  fontSize: 19,
                                  color: AppTheme.black_text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.settings_applications,
                              color: AppTheme.red_app_color,
                              size: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                translate("item.filter"),
                                style: TextStyle(
                                  fontSize: 19,
                                  color: AppTheme.black_text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: 1,
                  color: Colors.black12,
                ),
                Container(
                  height: size.height - 160,
                  child: ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemCount: imgSale.length * 20,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(11),
                                    height: 120,
                                    width: 120,
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: imgSale[index % 4],
                                        placeholder: (context, url) =>
                                            Icon(Icons.camera_alt),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "Name\nName",
                                                style: TextStyle(
                                                  color: AppTheme.black_text,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.favorite_border,
                                                size: 24,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 7),
                                        Text(
                                          "sds",
                                          style: TextStyle(
                                            color:
                                                AppTheme.black_transparent_text,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.more_horiz,
                                              color: Colors.green,
                                              size: 36,
                                            ),
                                            SizedBox(width: 11),
                                            Expanded(
                                              child: Text(
                                                "SSSSSS",
                                                style: TextStyle(
                                                  color: AppTheme
                                                      .black_transparent_text,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 56,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "125 000 so'm",
                                                  style: TextStyle(
                                                    color: AppTheme.black_text,
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 75,
                                                height: 36,
                                                child: Material(
                                                  child: MaterialButton(
                                                    onPressed: () {},
                                                    child: Icon(
                                                      Icons.add_shopping_cart,
                                                      color: AppTheme.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  elevation: 5,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                  color: AppTheme.red_app_color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(left: 15, right: 15),
                            ),
                            Container(
                              height: 1,
                              color: Colors.black12,
                            )
                          ],
                        ),
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
