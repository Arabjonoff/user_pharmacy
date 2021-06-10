import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/home_bloc.dart';
import 'package:pharmacy/src/utils/top_modal_sheet.dart';

import '../../app_theme.dart';

class TopDialog {
  static void createRegion(BuildContext context) async {
    showTopModalSheet<String>(
      context: context,
      backgroundColor: Color.fromRGBO(23, 43, 77, 0.3),
      blur: 4,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                color: AppTheme.white,
              ),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 8,
                        left: 16,
                        right: 16,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/search.svg"),
                          SizedBox(width: 12),
                          Text(
                            translate("home.search"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              height: 1.2,
                              color: AppTheme.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    color: AppTheme.white,
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        SvgPicture.asset("assets/icons/location_grey.svg"),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate("home.location"),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontRubik,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  height: 1.2,
                                  color: AppTheme.blue,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  StreamBuilder(
                                    stream: blocHome.allCityName,
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontRubik,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            height: 1.2,
                                            color: AppTheme.text_dark,
                                          ),
                                        );
                                      }
                                      return Text(
                                        "Ташкент",
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontRubik,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          height: 1.2,
                                          color: AppTheme.text_dark,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 4),
                                  SvgPicture.asset(
                                    "assets/icons/arrow_top_blue.svg",
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
