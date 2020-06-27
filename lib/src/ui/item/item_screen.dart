import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/utils/api.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemScreen extends StatefulWidget {
  int id;

  ItemScreen(this.id);

  @override
  State<StatefulWidget> createState() {
    return _ItemScreenState();
  }
}

final List<ItemResult> items = new List();

class _ItemScreenState extends State<ItemScreen>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();

  ItemsAllModel data = new ItemsAllModel();

  final List<Widget> myTabs = [
    Tab(text: translate("item.description")),
    Tab(text: translate("item.instruction")),
  ];

  TabController _tabController;
  ScrollController _scrollController;

  List<ItemResult> itemCard = new List();
  DatabaseHelper dataBase = new DatabaseHelper();

  Widget _buildCarousel() {
    return Stack(
      children: <Widget>[
        Container(
          height: 464,
          color: AppTheme.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 240,
                  width: 240,
                  margin: EdgeInsets.only(top: 52),
                  child: Center(
                    child: CachedNetworkImage(
                      height: 240,
                      width: 240,
                      imageUrl: data.image,
                      placeholder: (context, url) => Icon(Icons.camera_alt),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 24,
                  left: 17,
                  right: 18,
                ),
                child: Row(
                  children: [
                    Text(
                      data.manufacturer.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppTheme.fontRoboto,
                        color: AppTheme.blue_app_color,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      child: false
                          ? Icon(
                              Icons.favorite,
                              size: 24,
                              color: AppTheme.blue_app_color,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 24,
                              color: AppTheme.arrow_catalog,
                            ),
                      onTap: () {
                        setState(() {
//                      if (widget.item.favourite) {
//                        widget.item.favourite = false;
//                        if (widget.item.cardCount == 0) {
//                          dataBase.deleteProducts(widget.item.id);
//                        } else {
//                          dataBase.updateProduct(widget.item);
//                        }
//                      } else {
//                        widget.item.favourite = true;
//                        if (widget.item.cardCount == 0) {
//                          dataBase.saveProducts(widget.item);
//                        } else {
//                          dataBase.updateProduct(widget.item);
//                        }
//                      }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, left: 16),
                child: Text(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.black_text,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontRoboto,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24, left: 16),
                child: Row(
                  children: [
                    Text(
                      data.price.toString(),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.fontRoboto,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      translate("sum"),
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.fontRoboto,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);

    dataBase.getAllProducts().then((products) {
      setState(() {
        products.forEach((products) {
          itemCard.add(ItemResult.fromMap(products));
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
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _description() => Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Text(
                translate("item.drotaverine"),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_catalog,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 3,
                left: 16,
                right: 16,
              ),
              child: Text(
                "Действующее вещество",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_transparent_text,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 21,
                left: 16,
                right: 16,
              ),
              child: Text(
                translate("item.kapsule"),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_catalog,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 3,
                left: 16,
                right: 16,
              ),
              child: Text(
                "Форма выпуска",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_transparent_text,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 21,
                left: 16,
                right: 16,
              ),
              child: Text(
                "Франция",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_catalog,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 3,
                left: 16,
                right: 16,
              ),
              child: Text(
                "Страна происхождения",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_transparent_text,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 35,
                left: 12,
                right: 12,
              ),
              child: Text(
                translate("item.analog"),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black_catalog,
                ),
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
                  return Container(
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
                              fontWeight: FontWeight.w600,
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
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  width: 120,
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.blue,
                                            borderRadius: BorderRadius.circular(
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
                                          if (items[index].cardCount > 1) {
                                            setState(() {
                                              items[index].cardCount =
                                                  items[index].cardCount - 1;
//                                              dataBase
//                                                  .updateProduct(items[index]);
                                            });
                                          } else if (items[index].cardCount ==
                                              1) {
                                            setState(() {
                                              items[index].cardCount =
                                                  items[index].cardCount - 1;
                                              if (items[index].favourite) {
//                                                dataBase.updateProduct(
//                                                    items[index]);
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
                                            items[index].cardCount.toString() +
                                                " " +
                                                translate("item.sht"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppTheme.blue,
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            items[index].cardCount =
                                                items[index].cardCount + 1;
//                                            dataBase
//                                                .updateProduct(items[index]);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.blue,
                                            borderRadius: BorderRadius.circular(
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
//                                      if (items[index].favourite) {
//                                        dataBase.updateProduct(items[index]);
//                                      } else {
//                                        dataBase.saveProducts(items[index]);
//                                      }
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
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppTheme.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRoboto,
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
                  );
                },
              ),
            ),
          ],
        ),
      );

  _instruction() => Container(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            EntryItem(
              Entry(
                'Section A0',
                <Entry>[
                  Entry(
                      'Препарат следует хранить в недоступном для детей месте при температуре не выше 25 C.'),
                ],
              ),
            ),
            EntryItem(
              Entry(
                'Section A0',
                <Entry>[
                  Entry(
                      'Препарат следует хранить в недоступном для детей месте при температуре не выше 25 C.'),
                ],
              ),
            ),
            EntryItem(
              Entry(
                'Section A0',
                <Entry>[
                  Entry(
                      'Препарат следует хранить в недоступном для детей месте при температуре не выше 25 C.'),
                ],
              ),
            ),
            EntryItem(
              Entry(
                'Section A0',
                <Entry>[
                  Entry(
                      'Препарат следует хранить в недоступном для детей месте при температуре не выше 25 C.'),
                ],
              ),
            ),
            EntryItem(
              Entry(
                'Section A0',
                <Entry>[
                  Entry(
                      'Препарат следует хранить в недоступном для детей месте при температуре не выше 25 C.'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 35,
                left: 12,
                right: 12,
              ),
              child: Text(
                translate("item.analog"),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppTheme.fontRoboto,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black_catalog,
                ),
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
                  return Container(
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
                              fontWeight: FontWeight.w600,
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
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  width: 120,
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.blue,
                                            borderRadius: BorderRadius.circular(
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
                                          if (items[index].cardCount > 1) {
                                            setState(() {
                                              items[index].cardCount =
                                                  items[index].cardCount - 1;
//                                              dataBase
//                                                  .updateProduct(items[index]);
                                            });
                                          } else if (items[index].cardCount ==
                                              1) {
                                            setState(() {
                                              items[index].cardCount =
                                                  items[index].cardCount - 1;
                                              if (items[index].favourite) {
//                                                dataBase.updateProduct(
//                                                    items[index]);
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
                                            items[index].cardCount.toString() +
                                                " " +
                                                translate("item.sht"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppTheme.blue,
                                              fontFamily: AppTheme.fontRoboto,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            items[index].cardCount =
                                                items[index].cardCount + 1;
//                                            dataBase
//                                                .updateProduct(items[index]);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.blue,
                                            borderRadius: BorderRadius.circular(
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
//                                      if (items[index].favourite) {
//                                        dataBase.updateProduct(items[index]);
//                                      } else {
//                                        dataBase.saveProducts(items[index]);
//                                      }
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
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppTheme.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRoboto,
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
                  );
                },
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Container(
              height: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.item_navigation,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: Stack(
        children: [
          FutureBuilder<ItemsAllModel>(
            future: API.getItemsAllInfo(1),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return SizedBox(
                  child: Text(
                    "нет интернета",
                    textAlign: TextAlign.center,
                  ),
                );
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 14),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 52),
                                height: 240,
                                width: 240,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              height: 15,
                              width: 250,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              height: 22,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              height: 22,
                              width: 125,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40.0),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.only(left: 16, right: 16),
                              height: 40,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                case ConnectionState.done:
                  data = snapshot.data;
                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 14),
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverToBoxAdapter(child: _buildCarousel()),
                          SliverToBoxAdapter(
                            child: Container(
                              height: 40,
                              width: 350,
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: AppTheme.tab_transparent,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: TabBar(
                                controller: _tabController,
                                labelColor: AppTheme.blue_app_color,
                                unselectedLabelColor: AppTheme.search_empty,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontSize: 13,
                                  color: AppTheme.blue_app_color,
                                ),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: AppTheme.white,
                                ),
                                tabs: myTabs,
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _description(),
                            _instruction(),
                          ],
                        ),
                      ),
                    ),
                  );
                default:
              }
            },
          ),
        ],
      ),
    );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: 12,
          right: 12,
        ),
        child: Text(
          root.title,
          style: TextStyle(
            color: AppTheme.black_transparent_text,
            fontWeight: FontWeight.normal,
            fontFamily: AppTheme.fontRoboto,
            fontSize: 13,
          ),
        ),
      );
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Container(
        margin: EdgeInsets.only(
          top: 16,
          bottom: 16,
        ),
        child: Text(
          root.title,
          style: TextStyle(
            color: AppTheme.black_text,
            fontWeight: FontWeight.w600,
            fontFamily: AppTheme.fontRoboto,
            fontSize: 13,
          ),
        ),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
