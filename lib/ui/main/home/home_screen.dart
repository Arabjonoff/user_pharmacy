import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/model/top_item_model.dart';
import 'package:pharmacy/ui/search/search_screen.dart';
import 'package:pharmacy/utils/utils.dart';

import '../../../app_theme.dart';

final priceFormat = new NumberFormat("#,##0", "ru");

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

final List<ItemModel> items = ItemModel.itemsModel;
final List<TopItemModel> topItems = TopItemModel.topTitle;

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
                        ),
                        Expanded(
                          child: Text(
                            translate("search_hint"),
                            style: TextStyle(
                              color: AppTheme.notWhite,
                              fontSize: 15,
                              fontFamily: AppTheme.fontRoboto,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 17),
                    child: Center(
                      child: Image.asset("assets/images/scanner.png"),
                    ),
                  ),
                  onTap: () {
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
            height: 113.0,
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 0,
                right: 15,
                left: 15,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: topItems.length,
              itemBuilder: (BuildContext context, int index) {
                animationController.forward();
                return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: [
                        SvgPicture.asset(topItems[index].image),
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          width: 113,
                          height: 113,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                height: 23,
                              ),
                              SizedBox(
                                height: 16,
                                child: Text(
                                  topItems[index].name,
                                  style: TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 13,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22,
                                child: Text(
                                  topItems[index].title.toUpperCase(),
                                  style: TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 17,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(
                    right: 12,
                  ),
                  width: 128,
                  height: 113,
                );
              },
            ),
          ),
          Container(
            height: 154.0,
            margin: EdgeInsets.only(top: 32),
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 0,
                right: 12,
                left: 12,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                //final int count = items.length > 10 ? 10 : items.length;
                final int count = 5;
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  color: AppTheme.white,
                                  width: 311,
                                  height: 154,
//                                    child: CachedNetworkImage(
//                                      imageUrl: items[index].image,
//                                      placeholder: (context, url) =>
//                                          Icon(Icons.camera_alt),
//                                      errorWidget: (context, url, error) =>
//                                          Icon(Icons.error),
//                                      fit: BoxFit.fitHeight,
//                                    ),
                                  child: Image.asset("assets/images/sale.png"),
                                ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            right: 12,
                          ),
                          height: 154,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 32),
            child: Row(
              children: <Widget>[
                Text(
                  translate("home.best"),
                  style: TextStyle(
                    color: AppTheme.black_text,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontRoboto,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  translate("home.show_all"),
                  style: TextStyle(
                    color: AppTheme.blue_app_color,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontRoboto,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 250.0,
            margin: EdgeInsets.only(top: 16),
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 0,
                right: 12,
                left: 12,
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
                          width: 140,
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                child: CachedNetworkImage(
                                  imageUrl: items[index].image,
                                  placeholder: (context, url) =>
                                      Icon(Icons.camera_alt),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  items[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppTheme.black_text,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: Text(
                                  items[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppTheme.black_transparent_text,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 120,
                                margin: EdgeInsets.only(top: 11),
                                child: items[index].cardCount > 0
                                    ? Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppTheme.blue_transparent,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        width: 120,
                                        child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.0,
                                                  ),
                                                ),
                                                margin: EdgeInsets.all(2.0),
                                                height: 26,
                                                width: 26,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: AppTheme.white,
                                                    size: 19,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (items[index].cardCount >
                                                    1) {
                                                  setState(() {
                                                    items[index].cardCount =
                                                        items[index].cardCount -
                                                            1;
                                                    dataBase.updateProduct(
                                                        items[index]);
                                                  });
                                                } else if (items[index]
                                                        .cardCount ==
                                                    1) {
                                                  setState(() {
                                                    items[index].cardCount =
                                                        items[index].cardCount -
                                                            1;
                                                    if (items[index]
                                                        .favourite) {
                                                      dataBase.updateProduct(
                                                          items[index]);
                                                    } else {
                                                      dataBase.deleteProducts(
                                                          items[index].id);
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                            Container(
                                              height: 30,
                                              width: 60,
                                              child: Center(
                                                child: Text(
                                                  items[index]
                                                          .cardCount
                                                          .toString() +
                                                      " " +
                                                      translate("item.sht"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: AppTheme.blue,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  items[index].cardCount =
                                                      items[index].cardCount +
                                                          1;
                                                  dataBase.updateProduct(
                                                      items[index]);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.0,
                                                  ),
                                                ),
                                                height: 26,
                                                width: 26,
                                                margin: EdgeInsets.all(2.0),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: AppTheme.white,
                                                    size: 19,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            items[index].cardCount = 1;
                                            if (items[index].favourite) {
                                              dataBase
                                                  .updateProduct(items[index]);
                                            } else {
                                              dataBase
                                                  .saveProducts(items[index]);
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            color: AppTheme.blue,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  priceFormat.format(
                                                          items[index].price) +
                                                      translate("sum"),
                                                  style: TextStyle(
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        AppTheme.fontRoboto,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                "assets/images/card_icon.svg",
                                              ),
                                              SizedBox(
                                                width: 8.11,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            right: 12,
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
    );
  }
}
