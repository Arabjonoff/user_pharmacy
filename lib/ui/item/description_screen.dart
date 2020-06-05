import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/app_theme.dart';

class DescriptionScreen extends StatefulWidget {

  int id;
  DescriptionScreen(this.id);

  @override
  State<StatefulWidget> createState() {
    return _DescriptionScreenState();
  }
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  ScrollController _controller;
  bool scroll = true;
  bool isCard = true;
  int lastPosition = 0;

  _scrollListener() {
    if (lastPosition > _controller.offset.toInt()) {
      setState(() {
        scroll = true;
        lastPosition = _controller.offset.toInt();
      });
    } else {
      setState(() {
        scroll = false;
        lastPosition = _controller.offset.toInt();
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(scroll);
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          ListView(
            controller: _controller,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://interchem.ua/uploads/drugs/andipa10.png',
                        placeholder: (context, url) => Icon(Icons.camera_alt),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.all(7),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border,
                            color: AppTheme.black_transparent_text,
                            size: 36,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 15,
                ),
                child: Text(
                  "вынимание вынимание",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.black_transparent_text,
                  ),
                ),
              ),
              Container(
                height: 1,
                color: AppTheme.black_linear,
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  "Aмиксин таблетки 125 мг 6 шт",
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, bottom: 25, top: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "125 000 so'm",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      translate("item.all_price"),
                      style: TextStyle(
                        color: AppTheme.green_text,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 25),
                child: Row(
                  children: <Widget>[
                    Material(
                      elevation: 5,
                      color: AppTheme.red_app_color,
                      borderRadius: BorderRadius.circular(9.0),
                      child: MaterialButton(
                        child: Container(
                          margin: EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            translate("item.bonus"),
                            style: TextStyle(
                              color: AppTheme.dark_grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(9.0),
                      child: MaterialButton(
                        child: Container(
                          margin: EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            translate("item.analog"),
                            style: TextStyle(
                              color: AppTheme.dark_grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate("item.country"),
                      style: TextStyle(
                        color: AppTheme.dark_grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "O'zbekistan",
                      style: TextStyle(
                        color: AppTheme.black_transparent_text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate("item.active_substances"),
                      style: TextStyle(
                        color: AppTheme.dark_grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Papaverine",
                      style: TextStyle(
                        color: AppTheme.black_transparent_text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate("item.from_pharmacy"),
                      style: TextStyle(
                        color: AppTheme.dark_grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Over the counter",
                      style: TextStyle(
                        color: AppTheme.black_transparent_text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: Text(
                  translate("home.question"),
                  style: TextStyle(
                    color: AppTheme.black_text,
                    fontSize: 21,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                height: 75,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        elevation: 5.0,
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(9.0),
                        child: MaterialButton(
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 56,
                                width: 56,
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(
                                        "assets/images/circle_green.png"),
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Image.asset(
                                          "assets/images/chatting.png"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    translate("home.message"),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Material(
                        elevation: 5.0,
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(9.0),
                        child: MaterialButton(
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 56,
                                width: 56,
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(
                                        "assets/images/circle_green.png"),
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Image.asset(
                                          "assets/images/phone_green.png"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    translate("home.call"),
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 25),
                child: Text(
                  "Papaverine",
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  translate("info"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 25,
                  bottom: 15,
                ),
                child: Text(
                  translate("item.latin_name"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  translate("Papaverine"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 25,
                  bottom: 15,
                ),
                child: Text(
                  translate("item.active_substance"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  translate("******Papaverine"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 25,
                  bottom: 15,
                ),
                child: Text(
                  translate("item.atx"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  translate("A03AD01TK78"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 25,
                  bottom: 15,
                ),
                child: Text(
                  translate("item.latin_name"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  translate("Papaverine"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 25),
                child: Text(
                  "Papaverine",
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  translate("info"),
                  style: TextStyle(
                    color: AppTheme.dark_grey,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: scroll
                ? Container(
                    height: 56,
                    margin: EdgeInsets.all(15),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(3.0),
                      child: isCard
                          ? MaterialButton(
                              color: AppTheme.red_app_color,
                              child: Center(
                                child: Text(
                                  translate("item.card"),
                                  style: TextStyle(
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            )
                          : Container(),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
