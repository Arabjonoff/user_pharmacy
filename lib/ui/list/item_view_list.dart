import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper_card.dart';
import 'package:pharmacy/database/database_helper_star.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/item/item_screen.dart';

import '../../app_theme.dart';

class ItemViewList extends StatefulWidget {
  List<ItemModel> item;

  ItemViewList(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemViewListState();
  }
}

class _ItemViewListState extends State<ItemViewList> {
  List<ItemModel> itemStar = new List();
  List<ItemModel> itemCard = new List();
  DatabaseHelperCard dbCard = new DatabaseHelperCard();
  DatabaseHelperStar dbStar = new DatabaseHelperStar();

  @override
  void initState() {
    dbStar.getAllProducts().then((products) {
      setState(() {
        products.forEach((products) {
          itemStar.add(ItemModel.fromMap(products));
        });
        for (var i = 0; i < widget.item.length; i++) {
          for (var j = 0; j < itemStar.length; j++) {
            if (widget.item[i].id == itemStar[j].id) {
              widget.item[i].favourite = true;
            }
          }
        }
      });
    });
    dbCard.getAllProducts().then((products) {
      setState(() {
        products.forEach((products) {
          itemCard.add(ItemModel.fromMap(products));
        });
        for (var i = 0; i < widget.item.length; i++) {
          for (var j = 0; j < itemCard.length; j++) {
            if (widget.item[i].id == itemCard[j].id) {
              widget.item[i].cardCount = itemCard[j].cardCount;
            }
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        itemCount: widget.item.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: ItemScreen(
                    widget.item[index].id,
                    widget.item[index].name,
                  ),
                ),
              );
            },
            child: Container(
              color: AppTheme.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(11),
                          height: 120,
                          width: 120,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: widget.item[index].image,
                              placeholder: (context, url) =>
                                  Icon(Icons.camera_alt),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.item[index].name,
                                      style: TextStyle(
                                        color: AppTheme.black_text,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: widget.item[index].favourite
                                        ? Icon(
                                            Icons.favorite,
                                            size: 24,
                                            color: AppTheme.red_app_color,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            size: 24,
                                            color: AppTheme.dark_grey,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        if (widget.item[index].favourite) {
                                          dbStar.deleteProducts(
                                              widget.item[index].id);
                                          widget.item[index].favourite = false;
                                        } else {
                                          dbStar
                                              .saveProducts(widget.item[index]);
                                          widget.item[index].favourite = true;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Text(
                                widget.item[index].title,
                                style: TextStyle(
                                  color: AppTheme.black_transparent_text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 7),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.more_horiz,
                                    color: Colors.green,
                                    size: 36,
                                  ),
                                  SizedBox(width: 11),
                                  Expanded(
                                    child: Text(
                                      widget.item[index].about,
                                      style: TextStyle(
                                        color: AppTheme.black_transparent_text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 56,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.item[index].price,
                                        style: TextStyle(
                                          color: AppTheme.black_text,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      child: widget.item[index].cardCount > 0
                                          ? SizedBox(
                                              height: 40,
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.remove_circle,
                                                        color: Color.fromRGBO(
                                                            203, 203, 203, 1.0),
                                                      ),
                                                      onPressed: () {
                                                        if (widget.item[index]
                                                                .cardCount >
                                                            1) {
                                                          setState(() {
                                                            widget.item[index]
                                                                .cardCount = widget
                                                                    .item[index]
                                                                    .cardCount -
                                                                1;
                                                            dbCard
                                                                .updateProduct(
                                                                    widget.item[
                                                                        index]);
                                                          });
                                                        } else if (widget
                                                                .item[index]
                                                                .cardCount ==
                                                            1) {
                                                          setState(() {
                                                            widget.item[index]
                                                                .cardCount = widget
                                                                    .item[index]
                                                                    .cardCount -
                                                                1;
                                                            dbCard.deleteProducts(
                                                                widget
                                                                    .item[index]
                                                                    .id);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      border: Border.all(
                                                        color: Color.fromRGBO(
                                                            203, 203, 203, 1.0),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        widget.item[index]
                                                            .cardCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      color: Color.fromRGBO(
                                                          203, 203, 203, 1.0),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.item[index]
                                                            .cardCount = widget
                                                                .item[index]
                                                                .cardCount +
                                                            1;
                                                        dbCard.updateProduct(
                                                            widget.item[index]);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Material(
                                              child: MaterialButton(
                                                onPressed: () {
                                                  setState(() {
                                                    widget.item[index]
                                                        .cardCount = 1;
                                                    dbCard.saveProducts(
                                                        widget.item[index]);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.add_shopping_cart,
                                                  color: AppTheme.white,
                                                  size: 24,
                                                ),
                                              ),
                                              elevation: 5,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.0)),
                                              color: AppTheme.red_app_color,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 15, right: 15),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black12,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
