import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/blocs/store_block.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/ui/dialog/bottom_dialog.dart';

import '../../app_theme.dart';

class MyAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAddressScreenState();
  }
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  @override
  void initState() {
    blocStore.fetchAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: GestureDetector(
          child: Container(
            height: 56,
            width: 56,
            color: AppTheme.white,
            padding: EdgeInsets.all(13),
            child: SvgPicture.asset("assets/icons/arrow_left_blue.svg"),
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
              translate("address.name"),
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.2,
                color: AppTheme.text_dark,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 1),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Text(
              translate("address.name"),
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.2,
                color: AppTheme.text_dark,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 48,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/home.svg"),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          translate("address.home"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset("assets/icons/edit.svg"),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/work.svg"),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          translate("address.work"),
                          style: TextStyle(
                            fontFamily: AppTheme.fontRubik,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGray,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset("assets/icons/edit.svg"),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: blocStore.allAddress,
                  builder:
                      (context, AsyncSnapshot<List<AddressModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 48,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/location.svg",
                                  color: AppTheme.textGray,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    snapshot.data[index].street,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontRubik,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      height: 1.2,
                                      color: AppTheme.textGray,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                SvgPicture.asset("assets/icons/edit.svg"),
                                SizedBox(width: 8),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
                GestureDetector(
                  onTap: () {
                    BottomDialog.addAddress(context,0);
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/location.svg",
                          color: AppTheme.textGray,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            translate("address.add"),
                            style: TextStyle(
                              fontFamily: AppTheme.fontRubik,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.2,
                              color: AppTheme.textGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
