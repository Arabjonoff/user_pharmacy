import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';

class RegionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegionScreenState();
  }
}

class _RegionScreenState extends State<RegionScreen> {
  Size size;
  TextEditingController searchController = TextEditingController();
  DatabaseHelper dataBase = new DatabaseHelper();
  bool isSearchText = false;
  String obj = "";
  int cityId;

  bool isLoading = true;

  List<RegionModel> users = new List();

  @override
  void initState() {
    _getMoreData();
    super.initState();
  }

  _RegionScreenState() {
    searchController.addListener(() {
      if (searchController.text != obj) {
        setState(() {
          users = new List();
          obj = searchController.text;
          isSearchText = true;
          _getMoreData();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.arrow_examp_back,
            padding: EdgeInsets.all(19),
            child: SvgPicture.asset("assets/images/arrow_back.svg"),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("menu.city"),
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            height: 36,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: AppTheme.black_transparent,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(
                          Icons.search,
                          size: 24,
                          color: AppTheme.notWhite,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 36,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                cursorColor: AppTheme.notWhite,
                                style: TextStyle(
                                  color: AppTheme.black_text,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontRoboto,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: translate("search_real"),
                                  hintStyle: TextStyle(
                                    color: AppTheme.notWhite,
                                    fontSize: 15,
                                    fontFamily: AppTheme.fontRoboto,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                controller: searchController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.blue_app_color,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return users[index].childs.length == 0
                          ? GestureDetector(
                              onTap: () async {
                                if (users[index].isChoose == null ||
                                    !users[index].isChoose) {
                                  Repository().fetchAddRegion(users[index].id);
                                  dataBase.clear();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("city", users[index].name);
                                  prefs.setInt("cityId", users[index].id);
                                  blocHome.fetchAllHome(
                                    1,
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                    "",
                                  );
                                  blocHome.fetchCityName();
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                color: AppTheme.white,
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: 59,
                                        margin: EdgeInsets.only(
                                            left: 16, right: 20),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                users[index].name,
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily:
                                                      AppTheme.fontRoboto,
                                                  fontSize: 15,
                                                  color: AppTheme.black_text,
                                                ),
                                              ),
                                            ),
                                            users[index].isChoose == null
                                                ? Container()
                                                : users[index].isChoose == false
                                                    ? Container()
                                                    : SvgPicture.asset(
                                                        "assets/images/icon_region.svg"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: AppTheme.black_linear_category,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      if (users[index].isOpen == null ||
                                          users[index].isOpen == false) {
                                        users[index].isOpen = true;
                                      } else {
                                        users[index].isOpen = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 16, right: 16),
                                    color: AppTheme.white,
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            users[index].name,
                                            style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: AppTheme.fontRoboto,
                                              fontSize: 15,
                                              color: AppTheme.black_text,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          users[index].isOpen == null
                                              ? Icons.keyboard_arrow_down
                                              : users[index].isOpen
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                          size: 24,
                                          color: AppTheme.black_text,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                (users[index].isOpen == null ||
                                        users[index].isOpen == false)
                                    ? Container()
                                    : ListView.builder(
                                        itemCount: users[index].childs.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, position) {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (users[index]
                                                          .childs[position]
                                                          .isChoose ==
                                                      null ||
                                                  !users[index]
                                                      .childs[position]
                                                      .isChoose) {
                                                Repository().fetchAddRegion(
                                                    users[index]
                                                        .childs[position]
                                                        .id);
                                                dataBase.clear();
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString(
                                                    "city",
                                                    users[index]
                                                        .childs[position]
                                                        .name);
                                                prefs.setInt(
                                                    "cityId",
                                                    users[index]
                                                        .childs[position]
                                                        .id);
                                                blocHome.fetchAllHome(
                                                  1,
                                                  "",
                                                  "",
                                                  "",
                                                  "",
                                                  "",
                                                  "",
                                                );
                                                blocHome.fetchCityName();
                                                Navigator.pop(context);
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              color: AppTheme.white,
                                              height: 60,
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                  left: 32, right: 20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      users[index]
                                                          .childs[position]
                                                          .name,
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily:
                                                            AppTheme.fontRoboto,
                                                        fontSize: 15,
                                                        color:
                                                            AppTheme.black_text,
                                                      ),
                                                    ),
                                                  ),
                                                  users[index]
                                                              .childs[position]
                                                              .isChoose ==
                                                          null
                                                      ? Container()
                                                      : users[index]
                                                                  .childs[
                                                                      position]
                                                                  .isChoose ==
                                                              false
                                                          ? Container()
                                                          : SvgPicture.asset(
                                                              "assets/images/icon_region.svg",
                                                            )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                Container(
                                  height: 1,
                                  color: AppTheme.black_linear_category,
                                )
                              ],
                            );
                    },
                  ),
                )
        ],
      ),
    );
  }

  void _getMoreData() async {
    setState(() {
      isLoading = true;
    });
    var response = Repository().fetchRegions(obj);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("cityId") != null) {
      cityId = prefs.getInt("cityId");
    }

    response.then((value) => {
          if (value != null)
            {
              setState(() {
                isLoading = false;
              }),
              for (int i = 0; i < value.length; i++)
                {
                  if (value[i].childs.length > 0)
                    {
                      for (int j = 0; j < value[i].childs.length; j++)
                        {
                          if (cityId == value[i].childs[j].id)
                            {
                              value[i].childs[j].isChoose = true,
                            }
                        }
                    }
                  else if (cityId == value[i].id)
                    {
                      value[i].isChoose = true,
                    }
                },
              setState(() {
                users = new List();
                users = value;
              }),
            }
        });
  }
}
