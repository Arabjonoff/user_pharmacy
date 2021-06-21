import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/main/card/card_screen.dart';
import 'package:pharmacy/src/ui/main/home/home_screen.dart';
import 'package:pharmacy/src/utils/utils.dart';

import '../../app_theme.dart';

class RegisterScreen extends StatefulWidget {
  final int id;
  final String token;
  final String number;
  final bool konkurs;

  RegisterScreen(
    this.id,
    this.token,
    this.number,
    this.konkurs,
  );

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  var loading = false;
  var isNext = false;
  var errorText = "";

  TextEditingController surNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  int id = 1;
  String birthday = "";
  DateTime dateTime = new DateTime.now();

  String selectedUser;
  List<String> users = <String>[
    'Facebook/Instagram',
    'Google/Yandex Поиск',
    translate("winner.ads_choose"),
    'Telegram',
    translate("winner.fr"),
    translate("winner.other"),
  ];

  @override
  void initState() {
    var number = "+";
    for (int i = 0; i < widget.number.length; i++) {
      number += widget.number[i];
      if (i == 2 || i == 4 || i == 7 || i == 9) {
        number += " ";
      }
    }
    numberController.text = number;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        actions: [
          Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
            child: Center(
              child: SvgPicture.asset("assets/icons/arrow_left_blue.svg"),
            ),
          ),
        ),
        title: Center(
          child: Text(
            translate("auth.register_title"),
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
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Text(
                  translate("auth.name"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.2,
                    color: AppTheme.textGray,
                  ),
                ),
              ),
              Container(
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.text_dark,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  maxLength: 35,
                  controller: nameController,
                  onChanged: (value) {
                    if (birthday.length > 0 &&
                        nameController.text.length > 0 &&
                        surNameController.text.length > 0) {
                      setState(() {
                        isNext = true;
                      });
                    } else {
                      setState(() {
                        isNext = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: AppTheme.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Text(
                  translate("auth.last_name"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.2,
                    color: AppTheme.textGray,
                  ),
                ),
              ),
              Container(
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.text_dark,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  maxLength: 35,
                  controller: surNameController,
                  onChanged: (value) {
                    if (birthday.length > 0 &&
                        nameController.text.length > 0 &&
                        surNameController.text.length > 0) {
                      setState(() {
                        isNext = true;
                      });
                    } else {
                      setState(() {
                        isNext = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: AppTheme.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Text(
                  translate("auth.number"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.2,
                    color: AppTheme.textGray,
                  ),
                ),
              ),
              Container(
                height: 44,
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  readOnly: true,
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.text_dark,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  maxLength: 35,
                  controller: numberController,
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: AppTheme.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Text(
                  translate("auth.birthday"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.2,
                    color: AppTheme.textGray,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 2, 16),
                    maxTime: DateTime.now(),
                    onConfirm: (date) {
                      dateTime = date;
                      var month = date.month < 10
                          ? "0" + date.month.toString()
                          : date.month.toString();
                      var day = date.day < 10
                          ? "0" + date.day.toString()
                          : date.day.toString();
                      birthdayController.text =
                          day + "." + month + "." + date.year.toString();

                      birthday = date.year.toString() + "-" + month + "-" + day;
                      if (birthday.length > 0 &&
                          nameController.text.length > 0 &&
                          surNameController.text.length > 0) {
                        setState(() {
                          isNext = true;
                        });
                      } else {
                        setState(() {
                          isNext = false;
                        });
                      }
                    },
                    currentTime: dateTime,
                    locale: LocaleType.ru,
                  );
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IgnorePointer(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.text_dark,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLength: 35,
                      controller: birthdayController,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Text(
                  translate("auth.gender"),
                  style: TextStyle(
                    fontFamily: AppTheme.fontRubik,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.2,
                    color: AppTheme.textGray,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 12,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (id != 1)
                            setState(() {
                              id = 1;
                            });
                        },
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 270),
                              curve: Curves.easeInOut,
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F5F7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      id == 1 ? AppTheme.blue : AppTheme.gray,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 270),
                                  curve: Curves.easeInOut,
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: id == 1
                                        ? AppTheme.blue
                                        : Color(0xFFF4F5F7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              translate("auth.male"),
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRubik,
                                color: AppTheme.text_dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (id != 2)
                            setState(() {
                              id = 2;
                            });
                        },
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 270),
                              curve: Curves.easeInOut,
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F5F7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      id == 2 ? AppTheme.blue : AppTheme.gray,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 270),
                                  curve: Curves.easeInOut,
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: id == 2
                                        ? AppTheme.blue
                                        : Color(0xFFF4F5F7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              translate("auth.female"),
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontFamily: AppTheme.fontRubik,
                                color: AppTheme.text_dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              errorText != ""
                  ? Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          errorText,
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.red,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              widget.konkurs
                  ? Container(
                      margin: EdgeInsets.only(top: 36, left: 16, right: 16),
                      child: Text(
                        translate("winner.register_title"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.33,
                          color: AppTheme.textGray,
                        ),
                      ),
                    )
                  : Container(),
              widget.konkurs
                  ? Container(
                      height: 52,
                      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppTheme.auth_login,
                        border: Border.all(
                          color: AppTheme.gray,
                          width: 1.0,
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.text_dark,
                          fontSize: 15,
                        ),
                        maxLength: 50,
                        controller: cityController,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: translate('winner.city'),
                          labelStyle: TextStyle(
                            fontFamily: AppTheme.fontRubik,
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
                    )
                  : Container(),
              widget.konkurs
                  ? Theme(
                      data: ThemeData(
                        primaryColor: const Color(0xFF02BB9F),
                        primaryColorDark: const Color(0xFF167F67),
                        accentColor: const Color(0xFF167F67),
                      ),
                      child: Container(
                        height: 52,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.auth_login,
                          border: Border.all(
                            color: AppTheme.gray,
                            width: 1.0,
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              hint: Text(
                                translate('winner.ads'),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6D7885),
                                  fontSize: 11,
                                ),
                              ),
                              value: selectedUser,
                              onChanged: (String value) {
                                setState(() {
                                  selectedUser = value;
                                });
                              },
                              items: users.map((String user) {
                                return DropdownMenuItem<String>(
                                  value: user,
                                  child: Text(
                                    user,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.text_dark,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 24,
                                color: Color(0xFF6D7885),
                              ),
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Expanded(child: Container()),
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
                String gender = id == 1 ? "man" : "woman";
                if (nameController.text.isNotEmpty &&
                    surNameController.text.isNotEmpty &&
                    birthday.isNotEmpty) {
                  setState(() {
                    loading = true;
                  });
                  String ads = selectedUser == null ? "" : selectedUser;
                  var response = await Repository().fetchRegister(
                    nameController.text.toString(),
                    surNameController.text.toString(),
                    birthday,
                    gender,
                    widget.token,
                    cityController.text,
                    ads,
                    fcToken,
                  );

                  if (response.isSuccess) {
                    var result = LoginModel.fromJson(response.result);
                    if (result.status == 1) {
                      isLogin = true;
                      Utils.saveData(
                        widget.id,
                        nameController.text.toString(),
                        surNameController.text.toString(),
                        birthday,
                        gender,
                        widget.token,
                        widget.number,
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      setState(() {
                        loading = false;
                      });
                    } else {
                      setState(() {
                        errorText = response.result["msg"];
                        loading = false;
                      });
                    }
                  } else if (response.status == -1) {
                    setState(() {
                      errorText = translate("internet_error");
                      loading = false;
                    });
                  } else {
                    setState(() {
                      errorText = response.result["msg"];
                      loading = false;
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
                      ? CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.white),
                        )
                      : Text(
                          translate("auth.sign_up"),
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
          ),
        ],
      ),
    );
  }
}
