import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/blocs/items_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_fav.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../../app_theme.dart';

class ItemScreenNotInstruction extends StatefulWidget {
  final int id;

  ItemScreenNotInstruction(this.id);

  @override
  State<StatefulWidget> createState() {
    return _ItemScreenNotInstructionState();
  }
}

class _ItemScreenNotInstructionState extends State<ItemScreenNotInstruction> {
  DatabaseHelper dataBase = new DatabaseHelper();
  DatabaseHelperFav dataBaseFav = new DatabaseHelperFav();

  @override
  void initState() {
    blocItem.fetchAllInfoItem(widget.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Container(
            height: 20,
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
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 14),
        child: StreamBuilder(
          stream: blocItem.allItems,
          builder: (context, AsyncSnapshot<ItemsAllModel> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: SvgPicture.asset(
                              "assets/images/logo_new_design.svg"),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          onTap: () {
                            blocCard.fetchAllCard();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 4),
                            color: AppTheme.arrow_examp_back,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 24,
                                width: 24,
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppTheme.arrow_back,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SvgPicture.asset(
                                    "assets/images/arrow_close.svg"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Center(
                          child: Container(
                            height: 240,
                            width: 240,
                            child: Center(
                              child: CachedNetworkImage(
                                height: 240,
                                width: 240,
                                imageUrl: snapshot.data.image,
                                placeholder: (context, url) => Container(
                                  padding: EdgeInsets.all(25),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/images/place_holder.svg",
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  padding: EdgeInsets.all(25),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/images/place_holder.svg",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: snapshot.data.price >= snapshot.data.basePrice
                              ? Container()
                              : Container(
                                  height: 18,
                                  width: 39,
                                  margin: EdgeInsets.only(
                                    top: 8,
                                    left: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.red_fav_color,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "-" +
                                          (((snapshot.data.basePrice -
                                                          snapshot.data.price) *
                                                      100) ~/
                                                  snapshot.data.basePrice)
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRubik,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 16,
                            right: 18,
                          ),
                          child: Row(
                            children: [
                              Text(
                                snapshot.data.manufacturer.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppTheme.fontRubik,
                                  color: AppTheme.blue_app_color,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (snapshot.data.favourite) {
                                    dataBaseFav
                                        .deleteProducts(snapshot.data.id);
                                  } else {
                                    dataBaseFav.saveProducts(
                                      ItemResult(
                                        snapshot.data.id,
                                        snapshot.data.name,
                                        snapshot.data.barcode,
                                        snapshot.data.image,
                                        snapshot.data.imageThumbnail,
                                        snapshot.data.price,
                                        Manifacture(
                                            snapshot.data.manufacturer.name),
                                        true,
                                        0,
                                      ),
                                    );
                                  }
                                  blocItem.fetchAllInfoUpdate();
                                },
                                child: Icon(
                                  snapshot.data.favourite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 24,
                                  color: snapshot.data.favourite
                                      ? AppTheme.red_fav_color
                                      : AppTheme.arrow_catalog,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, left: 16),
                          child: Text(
                            snapshot.data.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontRubik,
                              fontSize: 20,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 24, left: 16),
                          child: snapshot.data.price >= snapshot.data.basePrice
                              ? Row(
                                  children: [
                                    translate("lan") != "2"
                                        ? Text(
                                            translate("from"),
                                            style: TextStyle(
                                              color: AppTheme.black_text,
                                              fontSize: 24,
                                              height: 1.17,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRubik,
                                            ),
                                          )
                                        : Container(),
                                    Text(
                                      priceFormat.format(snapshot.data.price) +
                                          translate("sum"),
                                      style: TextStyle(
                                        color: AppTheme.black_text,
                                        fontSize: 24,
                                        height: 1.17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRubik,
                                      ),
                                    ),
                                    translate("lan") == "2"
                                        ? Text(
                                            translate("from"),
                                            style: TextStyle(
                                              color: AppTheme.black_text,
                                              fontSize: 24,
                                              height: 1.17,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRubik,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    translate("lan") != "2"
                                        ? Text(
                                            translate("from"),
                                            style: TextStyle(
                                              color: AppTheme.red_fav_color,
                                              fontSize: 24,
                                              height: 1.17,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRubik,
                                            ),
                                          )
                                        : Container(),
                                    Text(
                                      priceFormat.format(snapshot.data.price) +
                                          translate("sum"),
                                      style: TextStyle(
                                        color: AppTheme.red_fav_color,
                                        fontSize: 24,
                                        height: 1.17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRubik,
                                      ),
                                    ),
                                    translate("lan") == "2"
                                        ? Text(
                                            translate("from"),
                                            style: TextStyle(
                                              color: AppTheme.red_fav_color,
                                              fontSize: 24,
                                              height: 1.17,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRubik,
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(width: 12),
                                    RichText(
                                      text: new TextSpan(
                                        text: priceFormat.format(
                                                snapshot.data.basePrice) +
                                            translate("sum"),
                                        style: new TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          height: 1.75,
                                          fontWeight: FontWeight.w600,
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
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 26),
                          child: Text(
                            snapshot.data.internationalName.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppTheme.fontRubik,
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
                            translate("item.substance"),
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: AppTheme.fontRubik,
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
                            snapshot.data.unit.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppTheme.fontRubik,
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
                            translate("item.release"),
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: AppTheme.fontRubik,
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
                            snapshot.data.category.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppTheme.fontRubik,
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
                            translate("item.category"),
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_transparent_text,
                            ),
                          ),
                        ),
                        snapshot.data.description != null
                            ? Container(
                                margin: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 21,
                                ),
                                child: RichText(
                                  text: HTML.toTextSpan(
                                    context,
                                    " " + snapshot.data.description,
                                    defaultTextStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.black_catalog,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),

                        ///recommendations
                        snapshot.data.recommendations.length > 0
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 35, left: 12, right: 12, bottom: 16),
                                child: Text(
                                  translate("item.recomendation"),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.black_catalog,
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          height: snapshot.data.recommendations.length > 0
                              ? 250.0
                              : 0.0,
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 0,
                              bottom: 0,
                              right: 12,
                              left: 12,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.recommendations.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItemScreenNotInstruction(
                                        snapshot.data.recommendations[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  height: 250,
                                  margin: EdgeInsets.only(right: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 140,
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data
                                                  .recommendations[index]
                                                  .imageThumbnail,
                                              placeholder: (context, url) =>
                                                  Container(
                                                padding: EdgeInsets.all(
                                                  25,
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                padding: EdgeInsets.all(
                                                  25,
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/images/place_holder.svg",
                                                  ),
                                                ),
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: snapshot
                                                          .data
                                                          .recommendations[
                                                              index]
                                                          .price >=
                                                      snapshot
                                                          .data
                                                          .recommendations[
                                                              index]
                                                          .basePrice
                                                  ? Container()
                                                  : Container(
                                                      height: 18,
                                                      width: 39,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .red_fav_color,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "-" +
                                                              (((snapshot.data.recommendations[index].basePrice - snapshot.data.recommendations[index].price) *
                                                                          100) ~/
                                                                      snapshot
                                                                          .data
                                                                          .recommendations[
                                                                              index]
                                                                          .basePrice)
                                                                  .toString() +
                                                              "%",
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily: AppTheme
                                                                .fontRubik,
                                                            color:
                                                                AppTheme.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          snapshot
                                              .data.recommendations[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppTheme.black_text,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontRubik,
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        child: Text(
                                          snapshot.data.recommendations[index]
                                                      .manufacturer ==
                                                  null
                                              ? ""
                                              : snapshot
                                                  .data
                                                  .recommendations[index]
                                                  .manufacturer
                                                  .name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                AppTheme.black_transparent_text,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: AppTheme.fontRubik,
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
                                                    .data
                                                    .recommendations[index]
                                                    .isComing
                                                ? Container(
                                                    child: Center(
                                                      child: Text(
                                                        translate("fast"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .black_text,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRubik,
                                                          fontSize: 13,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  )
                                                : snapshot
                                                            .data
                                                            .recommendations[
                                                                index]
                                                            .cardCount >
                                                        0
                                                    ? Container(
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme
                                                              .blue_transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        width: 120,
                                                        child: Row(
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.0,
                                                                  ),
                                                                ),
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                height: 26,
                                                                width: 26,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: AppTheme
                                                                        .white,
                                                                    size: 19,
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .cardCount >
                                                                    1) {
                                                                  setState(() {
                                                                    snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .recommendations[index]
                                                                            .cardCount -
                                                                        1;
                                                                    dataBase.updateProduct(
                                                                        snapshot
                                                                            .data
                                                                            .recommendations[index]);
                                                                  });
                                                                } else if (snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .cardCount ==
                                                                    1) {
                                                                  setState(() {
                                                                    snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .recommendations[index]
                                                                            .cardCount -
                                                                        1;

                                                                    dataBase.deleteProducts(snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .id);
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
                                                                          .recommendations[
                                                                              index]
                                                                          .cardCount
                                                                          .toString() +
                                                                      " " +
                                                                      translate(
                                                                          "item.sht"),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color:
                                                                        AppTheme
                                                                            .blue,
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .maxCount >
                                                                    snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .cardCount)
                                                                  setState(() {
                                                                    snapshot
                                                                        .data
                                                                        .recommendations[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .recommendations[index]
                                                                            .cardCount +
                                                                        1;
                                                                    dataBase.updateProduct(
                                                                        snapshot
                                                                            .data
                                                                            .recommendations[index]);
                                                                  });
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.0,
                                                                  ),
                                                                ),
                                                                height: 26,
                                                                width: 26,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: AppTheme
                                                                        .white,
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
                                                            snapshot
                                                                .data
                                                                .recommendations[
                                                                    index]
                                                                .cardCount = 1;
                                                            dataBase.saveProducts(
                                                                snapshot.data
                                                                        .recommendations[
                                                                    index]);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 140,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            color:
                                                                AppTheme.blue,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  priceFormat.format(snapshot
                                                                          .data
                                                                          .recommendations[
                                                                              index]
                                                                          .price) +
                                                                      translate(
                                                                          "sum"),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontSize:
                                                                        12,
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
                          ),
                        ),

                        ///analog
                        snapshot.data.analog.length > 0
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 16, left: 12, right: 12, bottom: 16),
                                child: Text(
                                  translate("item.analog"),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: AppTheme.fontRubik,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.black_catalog,
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          height: snapshot.data.analog.length > 0 ? 250.0 : 0.0,
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 0,
                              bottom: 0,
                              right: 12,
                              left: 12,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.analog.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItemScreenNotInstruction(
                                              snapshot.data.analog[index].id),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  height: 250,
                                  margin: EdgeInsets.only(right: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 140,
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data
                                                  .analog[index]
                                                  .imageThumbnail,
                                              placeholder: (context, url) =>
                                                  Container(
                                                padding: EdgeInsets.all(25),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                      "assets/images/place_holder.svg"),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                padding: EdgeInsets.all(25),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                      "assets/images/place_holder.svg"),
                                                ),
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: snapshot.data.analog[index]
                                                          .price >=
                                                      snapshot
                                                          .data
                                                          .analog[index]
                                                          .basePrice
                                                  ? Container()
                                                  : Container(
                                                      height: 18,
                                                      width: 39,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .red_fav_color,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "-" +
                                                              (((snapshot.data.analog[index].basePrice - snapshot.data.analog[index].price) *
                                                                          100) ~/
                                                                      snapshot
                                                                          .data
                                                                          .analog[
                                                                              index]
                                                                          .basePrice)
                                                                  .toString() +
                                                              "%",
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily: AppTheme
                                                                .fontRubik,
                                                            color:
                                                                AppTheme.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          snapshot.data.analog[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppTheme.black_text,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontRubik,
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        child: Text(
                                          snapshot.data.analog[index]
                                                      .manufacturer ==
                                                  null
                                              ? ""
                                              : snapshot.data.analog[index]
                                                  .manufacturer.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                AppTheme.black_transparent_text,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: AppTheme.fontRubik,
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
                                                    .data.analog[index].isComing
                                                ? Container(
                                                    child: Center(
                                                      child: Text(
                                                        translate("fast"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .black_text,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: AppTheme
                                                              .fontRubik,
                                                          fontSize: 13,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  )
                                                : snapshot.data.analog[index]
                                                            .cardCount >
                                                        0
                                                    ? Container(
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme
                                                              .blue_transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        width: 120,
                                                        child: Row(
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.0,
                                                                  ),
                                                                ),
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                height: 26,
                                                                width: 26,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: AppTheme
                                                                        .white,
                                                                    size: 19,
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .cardCount >
                                                                    1) {
                                                                  setState(() {
                                                                    snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .analog[index]
                                                                            .cardCount -
                                                                        1;
                                                                    dataBase.updateProduct(
                                                                        snapshot
                                                                            .data
                                                                            .analog[index]);
                                                                  });
                                                                } else if (snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .cardCount ==
                                                                    1) {
                                                                  setState(() {
                                                                    snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .analog[index]
                                                                            .cardCount -
                                                                        1;
                                                                    dataBase.deleteProducts(snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .id);
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
                                                                          .analog[
                                                                              index]
                                                                          .cardCount
                                                                          .toString() +
                                                                      " " +
                                                                      translate(
                                                                          "item.sht"),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color:
                                                                        AppTheme
                                                                            .blue,
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .maxCount >
                                                                    snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .cardCount)
                                                                  setState(() {
                                                                    snapshot
                                                                        .data
                                                                        .analog[
                                                                            index]
                                                                        .cardCount = snapshot
                                                                            .data
                                                                            .analog[index]
                                                                            .cardCount +
                                                                        1;
                                                                    dataBase.updateProduct(
                                                                        snapshot
                                                                            .data
                                                                            .analog[index]);
                                                                  });
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      AppTheme
                                                                          .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.0,
                                                                  ),
                                                                ),
                                                                height: 26,
                                                                width: 26,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: AppTheme
                                                                        .white,
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
                                                            snapshot
                                                                .data
                                                                .analog[index]
                                                                .cardCount = 1;
                                                            dataBase.saveProducts(
                                                                snapshot.data
                                                                        .analog[
                                                                    index]);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 140,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            color:
                                                                AppTheme.blue,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  priceFormat.format(snapshot
                                                                          .data
                                                                          .analog[
                                                                              index]
                                                                          .price) +
                                                                      translate(
                                                                          "sum"),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontRubik,
                                                                    fontSize:
                                                                        12,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: AppTheme.black_linear_category,
                  ),
                  snapshot.data.isComing
                      ? Container(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Center(
                            child: Text(
                              translate("fast"),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.black_text,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontRubik,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        )
                      : snapshot.data.cardCount > 0
                          ? Container(
                              height: 44,
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                top: 12,
                                bottom: 25,
                                left: 16,
                                right: 16,
                              ),
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppTheme.blue_transparent,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
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
                                        margin: EdgeInsets.all(4.0),
                                        height: 36,
                                        width: 36,
                                        child: Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: AppTheme.white,
                                            size: 19,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (snapshot.data.cardCount > 1) {
                                          setState(() {
                                            snapshot.data.cardCount =
                                                snapshot.data.cardCount - 1;
                                            dataBase.updateProduct(
                                              ItemResult(
                                                snapshot.data.id,
                                                snapshot.data.name,
                                                snapshot.data.barcode,
                                                snapshot.data.image,
                                                snapshot.data.imageThumbnail,
                                                snapshot.data.price,
                                                Manifacture(snapshot
                                                    .data.manufacturer.name),
                                                snapshot.data.favourite,
                                                snapshot.data.cardCount,
                                              ),
                                            );
                                          });
                                        } else if (snapshot.data.cardCount ==
                                            1) {
                                          setState(() {
                                            snapshot.data.cardCount =
                                                snapshot.data.cardCount - 1;
                                            dataBase.deleteProducts(
                                              snapshot.data.id,
                                            );
                                          });
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        width: 60,
                                        child: Center(
                                          child: Text(
                                            snapshot.data.cardCount.toString() +
                                                " " +
                                                translate("item.sht"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: AppTheme.blue,
                                              fontFamily: AppTheme.fontRubik,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (snapshot.data.maxCount >
                                            snapshot.data.cardCount)
                                          setState(() {
                                            snapshot.data.cardCount =
                                                snapshot.data.cardCount + 1;
                                            dataBase.updateProduct(
                                              ItemResult(
                                                snapshot.data.id,
                                                snapshot.data.name,
                                                snapshot.data.barcode,
                                                snapshot.data.image,
                                                snapshot.data.imageThumbnail,
                                                snapshot.data.price,
                                                Manifacture(snapshot
                                                    .data.manufacturer.name),
                                                snapshot.data.favourite,
                                                snapshot.data.cardCount,
                                              ),
                                            );
                                          });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.blue,
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        height: 36,
                                        width: 36,
                                        margin: EdgeInsets.all(4.0),
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
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                setState(() {
                                  snapshot.data.cardCount = 1;
                                  dataBase.saveProducts(
                                    ItemResult(
                                      snapshot.data.id,
                                      snapshot.data.name,
                                      snapshot.data.barcode,
                                      snapshot.data.image,
                                      snapshot.data.imageThumbnail,
                                      snapshot.data.price,
                                      Manifacture(
                                          snapshot.data.manufacturer.name),
                                      snapshot.data.favourite,
                                      snapshot.data.cardCount,
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: AppTheme.blue_app_color,
                                ),
                                padding: EdgeInsets.only(left: 24, right: 24),
                                height: 44,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  top: 12,
                                  bottom: 25,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      translate("item.card_add"),
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRubik,
                                        fontSize: 17,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    translate("lan") != "2"
                                        ? Text(
                                            translate("from"),
                                            style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRubik,
                                              fontSize: 17,
                                              color: AppTheme.white,
                                            ),
                                          )
                                        : Container(),
                                    Text(
                                      priceFormat.format(snapshot.data.price) +
                                          translate("sum"),
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontRubik,
                                        fontSize: 17,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                    translate("lan") == "2"
                                        ? Text(
                                            translate("from"),
                                            style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontRubik,
                                              fontSize: 17,
                                              color: AppTheme.white,
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  topRight: Radius.circular(14.0),
                ),
              ),
              padding: EdgeInsets.only(top: 14),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        margin: EdgeInsets.only(right: 4),
                        color: AppTheme.arrow_examp_back,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.arrow_back,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                                "assets/images/arrow_close.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: double.infinity,
                        child: ListView(
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 24),
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
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
