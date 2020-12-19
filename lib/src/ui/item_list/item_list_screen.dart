import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/sort_radio_btn.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/item/item_screen_not_instruction.dart';
import 'package:pharmacy/src/ui/item_list/filter_item_screen.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import 'fliter_screen.dart';

bool isOpenBest = false;
bool isOpenCategory = false;
bool isOpenSearch = false;
bool isOpenIds = false;

// ignore: must_be_immutable
class ItemListScreen extends StatefulWidget {
  String name;
  int type;
  String id;

  ItemListScreen(this.name, this.type, this.id);

  @override
  State<StatefulWidget> createState() {
    return _ItemListScreenState();
  }
}

int sort = 1;
int page = 1;
String sortFilter = "";
String internationalNameIds = "";
String manufacturerIds = "";
String priceMax = "";
String priceMin = "";
String unitIds = "";
int type;
String id;

class _ItemListScreenState extends State<ItemListScreen> {
  Size size;

  DatabaseHelper dataBase = new DatabaseHelper();
  int itemSize = 0;
  int lastPosition;

  bool isLoading = false;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    super.initState();
    internationalNameFilter = new List();
    manufacturerFilter = new List();
    dataM = new List();
    dataI = new List();
    if (widget.type == 4) {
      isOpenIds = true;
    } else {
      widget.type == 2
          ? isOpenBest = true
          : widget.type == 3 ? isOpenSearch = true : isOpenCategory = true;
    }
    _getMoreData(1);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  bool title = false;

  @override
  void dispose() {
    page = 1;
    sort = 1;
    sortFilter = "";
    internationalNameIds = "";
    manufacturerIds = "";
    priceMax = "";
    priceMin = "";
    unitIds = "";
    _sc.dispose();
    isOpenBest = false;
    isOpenCategory = false;
    isOpenSearch = false;
    isOpenIds = false;
    RxBus.destroy();
    super.dispose();
  }

  String radioItem = translate("item.sort_one");

