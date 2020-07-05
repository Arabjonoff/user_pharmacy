import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/eventBus/event_bus_index.dart';
import 'package:pharmacy/src/model/top_item_model.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_screen.dart';
import 'package:pharmacy/src/ui/item/item_screen_not_instruction.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_pickup_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:pharmacy/src/ui/item/item_screen.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app_theme.dart';

final priceFormat = new NumberFormat("#,##0", "ru");

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

final List<TopItemModel> topItems = TopItemModel.topTitle;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Size size;
  DatabaseHelper dataBase = new DatabaseHelper();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    blocHome.fetchAllHome(page);
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
                  child: SearchScreen("", 0),
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
                      (value) => {
                        if (value != "-1")
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SearchScreen(value, 1),
                            ),
                          )
                      },
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
            width: size.width,
            child: ListView(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 0,
                right: 15,
                left: 15,
              ),
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    EventBusIndex e = new EventBusIndex();
                    e.intexItem(44);
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          SvgPicture.asset(topItems[0].image),
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
                                    topItems[0].name,
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
                                    topItems[0].title.toUpperCase(),
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
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          SvgPicture.asset(topItems[1].image),
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
                                    topItems[1].name,
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
                                    topItems[1].title.toUpperCase(),
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
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: AddressAptekaScreen(),
                      ),
                    );
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          SvgPicture.asset(topItems[2].image),
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
                                    topItems[2].name,
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
                                    topItems[2].title.toUpperCase(),
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
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          SvgPicture.asset(topItems[3].image),
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
                                    topItems[3].name,
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
                                    topItems[3].title.toUpperCase(),
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
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 154.0,
            margin: EdgeInsets.only(top: 32),
            child: StreamBuilder(
              stream: blocHome.allSale,
              builder: (context, AsyncSnapshot<SaleModel> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      right: 12,
                      left: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
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
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.results[index].image,
                                  placeholder: (context, url) =>
                                      Icon(Icons.camera_alt),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(
                          right: 12,
                        ),
                        height: 154,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      right: 12,
                      left: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: 311,
                        height: 154,
                        margin: EdgeInsets.only(
                          right: 12,
                        ),
                      ),
                    ),
                    itemCount: 3,
                  ),
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
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontRoboto,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ItemListScreen(
                          translate("home.best"),
                          2,
                          "0",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    translate("home.show_all"),
                    style: TextStyle(
                      color: AppTheme.blue_app_color,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontRoboto,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 240.0,
            margin: EdgeInsets.only(top: 16),
            child: StreamBuilder(
              stream: blocHome.getBestItem,
              builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      right: 12,
                      left: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.downToUp,
                              alignment: Alignment.bottomCenter,
                              child: ItemScreenNotIstruction(
                                  snapshot.data.results[index].id),
                            ),
                          );
                        },
                        child: Container(
                          width: 140,
                          height: 250,
                          margin: EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data.results[index].getImageThumbnail,
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
                                  snapshot.data.results[index].name,
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
                                  snapshot.data.results[index].manufacturer ==
                                          null
                                      ? ""
                                      : snapshot.data.results[index]
                                          .manufacturer.name,
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
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 30,
                                    width: 120,
                                    margin: EdgeInsets.only(top: 11),
                                    child: snapshot
                                                .data.results[index].cardCount >
                                            0
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
                                                    if (snapshot
                                                            .data
                                                            .results[index]
                                                            .cardCount >
                                                        1) {
                                                      setState(() {
                                                        snapshot
                                                                .data
                                                                .results[index]
                                                                .cardCount =
                                                            snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount -
                                                                1;
                                                        dataBase.updateProduct(
                                                            snapshot.data
                                                                    .results[
                                                                index]);
                                                      });
                                                    } else if (snapshot
                                                            .data
                                                            .results[index]
                                                            .cardCount ==
                                                        1) {
                                                      setState(() {
                                                        snapshot
                                                                .data
                                                                .results[index]
                                                                .cardCount =
                                                            snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .cardCount -
                                                                1;
                                                        if (snapshot
                                                            .data
                                                            .results[index]
                                                            .favourite) {
                                                          dataBase.updateProduct(
                                                              snapshot.data
                                                                      .results[
                                                                  index]);
                                                        } else {
                                                          dataBase
                                                              .deleteProducts(
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .id);
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
                                                      snapshot
                                                              .data
                                                              .results[index]
                                                              .cardCount
                                                              .toString() +
                                                          " " +
                                                          translate("item.sht"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: AppTheme.blue,
                                                        fontFamily:
                                                            AppTheme.fontRoboto,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      snapshot
                                                          .data
                                                          .results[index]
                                                          .cardCount = snapshot
                                                              .data
                                                              .results[index]
                                                              .cardCount +
                                                          1;
                                                      dataBase.updateProduct(
                                                          snapshot.data
                                                              .results[index]);
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
                                                snapshot.data.results[index]
                                                    .cardCount = 1;
                                                if (snapshot.data.results[index]
                                                    .favourite) {
                                                  dataBase.updateProduct(
                                                      snapshot
                                                          .data.results[index]);
                                                } else {
                                                  dataBase.saveProducts(snapshot
                                                      .data.results[index]);
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
                                                              snapshot
                                                                  .data
                                                                  .results[
                                                                      index]
                                                                  .price) +
                                                          translate("sum"),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppTheme.white,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            right: 12,
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      right: 12,
                      left: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
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
                              color: AppTheme.white,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 15,
                              width: double.infinity,
                              color: AppTheme.white,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              color: AppTheme.white,
                              height: 14,
                              width: 80,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                          right: 12,
                        ),
                      ),
                    ),
                    itemCount: 8,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
