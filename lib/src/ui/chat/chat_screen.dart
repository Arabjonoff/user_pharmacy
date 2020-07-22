import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/blocs/chat_bloc.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/chat_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController listScrollController = ScrollController();
  TextEditingController chatController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int userId = 0;
  bool addItem = false;
  bool isLoading = false;
  int page = 1;

  List<ChatResults> chatModel = new List();

  @override
  void initState() {
    Utils.getId().then((value) => {
          setState(() {
            userId = value;
          }),
        });
    Utils.getToken().then((value) => {
          setState(() {
            socket(value);
          })
        });
    _getMoreData(page);
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
    super.initState();
  }

  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        leading: Container(
          height: 56,
          width: 56,
          color: AppTheme.arrow_examp_back,
          padding: EdgeInsets.only(top: 21, left: 9, right: 9, bottom: 9),
          child: GestureDetector(
            child: SvgPicture.asset("assets/images/arrow_back.svg"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate("chat.app_name"),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.black_text,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontCommons,
                fontSize: 17,
              ),
            ),
            Text(
              translate("chat.online"),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppTheme.black_transparent_text,
                fontWeight: FontWeight.normal,
                fontFamily: AppTheme.fontRoboto,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: blocChat.allChat,
              builder: (context, AsyncSnapshot<ChatApiModel> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data.next == null
                      ? isLoading = true
                      : isLoading = false;
                  if (!addItem) {
                    chatModel.addAll(snapshot.data.results);
                  } else {
                    addItem = false;
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: chatModel.length + 1,
                    reverse: true,
                    controller: listScrollController,
                    itemBuilder: (context, index) {
                      if (index == chatModel.length) {
                        return Container(
                          child: new Center(
                            child: new Opacity(
                              opacity: isLoading ? 0.0 : 1.0,
                              child: Container(
                                height: 45,
                                child: Lottie.asset(
                                    'assets/anim/loading_animation.json'),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: userId == chatModel[index].userId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment:
                                userId == chatModel[index].userId
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              index == chatModel.length - 1
                                  ? Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 7),
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 3,
                                            bottom: 3,
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppTheme.auth_login,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            chatModel[index].day.toString() +
                                                "-" +
                                                getTimeFormat(
                                                    chatModel[index].month),
                                          ),
                                        ),
                                      ),
                                    )
                                  : chatModel[index + 1].year !=
                                          chatModel[index].year
                                      ? Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(top: 7),
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 3,
                                                bottom: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: AppTheme.auth_login,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                chatModel[index]
                                                        .day
                                                        .toString() +
                                                    "-" +
                                                    getTimeFormat(
                                                        chatModel[index].month),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                              Container(
                                margin: userId == chatModel[index].userId
                                    ? EdgeInsets.only(
                                        left: 35,
                                        top: 3,
                                        bottom: 7,
                                      )
                                    : EdgeInsets.only(
                                        right: 35,
                                        top: 3,
                                        bottom: 7,
                                      ),
                                padding: EdgeInsets.only(
                                  top: 7.0,
                                  bottom: 7.0,
                                  left: 15,
                                  right: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: userId == chatModel[index].userId
                                      ? AppTheme.blue_app_color
                                      : AppTheme.white,
                                  borderRadius: userId ==
                                          chatModel[index].userId
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                        )
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      userId == chatModel[index].userId
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatModel[index].body,
                                      textAlign:
                                          userId == chatModel[index].userId
                                              ? TextAlign.right
                                              : TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRoboto,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16,
                                        color: userId == chatModel[index].userId
                                            ? AppTheme.white
                                            : AppTheme.black_text,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      chatModel[index].time,
                                      textAlign:
                                          userId == chatModel[index].userId
                                              ? TextAlign.right
                                              : TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontRoboto,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        color: AppTheme.dark_grey,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (_, int index) => Align(
                      alignment: index % 2 == 0
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: index % 2 == 0
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: index % 2 == 0
                                ? EdgeInsets.only(
                                    left: 35, top: 3, bottom: 7, right: 7)
                                : EdgeInsets.only(
                                    right: 35, top: 3, bottom: 7, left: 7),
                            padding: EdgeInsets.only(
                              top: 7.0,
                              bottom: 7.0,
                              left: 15,
                              right: 15,
                            ),
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? AppTheme.blue_app_color
                                  : AppTheme.white,
                              borderRadius: index % 2 == 0
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    )
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                            ),
                            height: 65 + random.nextInt(105 - 45).toDouble(),
                          )
                        ],
                      ),
                    ),
                    itemCount: 20,
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 12),
            height: 40,
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(bottom: 11, top: 11, left: 7, right: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white),
                    child: TextField(
                      style: TextStyle(
                        color: AppTheme.black_text,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        fontFamily: AppTheme.fontRoboto,
                      ),
                      controller: chatController,
                      decoration: InputDecoration.collapsed(
                        hintText: translate("chat.sent_hint"),
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          fontFamily: AppTheme.fontRoboto,
                          color: AppTheme.black_transparent_text,
                        ),
                      ),
                      focusNode: focusNode,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    var now = new DateTime.now();
                    if (chatController.text != "") {
                      setState(() {
                        addItem = true;
                        chatModel.insert(
                            0,
                            ChatResults(
                                id: 0,
                                body: chatController.text,
                                userId: userId,
                                month: now.month,
                                day: now.day,
                                time: now.hour.toString() +
                                    ":" +
                                    now.minute.toString(),
                                year: now.year.toString() +
                                    "-" +
                                    now.month.toString() +
                                    "-" +
                                    now.day.toString()));
                        Repository()
                            .fetchSentMessage(chatController.text)
                            .then((value) => {
//                                  setState(() {
//                                    blocChat.fetchAllChat(1);
//                                    isLoading = false;
//                                    page == 2;
//                                  }),
                                });
                        chatController.text = "";
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: AppTheme.blue_app_color,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        color: AppTheme.white,
                      ),
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

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        blocChat.fetchAllChat(index);
        isLoading = false;
        page++;
      });
    }
  }

  getTimeFormat(int date) {
    switch (date) {
      case 1:
        return translate("month.january");
        break;
      case 2:
        return translate("month.february");
        break;
      case 3:
        return translate("month.march");
        break;
      case 4:
        return translate("month.april");
        break;
      case 5:
        return translate("month.may");
        break;
      case 6:
        return translate("month.june");
        break;
      case 7:
        return translate("month.july");
        break;
      case 8:
        return translate("month.august");
        break;
      case 9:
        return translate("month.september");
        break;
      case 10:
        return translate("month.october");
        break;
      case 11:
        return translate("month.november");
        break;
      case 12:
        return translate("month.december");
        break;
    }
  }

  Future<void> socket(String value) async {
    //var url = "wss://online.grandpharm.uz/ws/notifications?token=$value";
    var url = "wss://online.grandpharm.uz/ws/notifications?token=$value";

//    var channel = await IOWebSocketChannel.connect(
//        url);
//    channel.stream.listen((message) {
//      //channel.sink.add("received!");
//      print(message);
//    });
  }
}
