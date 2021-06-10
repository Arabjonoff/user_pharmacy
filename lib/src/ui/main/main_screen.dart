import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:pharmacy/src/blocs/category_bloc.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/blocs/items_list_block.dart';
import 'package:pharmacy/src/blocs/menu_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/eventBus/check_version.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_screen.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';
import 'package:pharmacy/src/ui/chat/chat_screen.dart';
import 'package:pharmacy/src/ui/dialog/universal_screen.dart';
import 'package:pharmacy/src/ui/item/item_screen_not_instruction.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/fav/favourite_screen.dart';
import 'package:pharmacy/src/ui/main/menu/menu_screen.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';
import 'package:pharmacy/src/ui/note/notification_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/curer_address_card.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_pickup_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/about_app_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/faq_app_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/language_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/my_info_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/region_screen.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../update/auto_update_screen.dart';
import 'category/category_screen.dart';
import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DatabaseHelper dataBase = new DatabaseHelper();
  bool isFirstData = true;
  var duration = Duration(milliseconds: 270);
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

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
    if (prefs.getString('language') != null) {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale(prefs.getString('language')));
      });
    } else {
      setState(() {
        var localizationDelegate = LocalizedApp.of(context).delegate;
        localizationDelegate.changeLocale(Locale('ru'));
      });
    }
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemScreenNotInstruction(
              event.position,
            ),
          ),
        );
      },
    );

    RxBus.register<BottomViewIdsModel>(tag: "EVENT_BOTTOM_VIEW_LANGUAGE")
        .listen(
      (event) => setState(
        () {
          var localizationDelegate = LocalizedApp.of(context).delegate;
          localizationDelegate.changeLocale(Locale(event.position));
        },
      ),
    );

    RxBus.register<BottomViewModel>(tag: "EVENT_BOTTOM_ITEM_NOTF").listen(
      (event) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemScreenNotInstruction(
              event.position,
            ),
          ),
        )
      },
    );

    RxBus.register<BottomViewModel>(tag: "EVENT_BOTTOM_CATEGORY_NOTF").listen(
      (event) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemListScreen(
              name: "",
              type: 2,
              id: event.position.toString(),
            ),
          ),
        )
      },
    );

    RxBus.register<BottomViewIdsModel>(tag: "EVENT_BOTTOM_IDS_NOTF").listen(
      (event) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemListScreen(
              name: "",
              type: 5,
              id: event.position
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll(' ', ''),
            ),
          ),
        ),
      },
    );

    RxBus.register<LoginModel>(tag: "EVENT_CHAT_SCREEN").listen(
      (event) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ),
        ),
      },
    );

    RxBus.register<CheckVersionModel>(tag: "EVENT_ITEM_CHECK").listen(
      (event) => {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AutoUpdateScreen(
              package: event.packageName,
              desk: event.desk,
            ),
          ),
        )
      },
    );
  }

  Future<void> _initPlatformState(BuildContext context) async {
    Map<String, dynamic> deviceData;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("deviceData") == null) {
      try {
        if (Platform.isAndroid) {
          deviceData = _readAndroidBuildData(
              await deviceInfoPlugin.androidInfo, context);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(
              await deviceInfoPlugin.iosInfo, context, await FlutterUdid.udid);
        }
        Utils.saveDeviceData(deviceData);
      } on PlatformException {
        deviceData = <String, dynamic>{
          'Error:': 'Failed to get platform version.'
        };
      }
    }

    if (!mounted) return;
  }

  Map<String, dynamic> _readAndroidBuildData(
      AndroidDeviceInfo build, BuildContext context) {
    return <String, dynamic>{
      'platform': "Android",
      'model': build.model,
      'systemVersion': build.version.release,
      'brand': build.brand,
      'isPhysicalDevice': build.isPhysicalDevice,
      'identifierForVendor': build.androidId,
      'device': build.device,
      'product': build.product,
      'version.incremental': build.version.incremental,
      'displaySize': MediaQuery.of(context).size.width.toString() +
          "x" +
          MediaQuery.of(context).size.height.toString(),
      'displayPixel': window.physicalSize.width.toString() +
          "x" +
          window.physicalSize.height.toString(),
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(
    IosDeviceInfo data,
    BuildContext context,
    String udid,
  ) {
    return <String, dynamic>{
      'platform': "IOS",
      'model': data.name,
      'systemVersion': data.systemVersion,
      'brand': data.model,
      'isPhysicalDevice': data.isPhysicalDevice,
      'identifierForVendor': udid,
      'systemName': data.systemName,
      'displaySize': MediaQuery.of(context).size.width.toString() +
          "x" +
          MediaQuery.of(context).size.height.toString(),
      'displayPixel': window.physicalSize.width.toString() +
          "x" +
          window.physicalSize.height.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstData) {
      _initPlatformState(context);
      isFirstData = false;
    }
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
              } else if (index == 3) {
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
            onStore: _store,
            onRegion: _region,
            onHistory: _history,
            onLogin: _login,
            onUnversal: _universal,
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
            onRegion: _region,
            onNoteAll: _noteAll,
            onHistory: _history,
            onLanguage: _language,
            onFaq: _faq,
            onAbout: _about,
            onMyInfo: _myInfo,
          ),
        ].elementAt(index);
      },
    };
  }

  void _pickup() {
    List<ProductsStore> drugs = new List();
    dataBase.getProdu(true).then(
          (value) => {
            for (int i = 0; i < value.length; i++)
              {
                drugs.add(
                    ProductsStore(drugId: value[i].id, qty: value[i].cardCount))
              },
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressStorePickupScreen(drugs),
              ),
            ),
          },
        );
  }

  void _store() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressAptekaScreen(),
      ),
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

  void _region() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegionScreen(),
      ),
    );
  }

  void _myInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyInfoScreen(),
      ),
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

  void _history() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryOrderScreen(),
      ),
    );
  }

  void _language() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageScreen(),
      ),
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
