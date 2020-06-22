import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/item/item_screen.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemSearchView extends StatefulWidget {
  ItemModel item;

  ItemSearchView(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemSearchViewState();
  }
}

class _ItemSearchViewState extends State<ItemSearchView> {
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
              widget.item
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        color: AppTheme.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 16.5,
                    ),
                    height: 48,
                    width: 48,
                    child: Center(
                      child: CachedNetworkImage(
                        height: 48,
                        width: 48,
                        imageUrl: widget.item.image,
                        placeholder: (context, url) => Icon(Icons.camera_alt),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                          SizedBox(height: 3),
                          Text(
                            widget.item.title,
                            style: TextStyle(
                              color: AppTheme.black_transparent_text,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRoboto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 20),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 19,
                        color: AppTheme.arrow_catalog,
                      ),
                    ),
                  )
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
    );
  }
}
