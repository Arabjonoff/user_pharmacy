import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/auth/verfy_screen.dart';
import 'package:pharmacy/src/utils/number_mask.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  var loading = false;
  var errorText = "";
  final PhoneNumberTextInputFormatter _phoneNumber =
      new PhoneNumberTextInputFormatter();

  TextEditingController loginController = TextEditingController(text: "+998");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        title: Column(),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF4F5F7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    height: 72,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/images/login_logo.svg"),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 22.37,
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/images/grandpharm.svg"),
                    ),
                  ),
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
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_text,
                          fontSize: 15,
                        ),
                        inputFormatters: [
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter.digitsOnly,
                          _phoneNumber,
                        ],
                        controller: loginController,
                        decoration: InputDecoration(
                          labelText: translate('auth.number'),
                          labelStyle: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF6D7885),
                            fontSize: 11,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  ),
                  errorText != ""
                      ? Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 9),
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              errorText,
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
                var url = 'https://api.gopharm.uz/privacy';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                height: 45,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
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
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (loginController.text.isNotEmpty) {
                  var number = loginController.text
                      .replaceAll('(', '')
                      .replaceAll(')', '')
                      .replaceAll('+', '')
                      .replaceAll(' ', '')
                      .replaceAll('-', '');

                  if (number.length == 12) {
                    setState(() {
                      errorText = "";
                      loading = true;
                    });
                    var responce = await Repository().fetchLogin(number);
                    if (responce.status == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyScreen(number),
                        ),
                      );
                    } else {
                      setState(() {
                        errorText = responce.msg;
                        loading = false;
                      });
                    }
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
                          translate("next"),
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
