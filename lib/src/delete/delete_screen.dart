import 'package:card_scanner/card_scanner.dart';
import 'package:card_scanner/models/card_details.dart';
import 'package:card_scanner/models/card_scan_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyAppDelete extends StatefulWidget {
  @override
  _MyAppDeleteState createState() => _MyAppDeleteState();
}

class _MyAppDeleteState extends State<MyAppDelete> {
  CardDetails _cardDetails;

  Future<void> scanCard() async {
    var cardDetails = await CardScanner.scanCard(
        scanOptions: CardScanOptions(scanCardHolderName: true));

    if (!mounted) return;
    setState(() {
      _cardDetails = cardDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('card_scanner app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () async {
                  _requestPermission();
                },
                child: Text('scan card'),
              ),
              Text('$_cardDetails')
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.camera
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    if (permissionRequestResult[PermissionGroup.camera] ==
        PermissionStatus.granted) {
      scanCard();
    }
  }
}
