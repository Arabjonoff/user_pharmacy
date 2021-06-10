import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/cancel_order.dart';
import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/check_order_model_new.dart';
import 'package:pharmacy/src/model/api/check_version.dart';
import 'package:pharmacy/src/model/api/current_location_address_model.dart';
import 'package:pharmacy/src/model/api/faq_model.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/api/min_sum.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/create_order_status_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/model/http_result.dart';
import 'package:pharmacy/src/model/payment_verfy.dart';
import 'package:pharmacy/src/model/review/get_review.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/model/send/verfy_payment_model.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyApiProvider {
  HttpClient httpClient = new HttpClient();

  Duration duration = new Duration(seconds: 30);
  static Duration durationTimeout = new Duration(seconds: 30);

  static Future<HttpResult> postRequest(url, body) async {
    final dynamic headers = await _getReqHeader();
    print(url);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(durationTimeout);
      print(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }

  static Future<HttpResult> getRequest(url) async {
    final dynamic headers = await _getReqHeader();
    try {
      print(url);
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(durationTimeout);
      print(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }

  static HttpResult _result(response) {
    var result;
    int status = response.statusCode ?? 404;

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      result = json.decode(utf8.decode(response.bodyBytes));
      return HttpResult(
        isSuccess: true,
        status: status,
        result: result,
      );
    } else {
      return HttpResult(
        isSuccess: false,
        status: status,
        result: null,
      );
    }
  }

  static _getReqHeader() async {
    final prefs = await SharedPreferences.getInstance();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    if (prefs.getString('access') == null) {
      return {
        "Accept": "application/json",
        'X-Device': encoded,
      };
    } else {
      return {
        "Accept": "application/json",
        'X-Device': encoded,
        "Authorization": "Bearer " + prefs.getString('access')
      };
    }
  }

  ///Login
  Future<HttpResult> fetchLogin(String login) async {
    String url = Utils.baseUrl + '/api/v1/register';
    final data = {
      "login": login,
    };
    return await postRequest(url, data);
  }

  ///verify
  Future<HttpResult> fetchVerify(
    String login,
    String code,
    String token,
  ) async {
    String url = Utils.baseUrl + '/api/v1/accept';

    final data = {
      "login": login,
      "smscode": code,
      "device_token": token,
    };
    return await postRequest(url, data);
  }

  ///Register
  Future<HttpResult> fetchRegister(
    String name,
    String surname,
    String birthday,
    String gender,
    String token,
    String city,
    String ads,
    String fctoken,
  ) async {
    String url = Utils.baseUrl + '/api/v1/register-profil';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    final data = {
      "first_name": name,
      "last_name": surname,
      "gender": gender,
      "birth_date": birthday,
      "city": city,
      "ads": ads,
      "fctoken": fctoken,
      "region": regionId.toString(),
    };

    final dynamic headers = {
      "Accept": "application/json",
      'X-Device': encoded,
      "Authorization": "Bearer " + token
    };
    print(url);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: data,
          )
          .timeout(durationTimeout);
      print(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }

  ///Banner
  Future<HttpResult> fetchBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/sales?region=$regionId';

    return await getRequest(url);
  }

  ///Blog
  Future<HttpResult> fetchBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String language = prefs.getString('language') ?? "ru";

    String url = Utils.baseUrl +
        '/api/v1/pages?choice=blog&region=$regionId&lan=$language';

    return await getRequest(url);
  }
  ///CashBack
  Future<HttpResult> fetchCashBackTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String language = prefs.getString('language') ?? "ru";

    String url = Utils.baseUrl +
        '/api/v1/pages?choice=cashback&region=$regionId&lan=$language';

    return await getRequest(url);
  }

  ///best items
  Future<HttpResult> fetchBestItemList(
    int page,
    int perPage,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'is_home=1&'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            'international_name_ids=$internationalNameIds&'
            'manufacturer_ids=$manufacturerIds&'
            'ordering=$ordering&'
            'price_max=$priceMax&'
            'price_min=$priceMin&'
            'unit_ids=$unitIds';
    return await getRequest(url);
  }

  ///Top category
  Future<HttpResult> fetchTopCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String url =
        Utils.baseUrl + '/api/v1/categories?popular=true&region=$regionId';
    return await getRequest(url);
  }

  ///slimming
  Future<HttpResult> fetchSlimming() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String language = prefs.getString('language') ?? "ru";
    String url = Utils.baseUrl +
        '/api/v1/drugs/collections?region=$regionId&lan=$language';
    return await getRequest(url);
  }

  ///category
  Future<CategoryModel> fetchCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/categories?region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return CategoryModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return CategoryModel();
    } on SocketException catch (_) {
      return CategoryModel();
    }
  }

  ///category's by item
  Future<ItemModel> fetchCategoryItemsList(
    String id,
    int page,
    int perPage,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            'category=$id&'
            'international_name_ids=$internationalNameIds&'
            'manufacturer_ids=$manufacturerIds&'
            'ordering=$ordering&'
            'price_max=$priceMax&'
            'price_min=$priceMin&'
            'unit_ids=$unitIds';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return ItemModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///ids's by item
  Future<ItemModel> fetchIdsItemsList(
    String id,
    int page,
    int perPage,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            'ids=$id&'
            'international_name_ids=$internationalNameIds&'
            'manufacturer_ids=$manufacturerIds&'
            'ordering=$ordering&'
            'price_max=$priceMax&'
            'price_min=$priceMin&'
            'unit_ids=$unitIds';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json; charset=utf-8');
    request.headers.set('X-Device', encoded);
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///search's by item
  Future<ItemModel> fetchSearchItemsList(
    String obj,
    int page,
    int perPage,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
    int barcode,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String search = barcode == 1 ? "barcode=$obj" : "search=$obj";

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            '$search&'
            'international_name_ids=$internationalNameIds&'
            'manufacturer_ids=$manufacturerIds&'
            'ordering=$ordering&'
            'price_max=$priceMax&'
            'price_min=$priceMin&'
            'unit_ids=$unitIds';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return ItemModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }

  ///items
  Future<ItemsAllModel> fetchItems(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    String url = Utils.baseUrl + '/api/v1/drugs/$id?region=$regionId';
    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);

      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return ItemsAllModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///stores
  Future<List<LocationModel>> fetchApteka(double lat, double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url =
        Utils.baseUrl + '/api/v1/stores?lat=$lat&lng=$lng&region=$regionId';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      var responseJson = utf8.decode(response.bodyBytes);
      return locationModelFromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///regions
  Future<List<RegionModel>> fetchRegions(String obj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    if (lan == null) {
      lan = "ru";
    }

    String url = Utils.baseUrl + '/api/v1/regions?search=$obj&lan=$lan';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      var responseJson = utf8.decode(response.bodyBytes);
      return regionModelFromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///add order endi ishlatilmaydi
  Future<OrderStatusModel> fetchAddOrder(AddOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    if (lan == null) {
      lan = "ru";
    }

    String url = Utils.baseUrl + '/api/v1/add-order?lan=$lan&region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(order))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return OrderStatusModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///History
  Future<HistoryModel> fetchOrderHistory(int page, int perPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int regionId = prefs.getInt("cityId");
    String lan = prefs.getString('language');
    if (lan == null) {
      lan = "ru";
    }
    String url = Utils.baseUrl +
        '/api/v1/orders?'
            'page=$page&'
            'per_page=$perPage&'
            'lan=$lan&'
            'region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return HistoryModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///Cancel order
  Future<CancelOrder> fetchCancelOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int regionId = prefs.getInt("cityId");
    String lan = prefs.getString('language');
    if (lan == null) {
      lan = "ru";
    }
    String url = Utils.baseUrl +
        '/api/v1/order-cancel?'
            'lan=$lan&'
            'region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    final msg = jsonEncode({
      "order": orderId.toString(),
    });

    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: msg,
            headers: headers,
          )
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CancelOrder.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  /// Filter parametrs
  Future<FilterModel> fetchFilterParameters(
    int page,
    int perPage,
    int filterType,
    String search,
    int type,
    String id,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String filter = type == 1
        ? "&category_id=$id"
        : type == 2
            ? "&is_home=1"
            : type == 3
                ? "&name=$id"
                : type == 4
                    ? "&ids=$id"
                    : "";

    String url = filterType == 1
        ? Utils.baseUrl +
            '/api/v1/units?page=$page&per_page=$perPage&search=$search$filter'
        : filterType == 2
            ? Utils.baseUrl +
                '/api/v1/manufacturers?page=$page&per_page=$perPage&search=$search$filter'
            : Utils.baseUrl +
                '/api/v1/international-names?page=$page&per_page=$perPage&search=$search$filter';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return FilterModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  /// Order options
  Future<OrderOptionsModel> fetchOrderOptions(String lan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int regionId = prefs.getInt("cityId");

    String url =
        Utils.baseUrl + '/api/v1/order-options?lan=$lan&region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return OrderOptionsModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///Exist store
  Future<List<LocationModel>> fetchAccessApteka(AccessStore accessStore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/exists-stores?region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url),
              body: json.encode(accessStore), headers: headers)
          .timeout(duration);
      var responseJson = utf8.decode(response.bodyBytes);

      return locationModelFromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///get all message
  Future<ChatApiModel> fetchGetAppMessage(int page, int perPage) async {
    String url =
        Utils.baseUrl + '/api/v1/chat/messages?page=$page&per_page=$perPage';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return ChatApiModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///sent message
  Future<LoginModel> fetchSentMessage(String message) async {
    String url = Utils.baseUrl + '/api/v1/chat/send-message';

    final data = {"message": message};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'X-Device': encoded,
    };
    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: data)
          .timeout(duration);
      final Map parsed = json.decode(response.body);

      return LoginModel.fromJson(parsed);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///Min sum
  Future<int> fetchMinSum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/order-minimum?region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json; charset=utf-8');
    request.headers.set('X-Device', encoded);
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);

    return MinSum.fromJson(parsed).min;
  }

  ///Check error pickup
  Future<CheckErrorModel> fetchCheckErrorPickup(
      AccessStore accessStore, String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url =
        Utils.baseUrl + '/api/v1/check-error?lan=$language&region=$regionId';
    String token = prefs.getString("token");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response = await http
          .post(Uri.parse(url),
              headers: headers, body: json.encode(accessStore))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CheckErrorModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    }
  }

  ///Check error delivery
  Future<CheckErrorModel> fetchCheckErrorDelivery(
      AccessStore accessStore, String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/check-shipping-error?lan=$language&region=$regionId';
    String token = prefs.getString("token");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url),
              headers: headers, body: json.encode(accessStore))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CheckErrorModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    }
  }

  ///payment verify token
  Future<PaymentVerfy> fetchVerfyPaymentModel(VerdyPaymentModel verfy) async {
    String url = Utils.baseUrl + '/api/v1/verify-token';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(verfy))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return PaymentVerfy.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return PaymentVerfy(
          errorCode: -1, errorNote: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return PaymentVerfy(
          errorCode: -1, errorNote: translate("internet_error"));
    }
  }

  ///check version
  Future<CheckVersion> fetchCheckVersion(String version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final data = {
      "version": version,
      "device": Platform.isIOS ? "ios" : "android"
    };
    String lan = prefs.getString('language') ?? "ru";
    String url = Utils.baseUrl + '/api/v1/check-version?lan=$lan';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = token == null
        ? {
            'X-Device': encoded,
          }
        : {
            'X-Device': encoded,
            HttpHeaders.authorizationHeader: "Bearer $token",
          };

    http.Response response = await http
        .post(Uri.parse(url), body: data, headers: headers)
        .timeout(duration);

    final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

    return CheckVersion.fromJson(responseJson);
  }

  ///send rating
  Future<CheckVersion> fetchSendRating(String comment, int rating) async {
    String url = Utils.baseUrl + '/api/v1/send-review';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";
    Map<String, String> headers;
    if (token == null) {
      headers = {
        'content-type': 'application/json; charset=utf-8',
        'X-Device': encoded,
      };
    } else {
      headers = {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'content-type': 'application/json; charset=utf-8',
        'X-Device': encoded,
      };
    }
    final data = {"comment": comment, "rating": rating.toString()};
    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(data))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CheckVersion.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckVersion();
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckVersion();
    }
  }

  ///get-no-reviews
  // ignore: missing_return
  Future<GetReviewModel> fetchGetNoReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/get-no-reviews?region=$regionId';
    String token = prefs.getString("token");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";
    if (token != null) {
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'content-type': 'application/json; charset=utf-8',
        'X-Device': encoded,
      };

      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);

      final Map parsed = json.decode(response.body);
      return GetReviewModel.fromJson(parsed);
    }
  }

  ///order item review
  Future<CheckVersion> fetchOrderItemReview(
    String comment,
    int rating,
    int orderId,
  ) async {
    String url = Utils.baseUrl + '/api/v1/send-order-reviews';

    final data = {"review": comment, "rating": rating, "order_id": orderId};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(data))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CheckVersion.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckVersion();
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckVersion();
    }
  }

  /// Cash back
  Future<CashBackModel> fetchCashBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/user-cashback?region=$regionId';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";
    String token = prefs.getString("token");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    http.Response response =
        await http.get(Uri.parse(url), headers: headers).timeout(duration);
    final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

    return CashBackModel.fromJson(responseJson);
  }

  /// FAQ
  Future<List<FaqModel>> fetchFAQ() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";
    if (lan == null) {
      lan = "ru";
    }
    String url = Utils.baseUrl + '/api/v1/faq?lan=$lan&region=$regionId';
    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      return faqModelFromJson(utf8.decode(response.bodyBytes));
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  Future<CurrentLocationAddressModel> fetchLocationAddress(
      double lat, double lng) async {
    String url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=b4985736-e176-472f-af14-36678b5d6aaa&geocode=$lng,$lat&format=json';

    try {
      http.Response response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return CurrentLocationAddressModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }

  ///create order
  Future<CreateOrderStatusModel> fetchCreateOrder(
      CreateOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    if (lan == null) {
      lan = "ru";
    }

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    String url =
        Utils.baseUrl + '/api/v1/create-order?lan=$lan&region=$regionId';

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(order))
          .timeout(duration);

      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return CreateOrderStatusModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CreateOrderStatusModel(
          status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CreateOrderStatusModel(
          status: -1, msg: translate("internet_error"));
    }
  }

  ///check order
  Future<CheckOrderModelNew> fetchCheckOrder(CreateOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    if (lan == null) {
      lan = "ru";
    }

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    String url =
        Utils.baseUrl + '/api/v1/check-order?lan=$lan&region=$regionId';

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(order))
          .timeout(duration);

      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return CheckOrderModelNew.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckOrderModelNew(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckOrderModelNew(status: -1, msg: translate("internet_error"));
    }
  }

  ///Payment
  Future<OrderStatusModel> fetchPayment(PaymentOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    if (lan == null) {
      lan = "ru";
    }

    String url =
        Utils.baseUrl + '/api/v1/activate-order?lan=$lan&region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(order))
          .timeout(duration);

      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return OrderStatusModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///set location to region
  Future<OrderStatusModel> fetchGetRegion(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    if (lan == null) {
      lan = "ru";
    }

    final data = {
      "location": location,
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    String url = Utils.baseUrl + '/api/v1/check-region-polygon?lan=$lan';

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(data))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return OrderStatusModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///add region
  Future<OrderStatusModel> fetchAddRegion(int regionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    String token = prefs.getString("token");
    if (lan == null) {
      lan = "ru";
    }

    final data = {
      "region": regionId.toString(),
    };
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    String url = Utils.baseUrl + '/api/v1/add-region?lan=$lan';
    if (token != null) {
      try {
        Map<String, String> headers = {
          'content-type': 'application/json; charset=utf-8',
          HttpHeaders.authorizationHeader: "Bearer $token",
          'X-Device': encoded,
        };
        http.Response response = await http
            .post(Uri.parse(url), headers: headers, body: json.encode(data))
            .timeout(duration);
        final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

        return OrderStatusModel.fromJson(responseJson);
      } on TimeoutException catch (_) {
        RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
        return OrderStatusModel(status: -1, msg: translate("internet_error"));
      } on SocketException catch (_) {
        RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
        return OrderStatusModel(status: -1, msg: translate("internet_error"));
      }
    } else {
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }
}
