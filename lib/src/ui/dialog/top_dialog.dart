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
                  SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
