import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFF818C99);
  static const Color arrow_catalog = Color(0xFFB8C1CC);
  static const Color arrow_back = Color(0xFFF0F1F3);
  static const Color search_empty = Color(0xFF818C99);
  static const Color item_navigation = Color(0xFFA6A6A6);

  static const String fontRubik = 'Rubik';

  static const Color auth_border = Color(0xFFD5D6D8);
  static const Color auth_login = Color(0xFFF2F3F5);

  ///new app
  static const Color text_dark = Color(0xFF172B4D);
  static const Color gray = Color(0xFFC1C7D0);
  static const Color textGray = Color(0xFF6E80B0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF3F8AE0);
  static const Color background = Color(0xFFF4F5F7);
  static const Color red = Color(0xFFFF3347);
  static const Color yellow = Color(0xFFFFFAE5);
  static const Color green = Color(0xFF77B06E);

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontRubik,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: text_dark,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontRubik,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: text_dark,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontRubik,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: text_dark,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontRubik,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: text_dark,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontRubik,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: text_dark,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontRubik,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: text_dark,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontRubik,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: textGray, // was lightText
  );
}
