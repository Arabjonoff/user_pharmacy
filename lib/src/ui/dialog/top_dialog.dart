import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacy/src/utils/top_modal_sheet.dart';

import '../../app_theme.dart';

class TopDialog {
  static void errorMessage(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(message),
        );
      },
    );
    // showTopModalSheet<String>(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   blur: 0,
    //   child: StatefulBuilder(
    //     builder: (BuildContext context, StateSetter setState) {
    //       return Container(
    //         margin: EdgeInsets.only(top: 64, left: 32, right: 32),
    //         child: GestureDetector(
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //           child: Container(
    //             height: 64,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(8),
    //               color: AppTheme.white,
    //               border: Border.all(
    //                 color: AppTheme.red,
    //                 width: 1,
    //               ),
    //             ),
    //             child: Row(
    //               children: [
    //                 Container(
    //                   height: 64,
    //                   width: 9,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.only(
    //                       topLeft: Radius.circular(8),
    //                       bottomLeft: Radius.circular(8),
    //                     ),
    //                     color: AppTheme.red,
    //                   ),
    //                 ),
    //                 SizedBox(width: 7),
    //                 Expanded(
    //                   child: Text(
    //                     message ?? "",
    //                     style: TextStyle(
    //                       fontFamily: AppTheme.fontRubik,
    //                       fontWeight: FontWeight.normal,
    //                       fontSize: 14,
    //                       height: 1.4,
    //                       color: AppTheme.text_dark,
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(width: 8),
    //                 SvgPicture.asset("assets/icons/msg_close.svg"),
    //                 SizedBox(width: 16),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
