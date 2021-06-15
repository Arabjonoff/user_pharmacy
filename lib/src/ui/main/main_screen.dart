import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/blocs/category_bloc.dart';
import 'package:pharmacy/src/blocs/fav_bloc.dart';
import 'package:pharmacy/src/blocs/menu_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/dialog/universal_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/fav/favourite_screen.dart';
import 'package:pharmacy/src/ui/main/menu/menu_screen.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';
import 'package:pharmacy/src/ui/note/notification_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/curer_address_card.dart';
import 'package:pharmacy/src/ui/shopping_pickup/checkout_order_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/about_app_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/faq_app_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/my_address_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import 'category/category_screen.dart';
import 'home/home_screen.dart';

double lat = 41.0, lng = 69.0;

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DatabaseHelper dataBase = new DatabaseHelper();
  var duration = Duration(milliseconds: 270);

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    _registerBus();
    _setLanguage();
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
                    builder: (context) => NotificationScreen(
                      receivedNotification.id,
                    ),
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
        MaterialPageRoute(
          builder: (context) => NotificationScreen(-1),
        ),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    RxBus.destroy();
    super.dispose();
  }

  Future<void> _setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lan = prefs.getString('language') ?? "ru";
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(Locale(lan));
    });
  }

  void _registerBus() {
    RxBus.register<BottomViewModel>(tag: "EVENT_BOTTOM_VIEW").listen(
      (event) => setState(
        () {
          _selectedIndex = event.position;
        },
      ),
    );

    RxBus.register<BottomViewModel>(tag: "EVENT_BOTTOM_ITEM_ALL").listen(
      (event) {
        BottomDialog.showItemDrug(context, event.position);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState.maybePop();
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
            _buildOffstageNavigator(4),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            onTap: (index) {
              if (index == _selectedIndex) {
                switch (index) {
                  case 0:
                    {
                      RxBus.post(BottomView(true), tag: "HOME_VIEW");
                      break;
                    }
                  case 1:
                    {
                      RxBus.post(BottomView(true), tag: "CATEGORY_VIEW");
                      break;
                    }
                  case 2:
                    {
                      RxBus.post(BottomView(true), tag: "CARD_VIEW");
                      break;
                    }
                  case 3:
                    {
                      RxBus.post(BottomView(true), tag: "MENU_VIEW");
                      break;
                    }
                }
              } else if (index == 0) {
              } else if (index == 1) {
                blocCategory.fetchAllCategory();
              } else if (index == 2) {
                blocCard.fetchAllCard();
              } else if (index == 3) {
                blocFav.fetchAllFav();
              } else if (index == 4) {
                Utils.isLogin().then((value) => {
                      isLogin = value,
                      if (isLogin)
                        {
                          menuBack.fetchCashBack(),
                        }
                    });
              }
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: AppTheme.white,
            selectedItemColor: AppTheme.blue,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? SvgPicture.asset("assets/menu/home_selected.svg")
                    : SvgPicture.asset("assets/menu/home_unselected.svg"),
                // ignore: deprecated_member_use
                title: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  height: 4,
                  width: 4,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? AppTheme.blue : AppTheme.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? SvgPicture.asset("assets/menu/catalog_selected.svg")
                    : SvgPicture.asset("assets/menu/catalog_unselected.svg"),
                // ignore: deprecated_member_use
                title: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  height: 4,
                  width: 4,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? AppTheme.blue : AppTheme.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Center(
                      child: _selectedIndex == 2
                          ? SvgPicture.asset("assets/menu/card_selected.svg")
                          : SvgPicture.asset("assets/menu/card_unselected.svg"),
                    ),
                  ],
                ),
                // ignore: deprecated_member_use
                title: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  height: 4,
                  width: 4,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2 ? AppTheme.blue : AppTheme.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? SvgPicture.asset("assets/menu/favourite_selected.svg")
                    : SvgPicture.asset("assets/menu/favourite_unselected.svg"),
                // ignore: deprecated_member_use
                title: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  height: 4,
                  width: 4,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3 ? AppTheme.blue : AppTheme.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 4
                    ? SvgPicture.asset("assets/menu/menu_selected.svg")
                    : SvgPicture.asset("assets/menu/menu_unselected.svg"),
                // ignore: deprecated_member_use
                title: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  height: 4,
                  width: 4,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 4 ? AppTheme.blue : AppTheme.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomeScreen(
            onUnversal: _universal,
            onUpdate: _update,
            onReloadNetwork: _reloadScreen,
            onCommentService: _commentService,
          ),
          CategoryScreen(),
          CardScreen(
            onPickup: _pickup,
            onCurer: _curer,
            onLogin: _login,
          ),
          FavouriteScreen(),
          MenuScreen(
            onLogin: _login,
            onNoteAll: _noteAll,
            onHistory: _history,
            onAddress: _address,
            onLanguage: _language,
            onRate: _rate,
            onExit: _exit,
            onFaq: _faq,
            onAbout: _about,
            onMyInfo: _myInfo,
          ),
        ].elementAt(index);
      },
    };
  }

  void _pickup(CashBackData data) {
    List<ProductsStore> drugs = new List();
    dataBase.getProdu(true).then(
          (value) => {
            for (int i = 0; i < value.length; i++)
              {
                drugs.add(
                  ProductsStore(
                    drugId: value[i].id,
                    qty: value[i].cardCount,
                  ),
                )
              },
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutOrderScreen(
                  drugs: drugs,
                  cashBackData: data,
                ),
              ),
            ),
          },
        );
  }

  void _curer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurerAddressCardScreen(false),
      ),
    );
  }

  void _update(bool optional, String desc) {
    BottomDialog.showUpdate(context, desc, optional);
  }

  void _reloadScreen(Function reload) {
    BottomDialog.showNetworkError(context, reload);
  }

  void _commentService(int orderId) {
    BottomDialog.showCommentService(context: context, orderId: orderId);
  }

  void _rate() {
    BottomDialog.showCommentService(context: context);
  }

  void _exit() {
    BottomDialog.showExitProfile(context);
  }

  void _universal(String title, String uri) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversalScreen(
          title: title,
          uri: uri,
        ),
      ),
    );
  }

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<void> _myInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var number = prefs.getString("number");
    var birthday = prefs.getString("birthday").split("-")[2] +
        "/" +
        prefs.getString("birthday").split("-")[1] +
        "/" +
        prefs.getString("birthday").split("-")[0];
    var num = "+";
    for (int i = 0; i < number.length; i++) {
      if (i == 3 || i == 5 || i == 8 || i == 10) {
        num += " ";
      }
      num += number[i];
    }
    var id = prefs.getString("gender") == "man" ? 1 : 2;

    var lastName = prefs.getString("surname") ?? "";
    var firstName = prefs.getString("name") ?? "";
    var time = new DateTime(
        int.parse(prefs.getString("birthday").split("-")[0]),
        int.parse(prefs.getString("birthday").split("-")[1]),
        int.parse(prefs.getString("birthday").split("-")[2]));

    BottomDialog.showEditProfile(
      context,
      firstName: firstName,
      lastName: lastName,
      number: num,
      birthday: birthday,
      dateTime: time,
      gender: id,
      token: token,
    );
  }

  void _noteAll() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteAllScreen(),
      ),
    );
  }

  void _address() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyAddressScreen(),
      ),
    );
  }

  void _history() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryOrderScreen(),
      ),
    );
  }

  Future<void> _language() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lan = prefs.getString('language') ?? "ru";
    BottomDialog.showChangeLanguage(
      context,
      lan,
      () {
        _setLanguage();
      },
    );
  }

  void _faq() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaqAppScreen(),
      ),
    );
  }

  void _about() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutAppScreen(),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
