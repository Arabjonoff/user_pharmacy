import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ItemSearchView extends StatefulWidget {
  ItemResult item;
  int index;

  ItemSearchView(this.item, this.index);

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
        RxBus.post(BottomViewModel(widget.item.id),
            tag: "EVENT_BOTTOM_ITEM_ALL");
      },
      child: Container(
        height: 80,
        color: AppTheme.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 19,
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
                              fontFamily: AppTheme.fontRubik,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 3),
                          Text(
                            widget.item.manufacturer == null
                                ? ""
                                : widget.item.manufacturer.name,
                            style: TextStyle(
                              color: AppTheme.background,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRubik,
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
              color: AppTheme.background,
            )
          ],
        ),
      ),
    );
  }
}
