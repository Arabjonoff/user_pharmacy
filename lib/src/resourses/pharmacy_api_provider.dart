import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/auth/verfy_model.dart';
import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/chech_error.dart';
import 'package:pharmacy/src/model/api/check_order_responce.dart';
import 'package:pharmacy/src/model/api/check_version.dart';
import 'package:pharmacy/src/model/api/faq_model.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/api/min_sum.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/model/payment_verfy.dart';
import 'package:pharmacy/src/model/review/get_review.dart';
import 'package:pharmacy/src/model/review/send_all_review.dart';
import 'package:pharmacy/src/model/review/send_review.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/model/send/check_order.dart';
import 'package:pharmacy/src/model/send/verfy_payment_model.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyApiProvider {
  HttpClient httpClient = new HttpClient();

  ///Login
  Future<LoginModel> fetchLogin(String login) async {
    String url = Utils.BASE_URL + '/api/v1/register';

    final data = {
      "login": login,
    };

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
    };

    try {
      http.Response response = await http
          .post(url, headers: headers, body: json.encode(data))
          .timeout(const Duration(seconds: 10));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return LoginModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return LoginModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return LoginModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///verfy
  Future<VerfyModel> fetchVerfy(String login, String code, String token) async {
    String url = Utils.BASE_URL + '/api/v1/accept';

    final data = {
      "login": login,
      "smscode": code,
      "device_token": token,
    };

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
    };
    try {
      http.Response response = await http
          .post(url, headers: headers, body: json.encode(data))
          .timeout(const Duration(seconds: 20));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return VerfyModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return VerfyModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return VerfyModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///Register
  Future<LoginModel> fetchRegister(String name, String surname, String birthday,
      String gender, String token) async {
    String url = Utils.BASE_URL + '/api/v1/register-profil';

    final data = {
      "first_name": name,
      "last_name": surname,
      "gender": gender,
      "birth_date": birthday,
    };

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    try {
      http.Response response = await http
          .post(url, headers: headers, body: data)
          .timeout(const Duration(seconds: 15));
      final Map parsed = json.decode(response.body);
      return LoginModel.fromJson(parsed);
    } on TimeoutException catch (_) {
      return LoginModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return LoginModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///Sale
  Future<SaleModel> fetchSaleList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL + '/api/v1/sales?region=$regionId';

    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return SaleModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return SaleModel();
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return SaleModel();
    }
  }

  ///best items
  Future<ItemModel> fetchBestItemList(
    int page,
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'is_home=1&'
            'page=$page&'
            'region=$regionId&'
            'per_page=$per_page&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';
    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return ItemModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return ItemModel();
    } on SocketException catch (_) {
      return ItemModel();
    }
  }

  ///category
  Future<CategoryModel> fetchCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL + '/api/v1/categories?region=$regionId';
    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
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
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$per_page&'
            'category=$id&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';

    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
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

  ///category's by item
  Future<ItemModel> fetchIdsItemsList(
    String id,
    int page,
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$per_page&'
            'ids=$id&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///search's by item
  Future<ItemModel> fetchSearchItemsList(
    String obj,
    int page,
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$per_page&'
            'search=$obj&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';
    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
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
    if (regionId == null) {
      regionId = 1;
    }

    String url = Utils.BASE_URL + '/api/v1/drugs/$id?region=$regionId';

    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));

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
    String url = Utils.BASE_URL + '/api/v1/stores?lat=$lat&lng=$lng';
    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
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
    String url = Utils.BASE_URL + '/api/v1/regions?search=' + obj;

    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
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

  ///add order
  Future<OrderStatusModel> fetchAddOrder(AddOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');

    if (lan == null) {
      lan = "uz";
    }

    String url = Utils.BASE_URL + '/api/v1/add-order?lan=$lan';

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json'
    };

    try {
      http.Response response = await http
          .post(url, headers: headers, body: json.encode(order))
          .timeout(const Duration(seconds: 15));
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

  ///add order
  Future<HistoryModel> fetchOrderHistory(int page, int per_page) async {
    String url =
        Utils.BASE_URL + '/api/v1/orders?page=$page&per_page=$per_page';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    try {
      http.Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
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

  /// Filter parametrs
  Future<FilterModel> fetchFilterParametrs(
      int page, int per_page, int type) async {
    String url = type == 1
        ? Utils.BASE_URL + '/api/v1/units?page=$page&per_page=$per_page'
        : type == 2
            ? Utils.BASE_URL +
                '/api/v1/manufacturers?page=$page&per_page=$per_page'
            : Utils.BASE_URL +
                '/api/v1/international-names?page=$page&per_page=$per_page';

    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 10));
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

  /// Filter parametrs
  Future<OrderOptionsModel> fetchOrderOptions(String lan) async {
    String url = Utils.BASE_URL + '/api/v1/order-options?lan=$lan';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    try {
      http.Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
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

  /// Check order
  Future<CheckOrderResponceModel> fetchCheckOrder(CheckOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');

    if (lan == null) {
      lan = "uz";
    }

    String url = Utils.BASE_URL + '/api/v1/check-order?lan=$lan';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(order));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return CheckOrderResponceModel.fromJson(parsed);
  }

  ///items
  Future<List<LocationModel>> fetchAccessApteka(AccessStore accessStore) async {
    String url = Utils.BASE_URL + '/api/v1/exists-stores';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.write(json.encode(accessStore));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    return locationModelFromJson(reply);
  }

  ///reload payment
  Future<OrderStatusModel> fetchOrderPayment(String id) async {
    String url = Utils.BASE_URL + '/api/v1/order-payment';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    final data = {"order_id": id};

    http.Response response = await http
        .post(url, headers: headers, body: data)
        .timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return OrderStatusModel.fromJson(parsed);
  }

  ///get all message
  Future<ChatApiModel> fetchGetAppMessage(int page, int per_page) async {
    String url =
        Utils.BASE_URL + '/api/v1/chat/messages?page=$page&per_page=$per_page';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    try {
      http.Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return ChatApiModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }

  ///sent message
  Future<LoginModel> fetchSentMessage(String message) async {
    String url = Utils.BASE_URL + '/api/v1/chat/send-message';

    final data = {"message": message};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    http.Response response = await http
        .post(url, headers: headers, body: data)
        .timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return LoginModel.fromJson(parsed);
  }

  ///Min sum
  Future<int> fetchMinSum() async {
    String url = Utils.BASE_URL + '/api/v1/order-minimum';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);

    return MinSum.fromJson(parsed).min;
  }

  ///Check error pickup
  Future<CheckErrorModel> fetchCheckErrorPickup(
      AccessStore accessStore, String language) async {
    String url = Utils.BASE_URL + '/api/v1/check-error?lan=$language';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
    };
    try {
      http.Response response = await http
          .post(url, headers: headers, body: json.encode(accessStore))
          .timeout(const Duration(seconds: 10));
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
    String url = Utils.BASE_URL + '/api/v1/check-shipping-error?lan=$language';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
    };

    try {
      http.Response response = await http
          .post(url, headers: headers, body: json.encode(accessStore))
          .timeout(const Duration(seconds: 10));
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CheckErrorModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    }
  }

  ///items
  Future<PaymentVerfy> fetchVerfyPaymentModel(VerdyPaymentModel verfy) async {
    String url = Utils.BASE_URL + '/api/v1/verify-token';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(verfy));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);
    return PaymentVerfy.fromJson(parsed);
  }

  ///items
  Future<CheckVersion> fetchCheckVersion(String version) async {
    String url = Utils.BASE_URL + '/api/v1/check-version';

    final data = {"version": version};

    http.Response response =
        await http.post(url, body: data).timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return CheckVersion.fromJson(parsed);
  }

  ///items
  Future<CheckVersion> fetchSendRating(String comment, int rating) async {
    String url = Utils.BASE_URL + '/api/v1/send-review';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    final data = {"comment": comment, "rating": rating};

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json; charset=utf-8');
    if (token != null)
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(data));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);
    return CheckVersion.fromJson(parsed);
  }

  ///get-no-reviews
  Future<GetReviewModel> fetchGetNoReview() async {
    String url = Utils.BASE_URL + '/api/v1/get-no-reviews';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    if (token != null) {
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "Bearer $token",
      };

      http.Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 120));

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
    String url = Utils.BASE_URL + '/api/v1/send-order-reviews';

    final data = {"review": comment, "rating": rating, "order_id": orderId};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json; charset=utf-8');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(data));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);
    return CheckVersion.fromJson(parsed);
  }

  /// Cash back
  Future<CashBackModel> fetchCashBack() async {
    String url = Utils.BASE_URL + '/api/v1/user-cashback';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
    };
    http.Response response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 10));
    final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

    return CashBackModel.fromJson(responseJson);
  }

  /// FAQ
  Future<List<FaqModel>> fetchFAQ() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');

    if (lan == null) {
      lan = "uz";
    }
    String url = Utils.BASE_URL + '/api/v1/faq?lan=$lan';
    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
    };
    http.Response response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 10));

    return faqModelFromJson(utf8.decode(response.bodyBytes));
  }
}
