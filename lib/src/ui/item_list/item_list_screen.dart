import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/all_item_isopen.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/model/sort_radio_btn.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/item/item_screen_not_instruction.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:pharmacy/src/ui/view/item_view.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';
import 'fliter_screen.dart';

bool isOpen = false;

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
String international_name_ids = "";
String manufacturer_ids = "";
String price_max = "";
String price_min = "";
String unit_ids = "";
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
    isOpen = true;
   // registerBus();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  bool title = false;

  void registerBus() {
    RxBus.register<AllItemIsOpen>(tag: "EVENT_ITEM_LIST")
        .listen((event) => setState(() {
              title = event.title;
            }));
    RxBus.register<AllItemIsOpen>(tag: "EVENT_ITEM_LIST_CATEGORY")
        .listen((event) => setState(() {
              if (event.title) {
                title = event.title;
              }
            }));
  }

  @override
  void dispose() {
    page = 1;
    sort = 1;
    sortFilter = "";
    international_name_ids = "";
    manufacturer_ids = "";
    price_max = "";
    price_min = "";
    unit_ids = "";
    _sc.dispose();
    isOpen = false;
   // RxBus.destroy();
    super.dispose();
  }

  String radioItem = 'По названиею (А-Я)';

  List<RadioGroup> fList = [
    RadioGroup(
      index: 1,
      name: "По названиею (А-Я)",
    ),
    RadioGroup(
      index: 2,
      name: "По названиею (Я-А)",
    ),
    RadioGroup(
      index: 3,
      name: "По цене (по возрастанию)",
    ),
    RadioGroup(
      index: 4,
      name: "По цене (по убыванию)",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    type = widget.type;
    id = widget.id;

    _getMoreData(1);

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: AppTheme.white,
            brightness: Brightness.light,
            leading: Container(
              height: 56,
              width: 48,
              color: AppTheme.arrow_examp_back,
              padding: EdgeInsets.only(top: 21, left: 9, right: 9, bottom: 9),
              child: GestureDetector(
                child: SvgPicture.asset("assets/images/arrow_back.svg"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Container(
              height: 70,
              child: Stack(
                children: [
//                  Align(
//                    alignment: Alignment.centerLeft,
//                    child: Container(
//                      height: 48,
//                      width: 48,
//                      color: AppTheme.arrow_examp_back,
//                      margin: EdgeInsets.only(top: 12),
//                      child: GestureDetector(
//                        child: Icon(
//                          Icons.arrow_back_ios,
//                          size: 24,
//                          color: AppTheme.blue_app_color,
//                        ),
//                        onTap: () {
//                          Navigator.pop(context);
//                        },
//                      ),
//                    ),
//                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
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
//                          Text(
//                            itemSize.toString() + " " + translate("item.tovar"),
//                            style: TextStyle(
//                              fontFamily: AppTheme.fontRoboto,
//                              fontWeight: FontWeight.normal,
//                              fontSize: 13,
//                              color: AppTheme.black_transparent_text,
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
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
                          IconButton(
                            icon: new Icon(
                              Icons.search,
                              size: 24,
                              color: AppTheme.notWhite,
                            ),
                          ),
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
                            onTap: () {
                              BottomDialog.createBottomVoiceAssistant(context);
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
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.downToUp,
                          child: FilterScreen(),
                        ),
                      );
                    },
                    child: Container(
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
                        : blocItemsList.allItemsCategoty,
                builder: (context, AsyncSnapshot<List<ItemResult>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length < 20) {
                      isLoading = true;
                    } else {
                      lastPosition == snapshot.data.length
                          ? isLoading = true
                          : isLoading = false;
                    }
                    lastPosition = snapshot.data.length;

                    return snapshot.data.length > 0
                        ? ListView.builder(
                            controller: _sc,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length + 1,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Opacity(
                                      opacity: isLoading ? 0.0 : 1.0,
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.downToUp,
                                        alignment: Alignment.bottomCenter,
                                        child: ItemScreenNotIstruction(
                                            snapshot.data[index].id),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height:
                                        snapshot.data[index].sale ? 172 : 160,
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
                                                child: Center(
                                                  child: CachedNetworkImage(
                                                    height: 112,
                                                    width: 112,
                                                    imageUrl: snapshot
                                                        .data[index]
                                                        .imageThumbnail,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      padding:
                                                          EdgeInsets.all(25),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/images/place_holder.svg"),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      padding:
                                                          EdgeInsets.all(25),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/images/place_holder.svg"),
                                                      ),
                                                    ),
                                                  ),
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
                                                            .data[index].name,
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
                                                        snapshot.data[index]
                                                                    .manufacturer ==
                                                                null
                                                            ? ""
                                                            : snapshot
                                                                .data[index]
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
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            snapshot.data[index]
                                                                    .sale
                                                                ? StrikeThroughWidget(
                                                                    child: Text(
                                                                      priceFormat.format(snapshot
                                                                              .data[index]
                                                                              .price) +
                                                                          translate("sum"),
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppTheme
                                                                            .black_transparent_text,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            AppTheme.fontRoboto,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                            Text(
                                                              priceFormat.format(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .price) +
                                                                  translate(
                                                                      "sum"),
                                                              style: TextStyle(
                                                                color: snapshot
                                                                        .data[
                                                                            index]
                                                                        .sale
                                                                    ? AppTheme
                                                                        .red_text_sale
                                                                    : AppTheme
                                                                        .black_text,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily: AppTheme
                                                                    .fontRoboto,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 7,
                                                            ),
                                                          ],
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
                                                                          .data[
                                                                              index]
                                                                          .cardCount >
                                                                      0
                                                                  ? Container(
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppTheme
                                                                            .blue_transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          GestureDetector(
                                                                            child:
                                                                                Container(
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
                                                                            onTap:
                                                                                () {
                                                                              if (snapshot.data[index].cardCount > 1) {
                                                                                setState(() {
                                                                                  snapshot.data[index].cardCount = snapshot.data[index].cardCount - 1;
                                                                                  dataBase.updateProduct(snapshot.data[index]);
                                                                                });
                                                                              } else if (snapshot.data[index].cardCount == 1) {
                                                                                setState(() {
                                                                                  snapshot.data[index].cardCount = snapshot.data[index].cardCount - 1;
                                                                                  if (snapshot.data[index].favourite) {
                                                                                    dataBase.updateProduct(snapshot.data[index]);
                                                                                  } else {
                                                                                    dataBase.deleteProducts(snapshot.data[index].id);
                                                                                  }
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                60,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                snapshot.data[index].cardCount.toString() + " " + translate("item.sht"),
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
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                snapshot.data[index].cardCount = snapshot.data[index].cardCount + 1;
                                                                                dataBase.updateProduct(snapshot.data[index]);
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
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
                                                                        setState(
                                                                            () {
                                                                          snapshot
                                                                              .data[index]
                                                                              .cardCount = 1;
                                                                          if (snapshot
                                                                              .data[index]
                                                                              .favourite) {
                                                                            dataBase.updateProduct(snapshot.data[index]);
                                                                          } else {
                                                                            dataBase.saveProducts(snapshot.data[index]);
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
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(10.0),
                                                                          ),
                                                                          color:
                                                                              AppTheme.blue,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            translate("item.card"),
                                                                            style:
                                                                                TextStyle(
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
                                                                      .data[
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
                                                                      .data[
                                                                          index]
                                                                      .favourite) {
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .favourite = false;
                                                                    if (snapshot
                                                                            .data[index]
                                                                            .cardCount ==
                                                                        0) {
                                                                      dataBase.deleteProducts(snapshot
                                                                          .data[
                                                                              index]
                                                                          .id);
                                                                    } else {
                                                                      dataBase.updateProduct(
                                                                          snapshot
                                                                              .data[index]);
                                                                    }
                                                                  } else {
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .favourite = true;
                                                                    if (snapshot
                                                                            .data[index]
                                                                            .cardCount ==
                                                                        0) {
                                                                      dataBase.saveProducts(
                                                                          snapshot
                                                                              .data[index]);
                                                                    } else {
                                                                      dataBase.updateProduct(
                                                                          snapshot
                                                                              .data[index]);
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
    //if (!isLoading) {
    setState(() {
      widget.type == 2
          ? blocItemsList.fetchAllItemCategoryBest(
              index,
              international_name_ids,
              manufacturer_ids,
              sortFilter,
              price_max,
              price_min,
              unit_ids,
            )
          : widget.type == 3
              ? blocItemsList.fetchAllItemSearch(
                  widget.id,
                  index,
                  international_name_ids,
                  manufacturer_ids,
                  sortFilter,
                  price_max,
                  price_min,
                  unit_ids,
                )
              : blocItemsList.fetchAllItemCategory(
                  widget.id,
                  index,
                  international_name_ids,
                  manufacturer_ids,
                  sortFilter,
                  price_max,
                  price_min,
                  unit_ids,
                );
      isLoading = false;
      page++;
    });
    // }
  }
}
