import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:flutter_translate/localization_provider.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:pharmacy/ui/item/item_screen.dart';

import 'app_theme.dart';
import 'ui/main_screen.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'ru', 'uz']);

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
          primarySwatch: Colors.red,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home: ItemScreen("SALOM Dunyo"),
      ),
    );
  }
}
