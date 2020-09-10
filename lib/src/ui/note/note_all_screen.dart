import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/database/database_helper_note.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_list.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/note/add_notf_screen.dart';
import 'package:pharmacy/src/ui/note/note_all_list_screen.dart';
import 'package:pharmacy/src/ui/note/note_one_screen.dart';
import 'package:pharmacy/src/ui/note/notification_screen.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

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
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NotificationScreen(receivedNotification.id),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen(-1)),
      );
    });

  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    DatabaseHelperNote dataBase = new DatabaseHelperNote();

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
              // Navigator.pop(context);
              dataBase.clear();
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
                color: AppTheme.arrow_examp_back,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppTheme.blue_app_color,
                    size: 36,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: AddNotfScreen(),
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
