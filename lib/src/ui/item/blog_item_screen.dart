import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';

class BlogItemScreen extends StatefulWidget {
  final String image;
  final String title;
  final String message;
  final DateTime dateTime;

  BlogItemScreen({
    this.image,
    this.title,
    this.message,
    this.dateTime,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlogItemScreenState();
  }
}

class _BlogItemScreenState extends State<BlogItemScreen> {
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
              translate("home.articles"),
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 17,
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: AppTheme.white,
            ),
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: widget.image,
                placeholder: (context, url) => SvgPicture.asset(
                  "assets/icons/default_image.svg",
                ),
                errorWidget: (context, url, error) => SvgPicture.asset(
                  "assets/icons/default_image.svg",
                ),
                width: MediaQuery.of(context).size.width - 64,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            color: AppTheme.white,
            child: Text(
              Utils.dateFormat(widget.dateTime),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.normal,
                fontSize: 12,
                height: 1.2,
                color: AppTheme.textGray,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 8,
            ),
            color: AppTheme.white,
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: AppTheme.fontRubik,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1.6,
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
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              color: AppTheme.white,
            ),
            child: RichText(
              text: HTML.toTextSpan(
                context,
                widget.message,
                defaultTextStyle: TextStyle(
                  fontFamily: AppTheme.fontRubik,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 1.6,
                  color: AppTheme.text_dark,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var url = "tel:712050888";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(
                top: 16,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.blue.withOpacity(0.2),
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/icons/phone.svg"),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate("home.call_center"),
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          height: 1.2,
                          color: AppTheme.textGray,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "+998 (71) 205-0-888",
                        style: TextStyle(
                          fontFamily: AppTheme.fontRubik,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 1.1,
                          color: AppTheme.text_dark,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(width: 16),
                  SvgPicture.asset("assets/icons/arrow_right_grey.svg")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
