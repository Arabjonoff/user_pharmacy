import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/model/sort_radio_btn.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/shopping_curer/add_address_card.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class MyInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyInfoScreenState();
  }
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  var loading = false;

  TextEditingController surNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  String token;
  String number;

  String radioItemHolder = translate("auth.male");
  int id = 1;
  String birthday = "";
  DateTime dateTimeBirthday;

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
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1.0,
            backgroundColor: AppTheme.white,
            brightness: Brightness.light,
            title: Container(
              height: 63,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        color: AppTheme.arrow_examp_back,
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(3),
                            child: SvgPicture.asset(
                                "assets/images/arrow_back.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 3.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translate("menu.me_info"),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppTheme.black_text,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontCommons,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppTheme.auth_login,
                    border: Border.all(
                      color: AppTheme.auth_border,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, left: 12, right: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
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
                    padding: EdgeInsets.only(top: 8, left: 12, right: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRoboto,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.black_text,
                        fontSize: 15,
                      ),
                      controller: surNameController,
                      decoration: InputDecoration(
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
                Container(
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
                    padding: EdgeInsets.only(top: 8, left: 12, right: 12),
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
                      controller: numberController,
                      decoration: InputDecoration(
                        labelText: translate('auth.number_auth'),
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
                      currentTime: dateTimeBirthday,
                      locale: LocaleType.en,
                    );
                  },
                  child: Container(
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
                      padding: EdgeInsets.only(top: 8, left: 12, right: 12),
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
                  token,
                );
                if (response.status == 1) {
                  Utils.saveData(
                    nameController.text.toString(),
                    surNameController.text.toString(),
                    birthday,
                    jins,
                    token,
                    number,
                  );
                  if (response.status == 1) {
                    Navigator.pop(context);
                  }
                  setState(() {
                    loading = false;
                  });
                } else {
                  setState(() {
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
    );
  }

  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      number = prefs.getString("number");
      birthday = prefs.getString("birthday");
      var day = prefs.getString("birthday").split("-")[2];
      var month = prefs.getString("birthday").split("-")[1];
      var num = "+";
      for (int i = 0; i < number.length; i++) {
        if (i == 3 || i == 5 || i == 8 || i == 10) {
          num += " ";
        }
        num += number[i];
      }
      numberController.text = num;
      prefs.getString("gender") == "man" ? id = 1 : id = 2;
      birthdayController.text =
          day + "." + month + "." + prefs.getString("birthday").split("-")[0];
      surNameController.text = prefs.getString("surname");
      nameController.text = prefs.getString("name");
      dateTimeBirthday = new DateTime(
          int.parse(prefs.getString("birthday").split("-")[0]),
          int.parse(month),
          int.parse(day));
    });
  }
}
