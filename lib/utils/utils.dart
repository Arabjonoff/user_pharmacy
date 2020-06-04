import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Utils {
  static Future<String> scanBarcodeNormal() async {
    try {
      return await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on FormatException {
      return '';
    }
  }
}
