import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/utils/utils.dart';

class API {
  ///get search
  static Future<ItemsAllModel> getItemsAllInfo(int id) async {
    String url = Utils.BASE_URL + '/api/v1/drugs/' + id.toString();

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = ItemsAllModel.fromJson(parsed);

    return saleModel;
  }
}
