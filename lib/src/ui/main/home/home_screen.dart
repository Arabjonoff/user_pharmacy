import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_fav.dart';
import 'package:pharmacy/src/model/api/blog_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/eventBus/check_version.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/dialog/top_dialog.dart';
import 'package:pharmacy/src/ui/item_list/blog_list_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_theme.dart';

final priceFormat = new NumberFormat("#,##0", "ru");
String fcToken = "";

class HomeScreen extends StatefulWidget {
  final Function onStore;
  final Function onRegion;
  final Function onHistory;
  final Function onLogin;
  final Function(String title, String uri) onUnversal;

  HomeScreen({
    this.onStore,
    this.onRegion,
    this.onHistory,
    this.onLogin,
    this.onUnversal,
  });

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DatabaseHelper dataBase = new DatabaseHelper();
  DatabaseHelperFav dataBaseFav = new DatabaseHelperFav();
  String city = "";
  int _stars = 0;
  var loading = false;
  var isAnimated = true;
  int lastPosition = 0;
  var duration = Duration(milliseconds: 270);
  TextEditingController commentController = TextEditingController();
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    _sc.addListener(() {
      if (_sc.offset ~/ 10 > 0) {
        if (_sc.offset ~/ 10 < lastPosition) {
          lastPosition = _sc.offset ~/ 10;
          if (isAnimated == false) {
            setState(() {
              isAnimated = true;
            });
          }
        } else if (_sc.offset ~/ 10 != lastPosition) {
          lastPosition = _sc.offset ~/ 10;
          if (isAnimated) {
            setState(() {
              isAnimated = false;
            });
          }
        }
      }
    });
    _setLanguage();
    _initPackageInfo();
    _registerBus();
    _notificationFirebase();
    _getNoReview();
    blocHome.fetchBanner();
    blocHome.fetchBlog(1);
    blocHome.fetchRecently();
    blocHome.fetchCategory();
    blocHome.fetchBestItem();
    blocHome.fetchSlimmingItem();
    blocHome.fetchCashBack();
    blocHome.fetchCityName();
    super.initState();
  }

  @override
  void dispose() {
    RxBus.destroy();
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
        ),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: duration,
            height: isAnimated ? 132 : 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/search.svg"),
                        SizedBox(width: 12),
                        Text(
                          translate("home.search"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            height: 1.2,
                            color: AppTheme.gray,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      isAnimated
                          ? GestureDetector(
                              onTap: () {
                                TopDialog.createRegion(context);
                              },
                              child: Container(
                                color: AppTheme.white,
                                child: Row(
                                  children: [
                                    SizedBox(width: 16),
                                    SvgPicture.asset(
                                        "assets/icons/location_grey.svg"),
                                    SizedBox(width: 12),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate("home.location"),
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRubik,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            height: 1.2,
                                            color: AppTheme.blue,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            StreamBuilder(
                                              stream: blocHome.allCityName,
                                              builder: (context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    snapshot.data,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontRubik,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      height: 1.2,
                                                      color: AppTheme.text_dark,
                                                    ),
                                                  );
                                                }
                                                return Text(
                                                  "Ташкент",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontRubik,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14,
                                                    height: 1.2,
                                                    color: AppTheme.text_dark,
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(width: 4),
                                            SvgPicture.asset(
                                                "assets/icons/arrow_bottom_blue.svg"),
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(bottom: isAnimated ? 8 : 0),
                  width: 64,
                  height: isAnimated ? 4 : 0,
                  color: AppTheme.text_dark.withOpacity(0.05),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _sc,
              physics: BouncingScrollPhysics(),
              cacheExtent: 99999999,
              padding: EdgeInsets.only(
                top: 16,
                bottom: 24,
                left: 0,
                right: 0,
              ),
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.width - 32) / 2.0,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: blocHome.banner,
                    builder: (context, AsyncSnapshot<BannerModel> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.results.length > 0) {
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: (MediaQuery.of(context).size.width - 32) /
                                  2.0,
                              viewportFraction: 1.0,
                              aspectRatio: 2.0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                              enlargeCenterPage: false,
                            ),
                            items: snapshot.data.results.map(
                              (url) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (url.drugs.length > 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemListScreen(
                                            name: url.name,
                                            type: 5,
                                            id: url.drugs
                                                .toString()
                                                .replaceAll('[', '')
                                                .replaceAll(']', '')
                                                .replaceAll(' ', ''),
                                          ),
                                        ),
                                      );
                                    } else if (url.drug != null) {
                                      RxBus.post(BottomViewModel(url.drug),
                                          tag: "EVENT_BOTTOM_ITEM_ALL");
                                    } else if (url.category != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemListScreen(
                                            name: url.name,
                                            type: 2,
                                            id: url.category.toString(),
                                          ),
                                        ),
                                      );
                                    } else if (url.url.length > 0) {
                                      if (await canLaunch(url.url)) {
                                        await launch(
                                          url.url,
                                        );
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Container(
                                        color: AppTheme.white,
                                        child: CachedNetworkImage(
                                          imageUrl: url.image,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: AppTheme.background,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: AppTheme.background,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          );
                        } else {
                          return Container();
                        }
                      }
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          height:
                              (MediaQuery.of(context).size.width - 32) / 2.0,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            right: 16,
                            left: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                StreamBuilder(
                  stream: blocHome.recentlyItem,
                  builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.results.length > 0) {
                        return Container(
                          height: 225,
                          margin: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  bottom: 16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      translate("home.recently"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.1,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemListScreen(
                                              name: translate("home.recently"),
                                              type: 1,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        translate("home.all"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 1.1,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                          "assets/icons/arrow_right_blue.svg"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    bottom: 0,
                                    right: 16,
                                    left: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 148,
                                        height: 189,
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        margin: EdgeInsets.only(
                                          right: 16,
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data
                                                          .results[index]
                                                          .imageThumbnail,
                                                      placeholder:
                                                          (context, url) =>
                                                              SvgPicture.asset(
                                                        "assets/images/place_holder.svg",
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          SvgPicture.asset(
                                                        "assets/images/place_holder.svg",
                                                      ),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        snapshot
                                                                .data
                                                                .results[index]
                                                                .favourite =
                                                            !snapshot
                                                                .data
                                                                .results[index]
                                                                .favourite;
                                                        if (snapshot
                                                            .data
                                                            .results[index]
                                                            .favourite) {
                                                          dataBaseFav
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .results[
                                                                      index])
                                                              .then((value) {
                                                            blocHome
                                                                .fetchRecentlyUpdate();
                                                          });
                                                        } else {
                                                          dataBaseFav
                                                              .deleteProducts(
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .id)
                                                              .then((value) {
                                                            blocHome
                                                                .fetchRecentlyUpdate();
                                                          });
                                                        }
                                                      },
                                                      child: snapshot
                                                              .data
                                                              .results[index]
                                                              .favourite
                                                          ? SvgPicture.asset(
                                                              "assets/icons/fav_select.svg")
                                                          : SvgPicture.asset(
                                                              "assets/icons/fav_unselect.svg"),
                                                    ),
                                                    top: 0,
                                                    right: 0,
                                                  ),
                                                  Positioned(
                                                    child: snapshot
                                                                .data
                                                                .results[index]
                                                                .price >=
                                                            snapshot
                                                                .data
                                                                .results[index]
                                                                .basePrice
                                                        ? Container()
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppTheme
                                                                  .red
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Text(
                                                              "-" +
                                                                  (((snapshot.data.results[index].basePrice - snapshot.data.results[index].price) *
                                                                              100) ~/
                                                                          snapshot
                                                                              .data
                                                                              .results[index]
                                                                              .basePrice)
                                                                      .toString() +
                                                                  "%",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontRubik,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                height: 1.2,
                                                                color: AppTheme
                                                                    .red,
                                                              ),
                                                            ),
                                                          ),
                                                    top: 0,
                                                    left: 0,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              snapshot.data.results[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                height: 1.5,
                                                color: AppTheme.text_dark,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              snapshot.data.results[index]
                                                  .manufacturer.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10,
                                                height: 1.2,
                                                color: AppTheme.textGray,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            snapshot.data.results[index]
                                                    .isComing
                                                ? Container(
                                                    height: 29,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: translate(
                                                                  "fast"),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontRubik,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                height: 1.2,
                                                                color: AppTheme
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : snapshot.data.results[index]
                                                            .cardCount >
                                                        0
                                                    ? Container(
                                                        height: 29,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme.blue
                                                              .withOpacity(
                                                                  0.12),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount >
                                                                    1) {
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .cardCount = snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount -
                                                                      1;
                                                                  dataBase
                                                                      .updateProduct(snapshot
                                                                              .data
                                                                              .results[
                                                                          index])
                                                                      .then(
                                                                          (value) {
                                                                    blocHome
                                                                        .fetchRecentlyUpdate();
                                                                  });
                                                                } else if (snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount ==
                                                                    1) {
                                                                  dataBase
                                                                      .deleteProducts(snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .id)
                                                                      .then(
                                                                          (value) {
                                                                    blocHome
                                                                        .fetchRecentlyUpdate();
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: 29,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/remove.svg",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount
                                                                          .toString() +
                                                                      " " +
                                                                      translate(
                                                                          "sht"),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12,
                                                                    height: 1.2,
                                                                    color: AppTheme
                                                                        .text_dark,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount <
                                                                    snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .maxCount)
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .cardCount = snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount +
                                                                      1;
                                                                dataBase
                                                                    .updateProduct(snapshot
                                                                            .data
                                                                            .results[
                                                                        index])
                                                                    .then(
                                                                        (value) {
                                                                  blocHome
                                                                      .fetchRecentlyUpdate();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: 29,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/add.svg",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          snapshot
                                                              .data
                                                              .results[index]
                                                              .cardCount = 1;
                                                          dataBase
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .results[
                                                                      index])
                                                              .then((value) {
                                                            blocHome
                                                                .fetchRecentlyUpdate();
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 29,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppTheme.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Center(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: priceFormat.format(snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .price),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: translate(
                                                                        "sum"),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemCount: snapshot.data.results.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return Container(
                      height: 225,
                      margin: EdgeInsets.only(top: 24),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 16,
                                left: 16,
                                bottom: 16,
                              ),
                              height: 19,
                              width: 125,
                              color: AppTheme.white,
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  right: 16,
                                  left: 16,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: Container(
                                    width: 148,
                                    height: 189,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: EdgeInsets.only(
                                      right: 16,
                                    ),
                                  ),
                                ),
                                itemCount: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: blocHome.categoryItem,
                  builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.results.length > 0) {
                        return Container(
                          margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  translate("home.popular_category"),
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    height: 1.2,
                                    color: AppTheme.text_dark,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                              ),
                              Container(
                                height: 1,
                                margin: EdgeInsets.only(top: 16, bottom: 16),
                                color: AppTheme.background,
                                width: double.infinity,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.only(
                                    top: 0, left: 16, right: 16, bottom: 4),
                                itemCount: snapshot.data.results.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemListScreen(
                                            name: snapshot
                                                .data.results[index].name,
                                            type: 2,
                                            id: snapshot.data.results[index].id
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 12),
                                      color: AppTheme.white,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            color: AppTheme.white,
                                            width: 42,
                                            height: 42,
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data.results[index].image,
                                              placeholder: (context, url) =>
                                                  Container(
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                ),
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              snapshot.data.results[index].name,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                height: 1.37,
                                                color: AppTheme.text_dark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  RxBus.post(BottomViewModel(1),
                                      tag: "EVENT_BOTTOM_VIEW");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  height: 44,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      translate("home.all_category"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.25,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }

                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: 225,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: blocHome.getBestItem,
                  builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.results.length > 0) {
                        return Container(
                          height: 225,
                          margin: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  bottom: 16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      translate("home.best"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.1,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemListScreen(
                                              name: translate("home.best"),
                                              type: 3,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        translate("home.all"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 1.1,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                          "assets/icons/arrow_right_blue.svg"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    bottom: 0,
                                    right: 16,
                                    left: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 148,
                                        height: 189,
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        margin: EdgeInsets.only(
                                          right: 16,
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data
                                                          .results[index]
                                                          .imageThumbnail,
                                                      placeholder:
                                                          (context, url) =>
                                                              SvgPicture.asset(
                                                        "assets/images/place_holder.svg",
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          SvgPicture.asset(
                                                        "assets/images/place_holder.svg",
                                                      ),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        snapshot
                                                                .data
                                                                .results[index]
                                                                .favourite =
                                                            !snapshot
                                                                .data
                                                                .results[index]
                                                                .favourite;
                                                        if (snapshot
                                                            .data
                                                            .results[index]
                                                            .favourite) {
                                                          dataBaseFav
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .results[
                                                                      index])
                                                              .then((value) {
                                                            blocHome
                                                                .fetchBestUpdate();
                                                          });
                                                        } else {
                                                          dataBaseFav
                                                              .deleteProducts(
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .id)
                                                              .then((value) {
                                                            blocHome
                                                                .fetchBestUpdate();
                                                          });
                                                        }
                                                      },
                                                      child: snapshot
                                                              .data
                                                              .results[index]
                                                              .favourite
                                                          ? SvgPicture.asset(
                                                              "assets/icons/fav_select.svg")
                                                          : SvgPicture.asset(
                                                              "assets/icons/fav_unselect.svg"),
                                                    ),
                                                    top: 0,
                                                    right: 0,
                                                  ),
                                                  Positioned(
                                                    child: snapshot
                                                                .data
                                                                .results[index]
                                                                .price >=
                                                            snapshot
                                                                .data
                                                                .results[index]
                                                                .basePrice
                                                        ? Container()
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppTheme
                                                                  .red
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Text(
                                                              "-" +
                                                                  (((snapshot.data.results[index].basePrice - snapshot.data.results[index].price) *
                                                                              100) ~/
                                                                          snapshot
                                                                              .data
                                                                              .results[index]
                                                                              .basePrice)
                                                                      .toString() +
                                                                  "%",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontRubik,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                height: 1.2,
                                                                color: AppTheme
                                                                    .red,
                                                              ),
                                                            ),
                                                          ),
                                                    top: 0,
                                                    left: 0,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              snapshot.data.results[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                height: 1.5,
                                                color: AppTheme.text_dark,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              snapshot.data.results[index]
                                                  .manufacturer.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10,
                                                height: 1.2,
                                                color: AppTheme.textGray,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            snapshot.data.results[index]
                                                    .isComing
                                                ? Container(
                                                    height: 29,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: translate(
                                                                  "fast"),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontRubik,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                height: 1.2,
                                                                color: AppTheme
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : snapshot.data.results[index]
                                                            .cardCount >
                                                        0
                                                    ? Container(
                                                        height: 29,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme.blue
                                                              .withOpacity(
                                                                  0.12),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount >
                                                                    1) {
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .cardCount = snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount -
                                                                      1;
                                                                  dataBase
                                                                      .updateProduct(snapshot
                                                                              .data
                                                                              .results[
                                                                          index])
                                                                      .then(
                                                                          (value) {
                                                                    blocHome
                                                                        .fetchBestUpdate();
                                                                  });
                                                                } else if (snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount ==
                                                                    1) {
                                                                  dataBase
                                                                      .deleteProducts(snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .id)
                                                                      .then(
                                                                          (value) {
                                                                    blocHome
                                                                        .fetchBestUpdate();
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: 29,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/remove.svg",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount
                                                                          .toString() +
                                                                      " " +
                                                                      translate(
                                                                          "sht"),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12,
                                                                    height: 1.2,
                                                                    color: AppTheme
                                                                        .text_dark,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .cardCount <
                                                                    snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .maxCount)
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .cardCount = snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .cardCount +
                                                                      1;
                                                                dataBase
                                                                    .updateProduct(snapshot
                                                                            .data
                                                                            .results[
                                                                        index])
                                                                    .then(
                                                                        (value) {
                                                                  blocHome
                                                                      .fetchBestUpdate();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: 29,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/add.svg",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          snapshot
                                                              .data
                                                              .results[index]
                                                              .cardCount = 1;
                                                          dataBase
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .results[
                                                                      index])
                                                              .then((value) {
                                                            blocHome
                                                                .fetchBestUpdate();
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 29,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppTheme.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Center(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: priceFormat.format(snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .price),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: translate(
                                                                        "sum"),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemCount: snapshot.data.results.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return Container(
                      height: 225,
                      margin: EdgeInsets.only(top: 24),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 16,
                                left: 16,
                                bottom: 16,
                              ),
                              height: 19,
                              width: 125,
                              color: AppTheme.white,
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  right: 16,
                                  left: 16,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: Container(
                                    width: 148,
                                    height: 189,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: EdgeInsets.only(
                                      right: 16,
                                    ),
                                  ),
                                ),
                                itemCount: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: blocHome.slimmingItem,
                  builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.drugs.length > 0) {
                        return Container(
                          height: 225,
                          margin: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  bottom: 16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      snapshot.data.title,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.1,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemListScreen(
                                              name: snapshot.data.title,
                                              type: 4,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        translate("home.all"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 1.1,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                          "assets/icons/arrow_right_blue.svg"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    bottom: 0,
                                    right: 16,
                                    left: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 148,
                                        height: 189,
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        margin: EdgeInsets.only(
                                          right: 16,
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data
                                                          .drugs[index]
                                                          .imageThumbnail,
                                                      placeholder:
                                                          (context, url) =>
                                                              SvgPicture.asset(
                                                        "assets/images/place_holder.svg",
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          SvgPicture.asset(
                                                        "assets/images/place_holder.svg",
                                                      ),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        snapshot
                                                                .data
                                                                .drugs[index]
                                                                .favourite =
                                                            !snapshot
                                                                .data
                                                                .drugs[index]
                                                                .favourite;
                                                        if (snapshot
                                                            .data
                                                            .drugs[index]
                                                            .favourite) {
                                                          dataBaseFav
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .drugs[
                                                                      index])
                                                              .then((value) {
                                                            blocHome
                                                                .fetchSlimmingUpdate();
                                                          });
                                                        } else {
                                                          dataBaseFav
                                                              .deleteProducts(
                                                                  snapshot
                                                                      .data
                                                                      .drugs[
                                                                          index]
                                                                      .id)
                                                              .then((value) {
                                                            blocHome
                                                                .fetchSlimmingUpdate();
                                                          });
                                                        }
                                                      },
                                                      child: snapshot
                                                              .data
                                                              .drugs[index]
                                                              .favourite
                                                          ? SvgPicture.asset(
                                                              "assets/icons/fav_select.svg")
                                                          : SvgPicture.asset(
                                                              "assets/icons/fav_unselect.svg"),
                                                    ),
                                                    top: 0,
                                                    right: 0,
                                                  ),
                                                  Positioned(
                                                    child: snapshot
                                                                .data
                                                                .drugs[index]
                                                                .price >=
                                                            snapshot
                                                                .data
                                                                .drugs[index]
                                                                .basePrice
                                                        ? Container()
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppTheme
                                                                  .red
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Text(
                                                              "-" +
                                                                  (((snapshot.data.drugs[index].basePrice - snapshot.data.drugs[index].price) *
                                                                              100) ~/
                                                                          snapshot
                                                                              .data
                                                                              .drugs[index]
                                                                              .basePrice)
                                                                      .toString() +
                                                                  "%",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontRubik,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                height: 1.2,
                                                                color: AppTheme
                                                                    .red,
                                                              ),
                                                            ),
                                                          ),
                                                    top: 0,
                                                    left: 0,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              snapshot.data.drugs[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                height: 1.5,
                                                color: AppTheme.text_dark,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              snapshot.data.drugs[index]
                                                  .manufacturer.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10,
                                                height: 1.2,
                                                color: AppTheme.textGray,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            snapshot.data.drugs[index].isComing
                                                ? Container(
                                                    height: 29,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: translate(
                                                                  "fast"),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontRubik,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                height: 1.2,
                                                                color: AppTheme
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : snapshot.data.drugs[index]
                                                            .cardCount >
                                                        0
                                                    ? Container(
                                                        height: 29,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme.blue
                                                              .withOpacity(
                                                                  0.12),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .drugs[
                                                                            index]
                                                                        .cardCount >
                                                                    1) {
                                                                  snapshot
                                                                      .data
                                                                      .drugs[
                                                                          index]
                                                                      .cardCount = snapshot
                                                                          .data
                                                                          .drugs[
                                                                              index]
                                                                          .cardCount -
                                                                      1;
                                                                  dataBase
                                                                      .updateProduct(snapshot
                                                                              .data
                                                                              .drugs[
                                                                          index])
                                                                      .then(
                                                                          (value) {
                                                                    blocHome
                                                                        .fetchSlimmingUpdate();
                                                                  });
                                                                } else if (snapshot
                                                                        .data
                                                                        .drugs[
                                                                            index]
                                                                        .cardCount ==
                                                                    1) {
                                                                  dataBase
                                                                      .deleteProducts(snapshot
                                                                          .data
                                                                          .drugs[
                                                                              index]
                                                                          .id)
                                                                      .then(
                                                                          (value) {
                                                                    blocHome
                                                                        .fetchSlimmingUpdate();
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: 29,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/remove.svg",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  snapshot
                                                                          .data
                                                                          .drugs[
                                                                              index]
                                                                          .cardCount
                                                                          .toString() +
                                                                      " " +
                                                                      translate(
                                                                          "sht"),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12,
                                                                    height: 1.2,
                                                                    color: AppTheme
                                                                        .text_dark,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .drugs[
                                                                            index]
                                                                        .cardCount <
                                                                    snapshot
                                                                        .data
                                                                        .drugs[
                                                                            index]
                                                                        .maxCount)
                                                                  snapshot
                                                                      .data
                                                                      .drugs[
                                                                          index]
                                                                      .cardCount = snapshot
                                                                          .data
                                                                          .drugs[
                                                                              index]
                                                                          .cardCount +
                                                                      1;
                                                                dataBase
                                                                    .updateProduct(snapshot
                                                                            .data
                                                                            .drugs[
                                                                        index])
                                                                    .then(
                                                                        (value) {
                                                                  blocHome
                                                                      .fetchSlimmingUpdate();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 29,
                                                                width: 29,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/add.svg",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          snapshot
                                                              .data
                                                              .drugs[index]
                                                              .cardCount = 1;
                                                          dataBase
                                                              .saveProducts(
                                                                  snapshot.data
                                                                          .drugs[
                                                                      index])
                                                              .then((value) {
                                                            blocHome
                                                                .fetchSlimmingUpdate();
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 29,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppTheme.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Center(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: priceFormat.format(snapshot
                                                                        .data
                                                                        .drugs[
                                                                            index]
                                                                        .price),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: translate(
                                                                        "sum"),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppTheme
                                                                              .fontRubik,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.2,
                                                                      color: AppTheme
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemCount: snapshot.data.drugs.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return Container(
                      height: 225,
                      margin: EdgeInsets.only(top: 24),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 16,
                                left: 16,
                                bottom: 16,
                              ),
                              height: 19,
                              width: 125,
                              color: AppTheme.white,
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  right: 16,
                                  left: 16,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: Container(
                                    width: 148,
                                    height: 189,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: EdgeInsets.only(
                                      right: 16,
                                    ),
                                  ),
                                ),
                                itemCount: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: blocHome.cashBack,
                  builder: (context, AsyncSnapshot<BlogModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.results.length > 0) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(
                            top: 24,
                            left: 16,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.results[0].image,
                                  placeholder: (context, url) =>
                                      SvgPicture.asset(
                                    "assets/images/place_holder.svg",
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                    "assets/images/place_holder.svg",
                                  ),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              SizedBox(height: 16),
                              Text(
                                snapshot.data.results[0].title,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  height: 1.2,
                                  color: AppTheme.text_dark,
                                ),
                              ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      translate("home.bonus_all"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.25,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                  height: 44,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                        width: double.infinity,
                        height: 210,
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(24)),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: blocHome.blog,
                  builder: (context, AsyncSnapshot<BlogModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.results.length > 0) {
                        return Container(
                          height: 282,
                          margin: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  bottom: 16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      translate("home.articles"),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRubik,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.1,
                                        color: AppTheme.text_dark,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlogListScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        translate("home.all"),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 1.1,
                                          color: AppTheme.blue,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                          "assets/icons/arrow_right_blue.svg"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    bottom: 0,
                                    right: 16,
                                    left: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 253,
                                        height: 246,
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        margin: EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot.data
                                                      .results[index].image,
                                                  placeholder: (context, url) =>
                                                      SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                  width: 253,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                Utils.dateFormat(snapshot.data
                                                    .results[index].updatedAt),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                  color: AppTheme.textGray,
                                                ),
                                              ),
                                              margin: EdgeInsets.only(
                                                bottom: 8,
                                                top: 8,
                                                left: 16,
                                                right: 16,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                snapshot
                                                    .data.results[index].title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  height: 1.6,
                                                  color: AppTheme.text_dark,
                                                ),
                                              ),
                                              margin: EdgeInsets.only(
                                                bottom: 16,
                                                left: 16,
                                                right: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemCount: snapshot.data.results.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return Container(
                      height: 282,
                      margin: EdgeInsets.only(top: 24),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 16,
                                left: 16,
                                bottom: 16,
                              ),
                              height: 19,
                              width: 125,
                              color: AppTheme.white,
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  right: 16,
                                  left: 16,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: Container(
                                    width: 253,
                                    height: 246,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: EdgeInsets.only(
                                      right: 16,
                                    ),
                                  ),
                                ),
                                itemCount: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    var url = "tel:+998712050888";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(
                      top: 24,
                      left: 16,
                      right: 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.blue.withOpacity(0.2),
                          ),
                          child: Center(
                            child: SvgPicture.asset("assets/icons/phone.svg"),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translate("home.call_center"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                height: 1.2,
                                color: AppTheme.textGray,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "+998 (71) 205-0-888",
                              style: TextStyle(
                                fontFamily: AppTheme.fontRubik,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                height: 1.1,
                                color: AppTheme.text_dark,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 16),
                        SvgPicture.asset("assets/icons/arrow_right_grey.svg")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale(prefs.getString('language')));
      });
    } else {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale('ru'));
      });
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (info.buildNumber != null) {
      Repository().fetchCheckVersion(info.buildNumber).then(
            (value) => {
              if (value.status != null && value.status != 0)
                {
                  RxBus.post(
                      CheckVersionModel(
                          title: true,
                          packageName: info.packageName,
                          desk: value.description),
                      tag: "EVENT_ITEM_CHECK")
                }
              else if (value.winner)
                {
                  Utils.showWitter(context, value.konkursText),
                },
              if (value.isRequestForm)
                {
                  if (prefs.getString("is_request_form") == null)
                    {
                      BottomDialog.showRamadan(context),
                    },
                  prefs.setString("is_request_form", "value"),
                },
              if (value.requestForm)
                {
                  widget.onUnversal(value.requestTitle, value.requestUrl),
                }
            },
          );
    }
  }

  void _getNoReview() {
    Utils.isLogin().then((value) => {
          isLogin = value,
          if (value)
            {
              Repository().fetchGetNoReview().then(
                    (value) => {
                      if (value.data.length > 0)
                        {
                          _stars = 0,
                          commentController.text = "",
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, setState) =>
                                    Container(
                                  height: 535,
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 5, right: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: AppTheme.white,
                                    ),
                                    child: Theme(
                                      data: ThemeData(
                                        platform: TargetPlatform.android,
                                      ),
                                      child: ListView(
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 12),
                                              height: 4,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: AppTheme.bottom_dialog,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 16, left: 16, right: 16),
                                              height: 153,
                                              width: 153,
                                              child: SvgPicture.asset(
                                                  "assets/images/icon_comment.svg"),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 8, left: 16, right: 16),
                                              child: Text(
                                                translate("dialog_rat.title"),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17,
                                                  fontStyle: FontStyle.normal,
                                                  color: AppTheme.black_text,
                                                  height: 1.65,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 8, left: 32, right: 32),
                                            child: Text(
                                              translate("dialog_rat.message"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                color: AppTheme
                                                    .black_transparent_text,
                                                height: 1.47,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 8, left: 16, right: 16),
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  child: _stars >= 1
                                                      ? SvgPicture.asset(
                                                          "assets/images/star_select.svg")
                                                      : SvgPicture.asset(
                                                          "assets/images/star_unselect.svg"),
                                                  onTap: () {
                                                    setState(() {
                                                      _stars = 1;
                                                    });
                                                  },
                                                ),
                                                SizedBox(width: 16),
                                                InkWell(
                                                  child: _stars >= 2
                                                      ? SvgPicture.asset(
                                                          "assets/images/star_select.svg")
                                                      : SvgPicture.asset(
                                                          "assets/images/star_unselect.svg"),
                                                  onTap: () {
                                                    setState(() {
                                                      _stars = 2;
                                                    });
                                                  },
                                                ),
                                                SizedBox(width: 16),
                                                InkWell(
                                                  child: _stars >= 3
                                                      ? SvgPicture.asset(
                                                          "assets/images/star_select.svg")
                                                      : SvgPicture.asset(
                                                          "assets/images/star_unselect.svg"),
                                                  onTap: () {
                                                    setState(() {
                                                      _stars = 3;
                                                    });
                                                  },
                                                ),
                                                SizedBox(width: 16),
                                                InkWell(
                                                  child: _stars >= 4
                                                      ? SvgPicture.asset(
                                                          "assets/images/star_select.svg")
                                                      : SvgPicture.asset(
                                                          "assets/images/star_unselect.svg"),
                                                  onTap: () {
                                                    setState(() {
                                                      _stars = 4;
                                                    });
                                                  },
                                                ),
                                                SizedBox(width: 16),
                                                InkWell(
                                                  child: _stars >= 5
                                                      ? SvgPicture.asset(
                                                          "assets/images/star_select.svg")
                                                      : SvgPicture.asset(
                                                          "assets/images/star_unselect.svg"),
                                                  onTap: () {
                                                    setState(() {
                                                      _stars = 5;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 93,
                                            decoration: BoxDecoration(
                                                color: AppTheme.auth_login,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: AppTheme.auth_border,
                                                    width: 1)),
                                            margin: EdgeInsets.only(
                                                left: 16, right: 16, top: 24),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontRubik,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: AppTheme.black_text,
                                                fontSize: 16,
                                              ),
                                              controller: commentController,
                                              decoration: InputDecoration(
                                                hintText: translate(
                                                    "dialog_rat.comment"),
                                                hintStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily:
                                                      AppTheme.fontRubik,
                                                  color: AppTheme.grey,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.001),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.001),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (commentController
                                                          .text.length >
                                                      0 ||
                                                  _stars > 0) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                Repository()
                                                    .fetchOrderItemReview(
                                                      commentController.text,
                                                      _stars,
                                                      value.data[0],
                                                    )
                                                    .then(
                                                      (value) => {
                                                        setState(() {
                                                          loading = false;
                                                        }),
                                                        Navigator.of(context)
                                                            .pop(),
                                                      },
                                                    );
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                top: 24,
                                                left: 16,
                                                right: 16,
                                                bottom: 16,
                                              ),
                                              height: 44,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppTheme.blue_app_color,
                                              ),
                                              child: Center(
                                                child: loading
                                                    ? CircularProgressIndicator(
                                                        value: null,
                                                        strokeWidth: 3.0,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                AppTheme.white),
                                                      )
                                                    : Text(
                                                        translate(
                                                            "dialog_rat.send"),
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRubik,
                                                          color: AppTheme.white,
                                                          height: 1.29,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        },
                    },
                  ),
            }
        });
  }

  void _notificationFirebase() {}

  void _registerBus() {
    RxBus.register<BottomView>(tag: "HOME_VIEW").listen((event) {
      if (event.title) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    RxBus.register<BottomView>(tag: "HOME_VIEW_ERROR_NETWORK").listen(
      (event) {
        /// network error
      },
    );
  }

  void _notifiData(Map<String, dynamic> message) {
    int item = int.parse(message["data"]["drug"]);
    int category = int.parse(message["data"]["category"]);
    String ids = message["data"]["drugs"];

    if (item > 0) {
      RxBus.post(BottomViewModel(item), tag: "EVENT_BOTTOM_ITEM_NOTF");
    } else if (category > 0) {
      RxBus.post(BottomViewModel(category), tag: "EVENT_BOTTOM_CATEGORY_NOTF");
    } else if (ids.length > 2) {
      RxBus.post(BottomViewIdsModel(ids), tag: "EVENT_BOTTOM_IDS_NOTF");
    }
  }
}
