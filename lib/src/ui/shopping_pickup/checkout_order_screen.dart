import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';

import '../../app_theme.dart';

class CheckoutOrderScreen extends StatefulWidget {
  final List<ProductsStore> drugs;
  final CashBackData data;

  CheckoutOrderScreen({
    this.drugs,
    this.data,
  });

  @override
  State<StatefulWidget> createState() {
    return _CheckoutOrderScreenState();
  }
}

class _CheckoutOrderScreenState extends State<CheckoutOrderScreen> {
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
              translate("card.order"),
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppTheme.black_text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
