import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/global.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmacy/src/delete/new_delete.dart';
import 'package:pharmacy/src/ui/sub_menu/history_order_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app_theme.dart';

// ignore: must_be_immutable
class DeleteWebScreen extends StatefulWidget {
  String url;

  DeleteWebScreen(this.url);

  @override
  State<StatefulWidget> createState() {
    return _DeleteWebScreenState();
  }
}

List<int> fromRelease;
List<int> manufacturers;
List<int> country;
List<int> activeSubstance;
double fromPrice;
double toPrice;

void setData() {
  fromPrice = 15.0;
}

class _DeleteWebScreenState extends State<DeleteWebScreen> {
  String url =
      "<form name=\"mf55796979\" id=\"mf55796979\" action=\"https://wi.ipakyulibank.uz/acquiring/hJaAGAA/Uz5QszX1kA9J6C6A7UtYScICvmVZ/middle/\" method=\"post\" target=\"_blank\">\r\n            <input type=\"hidden\" name=\"N1Z1eVEySXJXVWJkdEJjM3FSdFhiQT09\" value=\"cnBDek5OUXdsc3AyVW1yN2dZVkZBQT09\">\r\n            <input type=\"hidden\" name=\"09XYxdzUM1pwc9EQ1pmdNKS0JveNUPUq\" value=\"34;@Ak74^=DJ\">\r\n            </form>\r\n            <script id=\"sr37803609\">\r\n            document.getElementById('mf55796979').submit();\r\n            var element=document.getElementById('mf55796979');\r\n            element.parentNode.removeChild(element);\r\n            </script>\r\n            <script>\r\n            var e2=document.getElementById('sr37803609');\r\n            e2.parentNode.removeChild(e2);\r\n            </script>";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Container(
              height: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.item_navigation,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF44337A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0),
            topRight: Radius.circular(14.0),
          ),
        ),
        padding: EdgeInsets.only(top: 14),
        child: Column(
          children: [
            Container(
              height: 36,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        print(fromPrice);
                      },
                      child: Text(
                        translate("card.payment"),
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: AppTheme.fontCommons,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        height: 36,
                        margin: EdgeInsets.only(right: 16),
                        width: 36,
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.arrow_back,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                                "assets/images/arrow_close.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://prep.uz/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