  List<RadioGroup> fList = [
    RadioGroup(
      index: 1,
      name: translate("item.sort_one"),
    ),
    RadioGroup(
      index: 2,
      name: translate("item.sort_two"),
    ),
    RadioGroup(
      index: 3,
      name: translate("item.sort_three"),
    ),
    RadioGroup(
      index: 4,
      name: translate("item.sort_four"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    type = widget.type;
    id = widget.id;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.arrow_examp_back,
            padding: EdgeInsets.all(19),
            child: SvgPicture.asset("assets/images/arrow_back.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: AppTheme.fontCommons,
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppTheme.black_text,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: AppTheme.white,
            height: 36,
            width: size.width,
            padding: EdgeInsets.only(
              left: 12,
              right: 18,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: AppTheme.black_transparent,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        widget.type == 3
                            ? Navigator.pop(context)
                            : Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: SearchScreen("", 0),
                                ),
                              );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Icon(
                            Icons.search,
                            size: 24,
                            color: AppTheme.notWhite,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.type == 3
                                  ? widget.id
                                  : translate("search_hint"),
                              style: TextStyle(
                                color: AppTheme.notWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRoboto,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              BottomDialog.voiceAssistantDialog(context);
                              try {
                                MethodChannel methodChannel = MethodChannel(
                                    "flutter/MethodChannelDemoExam");
                                var result =
                                    await methodChannel.invokeMethod("start");
                                if (result.toString().length > 0) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: SearchScreen(result, 1),
                                    ),
                                  );
                                  await methodChannel.invokeMethod("stop");
                                }
                              } on PlatformException catch (e) {
                                print(e.toString());
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 36,
                              width: 36,
                              padding: EdgeInsets.all(7),
                              child:
                                  SvgPicture.asset("assets/images/voice.svg"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 17, right: 6),
                    child: Center(
                      child: SvgPicture.asset("assets/images/scanner.svg"),
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
          Container(
            height: 56,
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                height: 300,
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 5, right: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: AppTheme.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 12, bottom: 25),
                                        height: 4,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: AppTheme.bottom_dialog,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 150.0,
                                          child: Column(
                                            children: fList
                                                .map((data) => RadioListTile(
                                                      title: Text(
                                                        "${data.name}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                          fontSize: 15,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      activeColor: AppTheme
                                                          .blue_app_color,
                                                      groupValue: sort,
                                                      value: data.index,
                                                      onChanged: (val) {
                                                        _sc.jumpTo(1);
                                                        setState(() {
                                                          radioItem = data.name;
                                                          sort = data.index;
                                                          switch (data.index) {
                                                            case 1:
                                                              {
                                                                sortFilter =
                                                                    "name";
                                                                break;
                                                              }
                                                            case 2:
                                                              {
                                                                sortFilter =
                                                                    "-name";
                                                                break;
                                                              }
                                                            case 3:
                                                              {
                                                                sortFilter =
                                                                    "price";
                                                                break;
                                                              }
                                                            case 4:
                                                              {
                                                                sortFilter =
                                                                    "-price";
                                                                break;
                                                              }
                                                          }
                                                          isLoading = false;
                                                          page = 1;
                                                          _getMoreData(page);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 55,
                      color: AppTheme.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: SvgPicture.asset(
                              "assets/images/name_sort.svg",
                            ),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            radioItem,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 11,
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  height: 56,
                  color: AppTheme.black_linear,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      RxBus.post(
                        LoginModel(status: 1, msg: "Yes"),
                        tag: "EVENT_FILTER_SCREEN",
                      );

                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     type: PageTransitionType.bottomToTop,
                      //     child: FilterScreen(),
                      //   ),
                      // );
                    },
                    child: Container(
                      height: 55,
                      color: AppTheme.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: SvgPicture.asset(
                              "assets/images/filter.svg",
                            ),
                            width: 19,
                          ),
                          SizedBox(
                            width: 19,
                          ),
                          Text(
                            translate("item.filter"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 15,
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 1,
            color: AppTheme.black_linear,
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: widget.type == 2
                    ? blocItemsList.getBestItem
                    : widget.type == 3
                        ? blocItemsList.getItemSearch
                        : widget.type == 4
                            ? blocItemsList.allIds
                            : blocItemsList.allItemsCategoty,
                builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.next == null
                        ? isLoading = true
                        : isLoading = false;

                    return snapshot.data.results.length > 0
                        ? ListView.builder(
                            controller: _sc,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.results.length + 1,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data.results.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Opacity(
                                      opacity: isLoading ? 0.0 : 1.0,
                                      child: Container(
                                        height: 72,
                                        child: Lottie.asset(
                                            'assets/anim/item_load_animation.json'),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        alignment: Alignment.bottomCenter,
                                        child: ItemScreenNotInstruction(
                                            snapshot.data.results[index].id),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 160,
                                    color: AppTheme.white,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 16,
                                                  left: 15,
                                                  right: 14,
                                                  bottom: 22.5,
                                                ),
                                                height: 112,
                                                width: 112,
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: CachedNetworkImage(
                                                        height: 112,
                                                        width: 112,
                                                        imageUrl: snapshot
                                                            .data
                                                            .results[index]
                                                            .imageThumbnail,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  25),
                                                          child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/images/place_holder.svg"),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  25),
                                                          child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/images/place_holder.svg"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child:
                                                          snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .price >=
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .basePrice
                                                              ? Container()
                                                              : Container(
                                                                  height: 18,
                                                                  width: 39,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppTheme
                                                                        .red_fav_color,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(9),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "-" +
                                                                          (((snapshot.data.results[index].basePrice - snapshot.data.results[index].price) * 100) ~/ snapshot.data.results[index].basePrice)
                                                                              .toString() +
                                                                          "%",
                                                                      style:
                                                                          TextStyle(
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            AppTheme.fontRoboto,
                                                                        color: AppTheme
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 17),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 18,
                                                      ),
                                                      Text(
                                                        snapshot
                                                            .data
                                                            .results[index]
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .black_text,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                          fontSize: 13,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                      Row(
                                                        children: <Widget>[],
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        snapshot
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .manufacturer ==
                                                                null
                                                            ? ""
                                                            : snapshot
                                                                .data
                                                                .results[index]
                                                                .manufacturer
                                                                .name,
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .black_transparent_text,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: AppTheme
                                                              .fontRoboto,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .price >=
                                                                  snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .basePrice
                                                              ? Text(
                                                                  priceFormat.format(snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .price) +
                                                                      translate(
                                                                          "sum"),
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .black_text,
                                                                    fontSize:
                                                                        15,
                                                                    height:
                                                                        1.33,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRoboto,
                                                                  ),
                                                                )
                                                              : Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      priceFormat.format(snapshot
                                                                              .data
                                                                              .results[index]
                                                                              .price) +
                                                                          translate("sum"),
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppTheme
                                                                            .red_fav_color,
                                                                        fontSize:
                                                                            15,
                                                                        height:
                                                                            1.33,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            AppTheme.fontRoboto,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            12),
                                                                    RichText(
                                                                      text:
                                                                          new TextSpan(
                                                                        text: priceFormat.format(snapshot.data.results[index].basePrice) +
                                                                            translate("sum"),
                                                                        style:
                                                                            new TextStyle(
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                          fontSize:
                                                                              11,
                                                                          height:
                                                                              1.75,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              AppTheme.black_transparent_text,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15.5),
                                                        height: 30,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              height: 30,
                                                              child: snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .isComing
                                                                  ? Container(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          translate(
                                                                              "fast"),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppTheme.black_text,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontFamily:
                                                                                AppTheme.fontRoboto,
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                          maxLines:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : snapshot.data.results[index]
                                                                              .cardCount >
                                                                          0
                                                                      ? Container(
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppTheme.blue_transparent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          width:
                                                                              120,
                                                                          child:
                                                                              Row(
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
                                                                                  if (snapshot.data.results[index].cardCount > 1) {
                                                                                    setState(() {
                                                                                      snapshot.data.results[index].cardCount = snapshot.data.results[index].cardCount - 1;
                                                                                      dataBase.updateProduct(snapshot.data.results[index]);
                                                                                    });
                                                                                  } else if (snapshot.data.results[index].cardCount == 1) {
                                                                                    setState(() {
                                                                                      snapshot.data.results[index].cardCount = snapshot.data.results[index].cardCount - 1;
                                                                                      if (snapshot.data.results[index].favourite) {
                                                                                        dataBase.updateProduct(snapshot.data.results[index]);
                                                                                      } else {
                                                                                        dataBase.deleteProducts(snapshot.data.results[index].id);
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
                                                                                    snapshot.data.results[index].cardCount.toString() + " " + translate("item.sht"),
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
                                                                                  if (snapshot.data.results[index].cardCount < snapshot.data.results[index].maxCount)
                                                                                    setState(() {
                                                                                      snapshot.data.results[index].cardCount = snapshot.data.results[index].cardCount + 1;
                                                                                      dataBase.updateProduct(snapshot.data.results[index]);
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
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              snapshot.data.results[index].cardCount = 1;
                                                                              if (snapshot.data.results[index].favourite) {
                                                                                dataBase.updateProduct(snapshot.data.results[index]);
                                                                              } else {
                                                                                dataBase.saveProducts(snapshot.data.results[index]);
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                120,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                              color: AppTheme.blue,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                translate("item.card"),
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: AppTheme.fontRoboto,
                                                                                  color: AppTheme.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  Container(),
                                                            ),
                                                            GestureDetector(
                                                              child: snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .favourite
                                                                  ? Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      size: 24,
                                                                      color: AppTheme
                                                                          .red_fav_color,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      size: 24,
                                                                      color: AppTheme
                                                                          .arrow_catalog,
                                                                    ),
                                                              onTap: () {
                                                                setState(() {
                                                                  if (snapshot
                                                                      .data
                                                                      .results[
                                                                          index]
                                                                      .favourite) {
                                                                    snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .favourite = false;
                                                                    if (snapshot
                                                                            .data
                                                                            .results[index]
                                                                            .cardCount ==
                                                                        0) {
                                                                      dataBase.deleteProducts(snapshot
                                                                          .data
                                                                          .results[
                                                                              index]
                                                                          .id);
                                                                    } else {
                                                                      dataBase.updateProduct(snapshot
                                                                          .data
                                                                          .results[index]);
                                                                    }
                                                                  } else {
                                                                    snapshot
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .favourite = true;
                                                                    if (snapshot
                                                                            .data
                                                                            .results[index]
                                                                            .cardCount ==
                                                                        0) {
                                                                      dataBase.saveProducts(snapshot
                                                                          .data
                                                                          .results[index]);
                                                                    } else {
                                                                      dataBase.updateProduct(snapshot
                                                                          .data
                                                                          .results[index]);
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          margin: EdgeInsets.only(
                                              left: 8, right: 8),
                                          color: AppTheme.black_linear,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/empty.svg",
                                height: 155,
                                width: 155,
                              ),
                              Container(
                                width: 210,
                                child: Text(
                                  translate("search.empty"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.search_empty,
                                  ),
                                ),
                              ),
                            ],
                          );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, __) => Container(
                        height: 160,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                      left: 15,
                                      right: 14,
                                      bottom: 22.5,
                                    ),
                                    height: 112,
                                    width: 112,
                                    color: AppTheme.white,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 17),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Container(
                                            height: 13,
                                            width: double.infinity,
                                            color: AppTheme.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 3),
                                            height: 11,
                                            width: 120,
                                            color: AppTheme.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 25),
                                            height: 13,
                                            width: 120,
                                            color: AppTheme.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(left: 8, right: 8),
                              color: AppTheme.black_linear,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        if (widget.type == 4) {
          blocItemsList.fetchIdsItemsList(
            widget.id,
            index,
            internationalNameIds,
            manufacturerIds,
            sortFilter,
            priceMax,
            priceMin,
            unitIds,
          );
        } else {
          widget.type == 2
              ? blocItemsList.fetchAllItemCategoryBest(
                  index,
                  internationalNameIds,
                  manufacturerIds,
                  sortFilter,
                  priceMax,
                  priceMin,
                  unitIds,
                )
              : widget.type == 3
                  ? blocItemsList.fetchAllItemSearch(
                      widget.id,
                      index,
                      internationalNameIds,
                      manufacturerIds,
                      sortFilter,
                      priceMax,
                      priceMin,
                      unitIds,
                    )
                  : blocItemsList.fetchAllItemCategory(
                      widget.id,
                      index,
                      internationalNameIds,
                      manufacturerIds,
                      sortFilter,
                      priceMax,
                      priceMin,
                      unitIds,
                    );
        }
        page++;
      });
    }
  }
}
