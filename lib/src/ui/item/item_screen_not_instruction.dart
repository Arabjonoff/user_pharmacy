// ignore: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/items_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class ItemScreenNotIstruction extends StatefulWidget {
  int id;

  ItemScreenNotIstruction(this.id);

  @override
  State<StatefulWidget> createState() {
    return _ItemScreenNotIstructionState();
  }
}

class _ItemScreenNotIstructionState extends State<ItemScreenNotIstruction> {
  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    blocItem.fetchAllCategory(widget.id.toString());
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
                  Expanded(
                    child: ListView(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppTheme.arrow_back,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.only(
                                  top: 14, bottom: 14, right: 16),
                              child: SvgPicture.asset(
                                  "assets/images/arrow_close.svg"),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 240,
                            width: 240,
                            child: Center(
                              child: CachedNetworkImage(
                                height: 240,
                                width: 240,
                                imageUrl: snapshot.data.image,
                                placeholder: (context, url) =>
                                    Icon(Icons.camera_alt),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
                                snapshot.data.manufacturer.name,
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
                                child: snapshot.data.favourite
                                    ? Icon(
                                        Icons.favorite,
                                        size: 24,
                                        color: AppTheme.red_fav_color,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 24,
                                        color: AppTheme.arrow_catalog,
                                      ),
                                onTap: () {
                                  setState(() {
                                    if (snapshot.data.favourite) {
                                      snapshot.data.favourite = false;
                                      if (snapshot.data.cardCount == 0) {
                                        dataBase
                                            .deleteProducts(snapshot.data.id);
                                      } else {
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
                                      }
                                    } else {
                                      snapshot.data.favourite = true;
                                      if (snapshot.data.cardCount == 0) {
                                        dataBase.saveProducts(
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
                                      } else {
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
                                      }
                                    }
                                  });
                                },
                              ),
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
                                priceFormat.format(snapshot.data.price),
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
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontSize: 19,
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
                            translate("item.substance"),
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
                            snapshot.data.unit.name,
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
                            translate("item.release"),
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
                            snapshot.data.category.name,
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
                            translate("item.category"),
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
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: AppTheme.black_linear_category,
                  ),
                  snapshot.data.cardCount > 0
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
                                    } else if (snapshot.data.cardCount == 1) {
                                      setState(() {
                                        snapshot.data.cardCount =
                                            snapshot.data.cardCount - 1;
                                        if (snapshot.data.favourite) {
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
                                        } else {
                                          dataBase
                                              .deleteProducts(snapshot.data.id);
                                        }
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
                                          fontFamily: AppTheme.fontRoboto,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
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
                              if (snapshot.data.favourite) {
                                dataBase.updateProduct(
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
                              } else {
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
                              }
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
                              children: [
                                Text(
                                  translate("item.card_add"),
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 17,
                                    color: AppTheme.white,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  priceFormat.format(snapshot.data.price) +
                                      translate("sum"),
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontSize: 17,
                                    color: AppTheme.white,
                                  ),
                                )
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
          },
        ),
      ),
    );
  }
}
