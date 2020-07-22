import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class MyAppSocket extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppSocket> {
  @override
  void initState() {
    socket();
    super.initState();
  }

  final TextEditingController _urlController = TextEditingController(
      text:
          'wss://online.grandpharm.uz/ws/notifications?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJ1c2VybmFtZSI6Ijk5ODk0MzI5MzQwNiIsImV4cCI6MTYyNjkzNDAwMCwiZW1haWwiOiIifQ.UeB4Y4wXmytV61FIOvWPGs7rm7kcRz2kYitdC5MFn7E');

  String _message = '';
  String _closeMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Websocket Manager Example'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _urlController,
          ),
          Text(_message),
          Text('Close message:'),
          Text(_closeMessage),
        ],
      ),
    );
  }

  Future<void> socket() async {

    var channel = await IOWebSocketChannel.connect(
        "wss://online.grandpharm.uz/ws/notifications?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjI1MTM5NjgxLCJlbWFpbCI6ImFkbWluQGFkbWluLmNvbSJ9.BOkmuH4XiAcxW7eNiFT2XBgiTnWk32ttwuEqysLJlJA");
    channel.stream.listen((message) {
      //channel.sink.add("received!");
     // print(message);
    });
  }
}
