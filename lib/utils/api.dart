import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/model/sale_model.dart';
import 'package:pharmacy/utils/utils.dart';

class API {
  ///get Sale
  static Future<List<Result>> getSale() async {
    String url = Utils.BASE_URL + '/api/v1/sales';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = SaleModel.fromJson(parsed);


    return saleModel.results;
  }
}
