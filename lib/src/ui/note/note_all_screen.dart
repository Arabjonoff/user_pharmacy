import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_list.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/note/note_all_list_screen.dart';
import 'package:pharmacy/src/ui/note/note_one_screen.dart';

class NoteAllScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteAllScreenScreenState();
  }
}

class _NoteAllScreenScreenState extends State<NoteAllScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Size size;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1.0,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
          leading: GestureDetector(
            child: Container(
              height: 56,
              width: 56,
              color: AppTheme.arrow_examp_back,
              padding: EdgeInsets.all(13),
              child: SvgPicture.asset("assets/images/arrow_back.svg"),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                translate("note.title"),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppTheme.black_text,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontCommons,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            GestureDetector(
              child: Container(
                height: 48,
                width: 48,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppTheme.blue_app_color,
                    size: 36,
                  ),
                ),
              ),
              onTap: () {},
            )
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: 40,
              width: 350,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.tab_transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.blue_app_color,
                unselectedLabelColor: AppTheme.search_empty,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontRoboto,
                  fontSize: 13,
                  color: AppTheme.blue_app_color,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                tabs: <Widget>[
                  new Tab(
                    text: translate("note.list"),
                  ),
                  new Tab(
                    text: translate("note.one"),
                  ),
                ],
              ),
            ),
            Container(
              height: size.height - 156,
              child: TabBarView(
                controller: _tabController,
                children: [
                  NoteAllListScreen(),
                  NoteOneScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
