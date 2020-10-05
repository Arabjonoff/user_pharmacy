import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/model/sort_radio_btn.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';

import '../../app_theme.dart';

class RegisterScreen extends StatefulWidget {
  int id;
  String token;
  String number;

  RegisterScreen(this.id, this.token, this.number);

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  var loading = false;
  var error = false;
  var errorText = "";

  TextEditingController surNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  String radioItemHolder = translate("auth.male");
  int id = 1;
  String birthday = "";

  List<RadioGroup> nList = [
    RadioGroup(
      index: 1,
      name: translate("auth.male"),
    ),
    RadioGroup(
      index: 2,
      name: translate("auth.female"),
    ),
  ];

  DateTime now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
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
                    alignment: Alignment.center,
                    child: Text(
                      translate("auth.data"),
                      style: TextStyle(
                        fontFamily: AppTheme.fontCommons,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: AppTheme.black_text,
                      ),
                    ),
                  ),
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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 30, left: 16, right: 16),
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
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_text,
                          fontSize: 15,
                        ),
                        maxLength: 50,
                        controller: nameController,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: translate('auth.name'),
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
                  Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
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
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRoboto,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.black_text,
                          fontSize: 15,
                        ),
                        maxLength: 50,
                        controller: surNameController,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: translate('auth.sur_name'),
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
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 2, 16),
                        maxTime: now,
                        onConfirm: (date) {
                          var month = date.month < 10
                              ? "0" + date.month.toString()
                              : date.month.toString();
                          var day = date.day < 10
                              ? "0" + date.day.toString()
                              : date.day.toString();
                          birthdayController.text =
                              day + "." + month + "." + date.year.toString();

                          birthday =
                              date.year.toString() + "-" + month + "-" + day;
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
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
                        child: IgnorePointer(
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontFamily: AppTheme.fontRoboto,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              color: AppTheme.black_text,
                              fontSize: 15,
                            ),
                            controller: birthdayController,
                            decoration: InputDecoration(
                              labelText: translate('auth.birthday'),
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
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: ClampingScrollPhysics(),
                      children: nList
                          .map((data) => RadioListTile(
                                title: Text(
                                  "${data.name}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: AppTheme.fontRoboto,
                                    color: AppTheme.black_text,
                                  ),
                                ),
                                activeColor: AppTheme.blue_app_color,
                                groupValue: id,
                                value: data.index,
                                onChanged: (val) {
                                  setState(() {
                                    radioItemHolder = data.name;
                                    id = data.index;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                String jins = id == 1 ? "man" : "woman";
                if (nameController.text.isNotEmpty &&
                    surNameController.text.isNotEmpty &&
                    birthday.isNotEmpty) {
                  setState(() {
                    loading = true;
                  });
                  var response = await Repository().fetchRegister(
                    nameController.text.toString(),
                    surNameController.text.toString(),
                    birthday,
                    jins,
                    widget.token,
                  );
                  if (response.status == 1) {
                    isLogin = true;
                    Utils.saveData(
                      widget.id,
                      nameController.text.toString(),
                      surNameController.text.toString(),
                      birthday,
                      jins,
                      widget.token,
                      widget.number,
                    );
                    if (response.status == 1) {
                      Navigator.pop(context);
                    }
                    setState(() {
                      loading = false;
                    });
                  } else if (response.status == -1) {
                    setState(() {
                      error = true;
                      errorText = response.msg;
                      loading = false;
                    });
                  } else {
                    setState(() {
                      error = false;
                      loading = false;
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
                  bottom: 30,
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
                          translate("auth.save"),
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
