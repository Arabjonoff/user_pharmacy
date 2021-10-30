import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/main.dart';
import 'package:pharmacy/src/ui/item/blog_item_screen.dart';
import 'package:pharmacy/src/ui/item_list/blog_list_screen.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:pharmacy/src/blocs/card_bloc.dart';
import 'package:pharmacy/src/blocs/category_bloc.dart';
import 'package:pharmacy/src/blocs/fav_bloc.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/blocs/items_bloc.dart';
import 'package:pharmacy/src/blocs/menu_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/eventBus/card_item_change_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';
import 'package:pharmacy/src/ui/dialog/universal_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/fav/favourite_screen.dart';
import 'package:pharmacy/src/ui/main/menu/menu_screen.dart';
import 'package:pharmacy/src/ui/note/note_all_screen.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:pharmacy/src/ui/shopping_curer/curer_address_card.dart';
import 'package:pharmacy/src/ui/shopping_pickup/checkout_order_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/about_app_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/chat_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/faq_app_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/my_address_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/region_screen.dart';
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
    _notificationFirebase();
    _registerBus();
    _setLanguage();
  }

  void _notificationFirebase() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        int item = int.parse(message.data["data"]["drug"]);
        int category = int.parse(message.data["data"]["category"]);
        String ids = message.data["data"]["drugs"];
        if (item > 0) {
          BottomDialog.showItemDrug(context, item, _selectedIndex);
        } else if (category > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemListScreen(
                name: "",
                type: 2,
                id: category.toString(),
                //onReloadNetwork: widget.onReloadNetwork,
              ),
            ),
          );
        } else if (ids.length > 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemListScreen(
                name: "",
                type: 5,
                id: ids
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll(' ', ''),
                //   onReloadNetwork: widget.onReloadNetwork,
              ),
            ),
          );
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    FirebaseMessaging.instance.getToken().then((value) {
      fcToken = value;
      print(fcToken);
    });
  }

  @override
  void dispose() {
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
        BottomDialog.showItemDrug(context, event.position, _selectedIndex);
      },
    );

    RxBus.register<BottomViewModel>(tag: "EVENT_BOTTOM_CLOSE_HISTORY").listen(
      (event) {
        BottomDialog.historyClosePayment(
          context,
          _history,
        );
      },
    );

    RxBus.register<CardItemChangeModel>(tag: "EVENT_CARD_BOTTOM")
        .listen((event) => {
              if (event.cardChange)
                {
                  BottomDialog.bottomDialogOrder(
                    context,
                    _history,
                  ),
                },
            });

    RxBus.register<BottomViewIdsModel>(tag: "HOME_VIEW_ERROR_HISTORY").listen(
      (event) {
        BottomDialog.showNetworkError(
          context,
          () {
            blocItem.fetchAllInfoItem(event.position);
          },
        );
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
                      RxBus.post(BottomView(true), tag: "FAV_VIEW");
                      break;
                    }
                  case 4:
                    {
                      RxBus.post(BottomView(true), tag: "MENU_VIEW");
                      break;
                    }
                }
              } else if (index == 0) {
                blocHome.update();
                blocHome.fetchCityName();
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
            onListItem: _itemList,
            onBlogList: _itemBlogList,
            onItemBlog: _itemBlog,
            onRegion: _region,
            onSearch: _search,
          ),
          CategoryScreen(
            onListItem: _itemList,
          ),
          CardScreen(
            deleteItem: _deleteItem,
            onPickup: _pickup,
            onCurer: _curer,
            onLogin: _login,
          ),
          FavouriteScreen(),
          MenuScreen(
            onChat: _chat,
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
    List<ProductsStore> drugs = <ProductsStore>[];
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

  void _deleteItem(int itemId) {
    BottomDialog.showDeleteItem(context, itemId);
  }

  void _curer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurerAddressCardScreen(),
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

  void _itemList({String name, int type, String id}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemListScreen(
          name: name,
          type: type,
          id: id,
        ),
      ),
    );
  }

  void _itemBlog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogListScreen(),
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

  void _search() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: SearchScreen(),
      ),
    );
  }

  void _itemBlogList({
    String image,
    String title,
    String message,
    DateTime dateTime,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogItemScreen(
          image: image,
          dateTime: dateTime,
          title: title,
          message: message,
        ),
      ),
    );
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

  void _chat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(),
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
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
