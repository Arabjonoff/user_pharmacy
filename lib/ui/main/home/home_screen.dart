import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/search/search_screen.dart';
import 'package:pharmacy/ui/view/item_view.dart';
import 'package:pharmacy/utils/utils.dart';

import '../../../app_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

final List<ItemModel> items = ItemModel.itemsModel;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var animationController;
  Size size;
  List<ItemModel> itemCard = new List();
  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    dataBase.getAllProducts().then((products) {
      setState(() {
        products.forEach((products) {
          itemCard.add(ItemModel.fromMap(products));
        });
        for (var i = 0; i < items.length; i++) {
          for (var j = 0; j < itemCard.length; j++) {
            if (items[i].id == itemCard[j].id) {
              items[i].cardCount = itemCard[j].cardCount;
              items[i].favourite = itemCard[j].favourite;
            }
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Container(
          height: 36,
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: SearchScreen(""),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: AppTheme.black_transparent,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: new Icon(
                            Icons.search,
                            size: 24,
                            color: AppTheme.notWhite,
                          ),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Text(
                            translate("search_hint"),
                            style: TextStyle(
                              color: AppTheme.notWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: new Icon(
                    Icons.scanner,
                    size: 24,
                    color: AppTheme.green,
                  ),
                  onPressed: () {
                    var response = Utils.scanBarcodeNormal();
                    response.then(
                      (value) => Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: SearchScreen(value),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.white,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            height: 150.0,
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 0,
                right: 15,
                left: 15,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                animationController.forward();
                return Container(
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(9.0),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9.0),
                          child: Container(
                            width: 135,
                            height: 135,
                            child: CachedNetworkImage(
                              imageUrl: items[index].image,
                              placeholder: (context, url) =>
                                  Icon(Icons.camera_alt),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 10,
                    right: 15,
                  ),
                  width: 150,
                  height: 150,
                );
              },
            ),
          ),
          Container(
            height: 220.0,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 0,
                right: 15,
                left: 15,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final int count = items.length > 10 ? 10 : items.length;
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Material(
                                elevation: 1,
                                borderRadius: BorderRadius.circular(9.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9.0),
                                  child: Container(
                                    color: AppTheme.white,
                                    width: 300,
                                    height: 148,
                                    child: CachedNetworkImage(
                                      imageUrl: items[index].image,
                                      placeholder: (context, url) =>
                                          Icon(Icons.camera_alt),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7, bottom: 15),
                                child: Text(
                                  'до ' + index.toString() + ' апрель',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.notWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 10,
                            right: 15,
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
            height: 5,
            color: AppTheme.black_transparent,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 25),
            child: Row(
              children: <Widget>[
                Text(
                  translate("home.best"),
                  style: TextStyle(
                    color: AppTheme.black_text,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ItemView(items[index]);
            },
          )
        ],
      ),
    );
  }
}
