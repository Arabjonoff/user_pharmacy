import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/auth/register_screen.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';

import '../../app_theme.dart';

class VerfyScreen extends StatefulWidget {
  String number;

  VerfyScreen(this.number);

  @override
  State<StatefulWidget> createState() {
    return _VerfyScreenState();
  }
}

class _VerfyScreenState extends State<VerfyScreen> {
  var loading = false;
  var error = false;
  var timerLoad = true;

  String number;

  Timer _timer;
  int _start = 120;

  TextEditingController verfyController = TextEditingController();
  var maskFormatter =
      new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            timerLoad = false;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String kod = widget.number.substring(3, 5);
    String last = widget.number.substring(10, 12);
    number = "+998 " + kod + " *** ** " + last;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Container(
              height: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.item_navigation,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 14),
        child: Column(
          children: [
            Container(
              height: 26,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.arrow_back,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(right: 16),
                        child:
                            SvgPicture.asset("assets/images/arrow_close.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 46, left: 16, right: 16),
              child: Text(
                translate("auth.verfy_title"),
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 3, left: 16, right: 16),
              child: Text(
                number,
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppTheme.auth_login,
                      border: Border.all(
                        color: AppTheme.auth_border,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, left: 12, right: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.black_text,
                                fontSize: 15,
                              ),
                              controller: verfyController,
                              inputFormatters: [maskFormatter],
                              decoration: InputDecoration(
                                labelText: translate('auth.verfy'),
                                labelStyle: TextStyle(
                                  fontFamily: AppTheme.fontRoboto,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6D7885),
                                  fontSize: 11,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppTheme.auth_login,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: AppTheme.auth_login,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          timerLoad
                              ? Container(
                                  width: 32,
                                  height: 16,
                                  child: Text(
                                    _start.toString(),
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRoboto,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xFF6D7885),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    var responce = await Repository()
                                        .fetchLogin(widget.number);
                                    if (responce.status == 1) {
                                      setState(() {
                                        loading = false;
                                        timerLoad = true;
                                        _start = 120;
                                        startTimer();
                                      });
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 9),
                                    child: SvgPicture.asset(
                                        "assets/images/reply.svg"),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  error
                      ? Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 9),
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              translate("auth.error"),
                              style: TextStyle(
                                fontFamily: AppTheme.fontRoboto,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.red_fav_color,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (verfyController.text.isNotEmpty &&
                    verfyController.text.length == 4) {
                  setState(() {
                    loading = true;
                  });
                  var responce = await Repository().fetchVetfy(
                    widget.number,
                    verfyController.text,
                  );
                  if (responce.status == 1) {
                    if (responce.user.complete == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen(responce.token, widget.number),
                        ),
                      );
                    } else {
                      isLogin = true;
                      Utils.saveData(
                        responce.user.firstName,
                        responce.user.lastName,
                        responce.user.birthDate,
                        responce.user.gender,
                        responce.token,
                        widget.number,
                      );
                      Navigator.pop(context);
                    }
                    setState(() {
                      loading = false;
                      error = false;
                    });
                  } else {
                    setState(() {
                      loading = false;
                      error = true;
                    });
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppTheme.blue_app_color,
                ),
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  bottom: 40,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: loading
                      ? CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.white),
                        )
                      : Text(
                          translate("auth.verfy_btn"),
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 17,
                            color: AppTheme.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
