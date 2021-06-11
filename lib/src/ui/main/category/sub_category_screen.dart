import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';

import '../../../app_theme.dart';

class SubCategoryScreen extends StatefulWidget {
  final String name;
  final List<Childs> list;

  SubCategoryScreen(this.name, this.list);

  @override
  State<StatefulWidget> createState() {
    return _SubCategoryScreenState();
  }
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
            padding: EdgeInsets.all(13),
            child: SvgPicture.asset("assets/icons/arrow_left_blue.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.2,
                color: AppTheme.text_dark,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.list.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (widget.list[index].childs.length > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategoryScreen(
                      widget.list[index].name,
                      widget.list[index].childs,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemListScreen(
                      name: widget.list[index].name,
                      type: 2,
                      id: widget.list[index].id.toString(),
                    ),
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                top: index == 0 ? 16 : 12,
                bottom: index == widget.list.length - 1 ? 16 : 12,
              ),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(index == 0 ? 24 : 0),
                  topLeft: Radius.circular(index == 0 ? 24 : 0),
                  bottomLeft: Radius.circular(
                    index == widget.list.length - 1 ? 24 : 0,
                  ),
                  bottomRight: Radius.circular(
                    index == widget.list.length - 1 ? 24 : 0,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.list[index].name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.black_catalog,
                        fontFamily: AppTheme.fontRubik,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/arrow_right_grey.svg",
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
