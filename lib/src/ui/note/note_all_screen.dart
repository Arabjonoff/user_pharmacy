import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/ui/note/add_notf_screen.dart';
import 'package:pharmacy/src/ui/note/note_all_list_screen.dart';
import 'package:pharmacy/src/ui/note/note_one_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

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
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              color: AppTheme.white,
              padding: EdgeInsets.all(19),
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
                  color: AppTheme.text_dark,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontRubik,
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
                color: AppTheme.white,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppTheme.blue,
                    size: 36,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotifyScreen(),
                  ),
                );
              },
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
                color: AppTheme.gray,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.blue,
                unselectedLabelColor: AppTheme.gray,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontRubik,
                  fontSize: 13,
                  color: AppTheme.blue,
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
