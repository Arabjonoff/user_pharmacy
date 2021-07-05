import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/src/model/api/auth/verfy_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/auth/register_screen.dart';
import 'package:pharmacy/src/ui/dialog/top_dialog.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/utils/pipput/pin_put.dart';
import 'package:pharmacy/src/utils/utils.dart';

import '../../app_theme.dart';

class VerifyScreen extends StatefulWidget {
  final String number;

  VerifyScreen(this.number);

  @override
  State<StatefulWidget> createState() {
    return _VerifyScreenState();
  }
}

class _VerifyScreenState extends State<VerifyScreen> {
  var loading = false;
  var isNext = false;
  var timerLoad = true;

  String deviceToken = "";

  Timer _timer;
  int _start = 300;

  TextEditingController verifyController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppTheme.textGray.withOpacity(0.2),
          width: 2,
        ),
      ),
    );
  }

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
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4.0,
        shadowColor: Color.fromRGBO(110, 120, 146, 0.1),
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        actions: [
          Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
          ),
        ],
        leading: Material(
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(56),
              ),
              child: Center(
                child: SvgPicture.asset("assets/icons/arrow_left_blue.svg"),
              ),
            ),
          ),
          color: Colors.transparent,
        ),
        title: Center(
          child: Text(
            translate("auth.verify_title"),
            style: TextStyle(
              fontFamily: AppTheme.fontRubik,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.2,
              color: AppTheme.text_dark,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "assets/img/logo.png",
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width - 260) / 2,
            ),
            child: PinPut(
              fieldsCount: 4,
              controller: verifyController,
              onChanged: (String value) {
                if (value.length == 4) {
                  setState(() {
                    isNext = true;
                  });
                } else {
                  setState(() {
                    isNext = false;
                  });
                }
              },
              focusNode: FocusNode(),
              textStyle: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.normal,
                fontSize: 32,
                height: 1.25,
                color: AppTheme.textGray,
              ),
              submittedFieldDecoration: _pinPutDecoration,
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration,
            ),
          ),
          Container(
            margin: EdgeInsets.all(32),
            child: Text(
              translate("auth.verify_code"),
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.normal,
                fontSize: 12,
                height: 1.6,
                color: AppTheme.textGray,
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: AppTheme.background,
          ),
          Container(
            padding: EdgeInsets.only(
              top: 12,
              left: 22,
              right: 22,
              bottom: 24,
            ),
            color: AppTheme.white,
            child: GestureDetector(
              onTap: () async {
                if (isNext) {
                  setState(() {
                    loading = true;
                  });
                  var response = await Repository().fetchVerify(
                    widget.number,
                    verifyController.text,
                    deviceToken,
                  );

                  if (response.isSuccess) {
                    var result = VerifyModel.fromJson(response.result);
                    if (result.status == 1) {
                      if (result.user.complete == 0) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              result.user.id,
                              result.token,
                              widget.number,
                            ),
                          ),
                        );
                      } else {
                        isLogin = true;
                        Utils.saveData(
                          result.user.id,
                          result.user.firstName,
                          result.user.lastName,
                          result.user.birthDate,
                          result.user.gender,
                          result.token,
                          widget.number,
                        );
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    } else {
                      setState(() {
                        loading = false;
                        TopDialog.errorMessage(
                          context,
                          result.msg,
                        );
                      });
                    }
                  } else if (response.status == -1) {
                    setState(() {
                      loading = false;
                      TopDialog.errorMessage(
                        context,
                        translate("internet_error"),
                      );
                    });
                  } else {
                    setState(() {
                      loading = false;
                      TopDialog.errorMessage(
                        context,
                        response.result["msg"],
                      );
                    });
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: isNext ? AppTheme.blue : AppTheme.gray,
                ),
                height: 44,
                width: double.infinity,
                child: Center(
                  child: loading
                      ? Lottie.asset(
                          'assets/anim/white.json',
                          height: 40,
                        )
                      : Text(
                          isNext
                              ? translate("auth.verify")
                              : translate("auth.verify_reload") +
                                  " " +
                                  Utils.format(_start ~/ 60) +
                                  ":" +
                                  Utils.format(_start % 60),
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontRubik,
                            fontSize: 17,
                            color: AppTheme.white,
                          ),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
