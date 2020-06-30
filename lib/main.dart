import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:flutter_translate/localization_provider.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_screen.dart';
import 'package:pharmacy/src/ui/main_screen.dart';
import 'package:pharmacy/src/ui/shopping/curer_address_card.dart';
import 'package:pharmacy/src/ui/shopping/order_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app_theme.dart';

String language = 'en_US';

void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'ru', 'uz']);

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

class ListViewPaginate extends StatefulWidget {
  @override
  ListViewPaginateState createState() {
    return new ListViewPaginateState();
  }
}

class ListViewPaginateState extends State<ListViewPaginate> {
  static final List<int> _listData = List<int>.generate(200, (i) => i);
  ScrollController _scrollController = ScrollController();

  int _listOffset = 0;
  int _listLimit = 10;
  bool _isLoading = false;

  List<int> _dataForListView = _listData.sublist(0, 30);

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
        _listLimit += 20;
        _listOffset = _listLimit + 1;
        Future.delayed(Duration(seconds: 1)).then((_) {
          _dataForListView
            ..addAll(
                List<int>.from(_listData.sublist(_listOffset, _listLimit)));
        });
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('ListView Paginate Example'),
      ),
      body: ListView(
          controller: _scrollController,
          padding: EdgeInsets.all(8.0),
          children: _dataForListView
              .map((data) => ListTile(title: Text("Item $data")))
              .toList()
            ..add(ListTile(
                title: _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox()))),
    );
  }
}
