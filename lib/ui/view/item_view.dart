import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/item/item_screen.dart';

import '../../app_theme.dart';

final priceFormat = new NumberFormat("#,##0", "ru");

// ignore: must_be_immutable
class ItemView extends StatefulWidget {
  ItemModel item;

  ItemView(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemViewState();
  }
}

class _ItemViewState extends State<ItemView> {
  DatabaseHelper dataBase = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            alignment: Alignment.bottomCenter,
            child: ItemScreen(
              widget.item.id,
              widget.item.name,
              widget.item.image,
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
                        imageUrl: widget.item.image,
                        placeholder: (context, url) => Icon(Icons.camera_alt),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                          height: 25,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.item.name,
                                style: TextStyle(
                                  color: AppTheme.black_text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
//                            IconButton(
//                              icon: widget.item.favourite
//                                  ? Icon(
//                                      Icons.favorite,
//                                      size: 19,
//                                      color: AppTheme.red_app_color,
//                                    )
//                                  : Icon(
//                                      Icons.favorite_border,
//                                      size: 19,
//                                      color: AppTheme.dark_grey,
//                                    ),
//                              onPressed: () {
//                                setState(() {
//                                  if (widget.item.favourite) {
//                                    widget.item.favourite = false;
//                                    if (widget.item.cardCount == 0) {
//                                      dataBase.deleteProducts(widget.item.id);
//                                    } else {
//                                      dataBase.updateProduct(widget.item);
//                                    }
//                                  } else {
//                                    widget.item.favourite = true;
//                                    if (widget.item.cardCount == 0) {
//                                      dataBase.saveProducts(widget.item);
//                                    } else {
//                                      dataBase.updateProduct(widget.item);
//                                    }
//                                  }
//                                });
//                              },
//                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text(
                          widget.item.title,
                          style: TextStyle(
                            color: AppTheme.black_transparent_text,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 56,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  priceFormat.format(widget.item.price) +
                                      translate("sum"),
                                  style: TextStyle(
                                    color: AppTheme.black_text,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                child: widget.item.cardCount > 0
                                    ? SizedBox(
                                        height: 36,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 36,
                                              width: 36,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Color.fromRGBO(
                                                    203,
                                                    203,
                                                    203,
                                                    1.0,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (widget.item.cardCount >
                                                      1) {
                                                    setState(() {
                                                      widget.item.cardCount =
                                                          widget.item
                                                                  .cardCount -
                                                              1;
                                                      dataBase.updateProduct(
                                                          widget.item);
                                                    });
                                                  } else if (widget
                                                          .item.cardCount ==
                                                      1) {
                                                    setState(() {
                                                      widget.item.cardCount =
                                                          widget.item
                                                                  .cardCount -
                                                              1;
                                                      if (widget
                                                          .item.favourite) {
                                                        dataBase.updateProduct(
                                                            widget.item);
                                                      } else {
                                                        dataBase.deleteProducts(
                                                            widget.item.id);
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                  Radius.circular(6.0),
                                                ),
                                                border: Border.all(
                                                  color: Color.fromRGBO(
                                                    203,
                                                    203,
                                                    203,
                                                    1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  widget.item.cardCount
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 36,
                                              width: 36,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  color: Color.fromRGBO(
                                                      203, 203, 203, 1.0),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    widget.item.cardCount =
                                                        widget.item.cardCount +
                                                            1;
                                                    dataBase.updateProduct(
                                                        widget.item);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Material(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.item.cardCount = 1;
                                              if (widget.item.favourite) {
                                                dataBase
                                                    .updateProduct(widget.item);
                                              } else {
                                                dataBase
                                                    .saveProducts(widget.item);
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add_shopping_cart,
                                                color: AppTheme.white,
                                                size: 19,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                translate("item.buy"),
                                                style: TextStyle(
                                                    color: AppTheme.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        elevation: 3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                        color: AppTheme.green,
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
  }
}
