import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:pharmacy/src/ui/auth/login_screen.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomDialog {
  static void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value) {
      changeLocale(context, value);
    });
  }

  static void onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.title')),
        message: Text(translate('language.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.ru')),
            onPressed: () => Navigator.pop(context, 'ru'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.uz')),
            onPressed: () => Navigator.pop(context, 'uz'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }

  static void createBottomSheetRating(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 450,
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void createBottomSheetHistory(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 210,
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppTheme.blue_app_color,
                            ),
                            height: 44,
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 16,
                              bottom: 30,
                              left: 16,
                              right: 16,
                            ),
                            child: Center(
                              child: Text(
                                translate("dialog.enter"),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontSize: 17,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        translate("dialog.soglas"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.black_transparent_text,
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var url = 'https://api.gopharm.uz/privacy';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Text(
                          translate("dialog.danniy"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.blue_app_color,
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void bottomDialogOrder(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 420,
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SvgPicture.asset(
                            "assets/images/image_defoult_dialog.svg"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
                      child: Text(
                        translate("dialog_rat.order_title"),
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRoboto,
                          fontSize: 17,
                          height: 1.65,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black_text,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      child: Text(
                        translate("dialog_rat.order_message"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontRoboto,
                          fontSize: 13,
                          height: 1.38,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: HistoryOrderScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 44,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            border: Border.all(
                              color: AppTheme.blue_app_color,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            translate("dialog_rat.history"),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              height: 1.29,
                              color: AppTheme.blue_app_color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 44,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            color: AppTheme.blue_app_color,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            translate("dialog_rat.close"),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              height: 1.29,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // static void createBottomVoiceAssistant(BuildContext context) async {
  //   String lastWords = "";
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           speechText.listen(
  //               onResult: (result) => {
  //                     setState(() {
  //                       if (result.finalResult) {
  //                         speechText.cancel();
  //                         setState(() {
  //                           level = 0.0;
  //                         });
  //                         Navigator.pop(context);
  //                         lastWords = "${result.recognizedWords}";
  //                         Navigator.push(
  //                           context,
  //                           PageTransition(
  //                             type: PageTransitionType.fade,
  //                             child: SearchScreen(lastWords, 1),
  //                           ),
  //                         );
  //                       }
  //                     })
  //                   },
  //               listenFor: Duration(seconds: 10),
  //               localeId: "ru_RU",
  //               onSoundLevelChange: (lev) => {
  //                     minSoundLevel = min(minSoundLevel, lev),
  //                     maxSoundLevel = max(maxSoundLevel, lev),
  //                     setState(() {
  //                       level = lev;
  //                     }),
  //                   },
  //               cancelOnError: true,
  //               partialResults: true,
  //               onDevice: true,
  //               listenMode: ListenMode.confirmation);
  //
  //           return Container(
  //             height: 340,
  //             padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 color: AppTheme.white,
  //               ),
  //               child: Column(
  //                 children: <Widget>[
  //                   Container(
  //                     margin: EdgeInsets.only(top: 12),
  //                     height: 4,
  //                     width: 60,
  //                     decoration: BoxDecoration(
  //                       color: AppTheme.bottom_dialog,
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(top: 16, left: 16, right: 16),
  //                     child: Center(
  //                       child: Text(
  //                         translate("voice.voice_search"),
  //                         style: TextStyle(
  //                           fontSize: 17,
  //                           fontStyle: FontStyle.normal,
  //                           fontWeight: FontWeight.w600,
  //                           fontFamily: AppTheme.fontRoboto,
  //                           color: AppTheme.black_text,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(top: 8, left: 32, right: 32),
  //                     child: Center(
  //                       child: Text(
  //                         translate("voice.title"),
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           fontStyle: FontStyle.normal,
  //                           fontWeight: FontWeight.normal,
  //                           fontFamily: AppTheme.fontRoboto,
  //                           color: AppTheme.black_transparent_text,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       child: Align(
  //                         alignment: Alignment.center,
  //                         child: Container(
  //                           width: 103,
  //                           height: 103,
  //                           child: Stack(
  //                             children: [
  //                               Container(
  //                                 decoration: BoxDecoration(
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                         blurRadius: .26,
  //                                         spreadRadius: level * 1.5,
  //                                         color: Colors.black.withOpacity(.05))
  //                                   ],
  //                                   color: Colors.white,
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(50)),
  //                                 ),
  //                                 child: Center(
  //                                   child: SvgPicture.asset(
  //                                       "assets/images/voice_blue.svg"),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                       speechText.cancel();
  //                       setState(() {
  //                         level = 0.0;
  //                       });
  //                     },
  //                     child: Container(
  //                       margin: EdgeInsets.all(16),
  //                       decoration: BoxDecoration(
  //                         color: AppTheme.white,
  //                         borderRadius: BorderRadius.circular(10.0),
  //                         border: Border.all(
  //                           color: AppTheme.blue_app_color,
  //                           width: 2.0,
  //                         ),
  //                       ),
  //                       height: 56,
  //                       width: double.infinity,
  //                       child: Center(
  //                         child: Text(
  //                           translate("voice.cancel"),
  //                           style: TextStyle(
  //                               fontFamily: AppTheme.fontRoboto,
  //                               fontWeight: FontWeight.w600,
  //                               fontStyle: FontStyle.normal,
  //                               fontSize: 17,
  //                               color: AppTheme.blue_app_color),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  static void voiceAssistantDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 340,
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.bottom_dialog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Center(
                        child: Text(
                          translate("voice.voice_search"),
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRoboto,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, left: 32, right: 32),
                      child: Center(
                        child: Text(
                          translate("voice.title"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppTheme.fontRoboto,
                            color: AppTheme.black_transparent_text,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 103,
                            height: 103,
                            child: Center(
                              child: Lottie.asset('assets/anim/voice.json'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        MethodChannel methodChannel =
                            MethodChannel("flutter/MethodChannelDemoExam");
                        await methodChannel.invokeMethod("stop");
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: AppTheme.blue_app_color,
                            width: 2.0,
                          ),
                        ),
                        height: 56,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            translate("voice.cancel"),
                            style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                fontSize: 17,
                                color: AppTheme.blue_app_color),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void mapBottom(
      LocationModel locationItem, BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              margin: EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                  height: 252,
                  color: AppTheme.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        height: 4,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.bottom_dialog,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                locationItem.name,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              locationItem.distance.toInt() == 0
                                  ? ""
                                  : locationItem.distance.toString() + " m",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                        width: double.infinity,
                        child: Text(
                          locationItem.address,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: AppTheme.black_text,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12, top: 17),
                        child: Row(
                          children: [
                            Text(
                              translate("map.work") + " : ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                color: AppTheme.black_transparent_text,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Text(
                                locationItem.mode,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_text,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var url = "tel:" +
                              locationItem.phone
                                  .replaceAll(" ", "")
                                  .replaceAll("-", "")
                                  .replaceAll("(", "")
                                  .replaceAll(")", "");
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                          child: Row(
                            children: [
                              Text(
                                translate("auth.number_auth") + " : ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  color: AppTheme.black_transparent_text,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Text(
                                  locationItem.phone,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: AppTheme.blue_app_color,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () async {
                              var pharmacyLat =
                                  locationItem.location.coordinates[1];
                              var pharmacyLng =
                                  locationItem.location.coordinates[0];
                              var url =
                                  'http://maps.google.com/maps?saddr=$lat,$lng&daddr=$pharmacyLat,$pharmacyLng';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                color: AppTheme.blue_app_color,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  translate("map.maps"),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppTheme.white,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
