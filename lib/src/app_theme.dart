import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFF818C99);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color black_catalog = Color(0xFF000000);
  static const Color arrow_catalog = Color(0xFFB8C1CC);

  static const Color arrow_back = Color(0xFFF0F1F3);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static const String fontCommons = 'TTCommons';
  static const String fontRoboto = 'Roboto';
  static const String fontSFProDisplay = 'SFProDisplay';

  static const Color blue = Color(0xFF3F8AE0);
  static const Color blue_transparent = Color.fromRGBO(63, 138, 224, 0.1);
  static const Color black_transparent = Color(0xFFEBEDF0);
  static const Color tab_transparent = Color(0xFFF2F3F5);

  static const Color search_empty = Color(0xFF818C99);
  static const Color item_navigation = Color(0xFFA6A6A6);

  static const Color black_text = Color(0xFF1C1C1E);
  static const Color red_text_sale = Color(0xFFFF3347);
  static const Color red_fav_color = Color(0xFFFF3347);
  static const Color black_transparent_text = Color(0xFF818C99);
  static const Color black_linear = Color(0x1F000000);
  static const Color black_linear_category = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color blue_app_color = Color(0xFF3F8AE0);
  static const Color menu_unselected = Color(0xFF99A2AD);
  static const Color background = Color(0xFFF2F3F8);

  static const Color bottom_dialog = Color(0xFFE5E5EA);

  static const Color auth_border = Color(0xFFD5D6D8);
  static const Color auth_login = Color(0xFFF2F3F5);

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
    fontFamily: fontCommons,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontCommons,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontCommons,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontCommons,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontCommons,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontCommons,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontCommons,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}