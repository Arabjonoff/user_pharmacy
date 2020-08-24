import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmacy/src/blocs/aptek_block.dart';
import 'package:pharmacy/src/database/database_helper_address.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/ui/address_apteka/address_apteka_map.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_theme.dart';

class NoteAllListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteAllListScreenState();
  }
}

class _NoteAllListScreenState extends State<NoteAllListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
    );
  }
}
