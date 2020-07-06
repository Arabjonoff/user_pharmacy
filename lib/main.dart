import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:flutter_translate/localization_provider.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:pharmacy/src/delete/delete_examp.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/search_model.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_list.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_screen.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';
import 'package:pharmacy/src/ui/auth/register_screen.dart';
import 'package:pharmacy/src/ui/auth/verfy_screen.dart';
import 'package:pharmacy/src/ui/item/item_screen_not_instruction.dart';
import 'package:pharmacy/src/ui/main/main_screen.dart';
import 'package:pharmacy/src/ui/shopping_pickup/address_apteka_pickup_screen.dart';
import 'package:pharmacy/src/ui/shopping_web_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/fav_apteka_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/my_info_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/region_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app_theme.dart';

String language = 'ru';

void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'ru', supportedLocales: ['en_US', 'ru', 'uz']);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('language') != null) {
    language = prefs.getString('language');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(LocalizedApp(delegate, MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    localizationDelegate.changeLocale(Locale(language));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          accentColor: Color(0xFF818C99),
          canvasColor: Colors.transparent,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home: MainScreen(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List<SearchResult> users = new List();

  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Lazy Load Large List"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            title: Text(users[index].manufacturer == null
                ? ""
                : users[index].manufacturer.name.toString()),
            subtitle: Text(users[index].name.toString()),
          );
        }
      },
      controller: _sc,
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      String url =
          Utils.BASE_URL + '/api/v1/drugs?page=$index&per_page=12&search=А';

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();

      final Map parsed = json.decode(reply);

      try {
        var res = SearchModel.fromJson(parsed);
        List<SearchResult> tList = new List();
        for (int i = 0; i < res.results.length; i++) {
          tList.add(res.results[i]);
        }
        setState(() {
          isLoading = false;
          users.addAll(tList);
          page++;
        });
      } catch (_) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
