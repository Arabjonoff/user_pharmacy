import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/database/database_helper.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:pharmacy/ui/item/item_screen.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemSearchHistoryView extends StatefulWidget {
  ItemModel item;

  ItemSearchHistoryView(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemSearchHistoryViewState();
  }
}

class _ItemSearchHistoryViewState extends State<ItemSearchHistoryView> {
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
        height: 48.5,
        color: AppTheme.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 14.25,
                      top: 14.25,
                      bottom: 14.75,
                    ),
                    height: 19.5,
                    width: 19.5,
                    child: SvgPicture.asset(
                      "assets/images/clock.svg",
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.item.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.black_text,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppTheme.fontRoboto,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 20.41),
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
              margin: EdgeInsets.only(left: 8, right: 8),
              height: 1,
              color: AppTheme.black_linear,
            )
          ],
        ),
      ),
    );
  }
}
