import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/model/top_item_model.dart';
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
final List<TopItemModel> topItems = TopItemModel.topTitle;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var animationController;
  Size size;
  bool isLoad = true;
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
                                color: AppTheme.notWhite, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
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
                        Image.asset(topItems[index].image),
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
                right: 15,
                left: 15,
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
                            right: 15,
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
            margin: EdgeInsets.only(left: 15, right: 15, top: 32),
            child: Row(
              children: <Widget>[
                Text(
                  translate("home.best"),
                  style: TextStyle(
                    color: AppTheme.black_text,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
            itemCount:
                isLoad ? items.length > 3 ? 3 : items.length : items.length,
            itemBuilder: (context, index) {
              return ItemView(items[index]);
            },
          ),
          isLoad
              ? Container(
                  margin: EdgeInsets.only(top: 32.5, bottom: 32.5),
                  width: size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoad = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          border: Border.all(
                            color: AppTheme.green,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          translate(
                            "home.show_all",
                          ),
                          style: TextStyle(
                              fontSize: 15,
                              color: AppTheme.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
