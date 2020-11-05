import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/global.dart';
import 'package:pharmacy/src/blocs/faq_bloc.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/api/faq_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class FaqAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FaqAppScreenState();
  }
}

class _FaqAppScreenState extends State<FaqAppScreen> {
  @override
  void initState() {
    blocFaq.fetchAllFaq();
    super.initState();
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
              translate("menu.faq"),
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
      body: StreamBuilder(
        stream: blocFaq.allFaq,
        builder: (context, AsyncSnapshot<List<FaqModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.only(bottom: 24),
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Color(0xFFEBEBEB), width: 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        (index + 1).toString() +" "+ snapshot.data[index].question,
                        style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 17,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black_text,
                            height: 1.41),
                      ),
                      SizedBox(height: 12),
                      Text(
                        snapshot.data[index].answer,
                        style: TextStyle(
                            fontFamily: AppTheme.fontRoboto,
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.black_text,
                            height: 1.60),
                      )
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (_, __) => Container(
                height: 120,
                margin: EdgeInsets.all( 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppTheme.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
