import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
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
        height: widget.item.sale ? 172 : 160,
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
                        imageUrl: widget.item.image,
                        placeholder: (context, url) => Icon(Icons.camera_alt),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 17),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            widget.item.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontRoboto,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                          ),
                          Row(
                            children: <Widget>[],
                          ),
                          SizedBox(height: 3),
                          Text(
                            widget.item.title,
                            style: TextStyle(
                              color: AppTheme.black_transparent_text,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRoboto,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.item.sale
                                    ? StrikeThroughWidget(
                                        child: Text(
                                          priceFormat
                                                  .format(widget.item.price) +
                                              translate("sum"),
                                          style: TextStyle(
                                            color:
                                                AppTheme.black_transparent_text,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontRoboto,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  priceFormat.format(widget.item.price) +
                                      translate("sum"),
                                  style: TextStyle(
                                    color: widget.item.sale
                                        ? AppTheme.red_text_sale
                                        : AppTheme.black_text,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontRoboto,
                                  ),
                                ),
                                SizedBox(height: 7,),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15.5),
                            height: 30,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  child: widget.item.cardCount > 0
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
                                              Container(
                                                height: 30,
                                                width: 60,
                                                child: Center(
                                                  child: Text(
                                                    widget.item.cardCount
                                                            .toString() +
                                                        " " +
                                                        translate("item.sht"),
                                                    textAlign: TextAlign.center,
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
                                                    widget.item.cardCount =
                                                        widget.item.cardCount +
                                                            1;
                                                    dataBase.updateProduct(
                                                        widget.item);
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
                                          child: Container(
                                            height: 30,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              color: AppTheme.blue,
                                            ),
                                            child: Center(
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
                                  child: Container(),
                                ),
                                GestureDetector(
                                  child: widget.item.favourite
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
                                      if (widget.item.favourite) {
                                        widget.item.favourite = false;
                                        if (widget.item.cardCount == 0) {
                                          dataBase
                                              .deleteProducts(widget.item.id);
                                        } else {
                                          dataBase.updateProduct(widget.item);
                                        }
                                      } else {
                                        widget.item.favourite = true;
                                        if (widget.item.cardCount == 0) {
                                          dataBase.saveProducts(widget.item);
                                        } else {
                                          dataBase.updateProduct(widget.item);
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
              color: AppTheme.black_linear,
            )
          ],
        ),
      ),
    );
  }
}

class StrikeThroughWidget extends StatelessWidget {
  final Widget _child;

  StrikeThroughWidget({Key key, @required Widget child})
      : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
//      padding: EdgeInsets.symmetric(horizontal: 8),
      // this line is optional to make strikethrough effect outside a text
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/red.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
