import 'dart:async';

import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/database/database_helper_note.dart';
import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/chech_error.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/auth/verfy_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/check_order_responce.dart';
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
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/create_order_status_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/model/payment_verfy.dart';
import 'package:pharmacy/src/model/review/get_review.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/model/send/check_order.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/model/send/verfy_payment_model.dart';

import 'pharmacy_api_provider.dart';

class Repository {
  final pharmacyApiProvider = PharmacyApiProvider();

  DatabaseHelper databaseHelper = new DatabaseHelper();
  DatabaseHelperNote databaseHelperNote = new DatabaseHelperNote();
  DatabaseHelperApteka dbApteka = new DatabaseHelperApteka();

  Future<LoginModel> fetchLogin(String login) =>
      pharmacyApiProvider.fetchLogin(login);

  Future<VerfyModel> fetchVetfy(String login, String code, String token) =>
      pharmacyApiProvider.fetchVerfy(login, code, token);

  Future<LoginModel> fetchRegister(String name, String surname, String birthday,
          String gender, String token) =>
      pharmacyApiProvider.fetchRegister(name, surname, birthday, gender, token);

  Future<SaleModel> fetchAllSales() => pharmacyApiProvider.fetchSaleList();

  Future<ItemModel> fetchBestItem(
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) =>
      pharmacyApiProvider.fetchBestItemList(
        page,
        20,
        international_name_ids,
        manufacturer_ids,
        ordering,
        price_max,
        price_min,
        unit_ids,
      );

  Future<CategoryModel> fetchCategoryItem() =>
      pharmacyApiProvider.fetchCategoryList();

  Future<List<ItemResult>> databaseItem() => databaseHelper.getProduct();

  Future<List<NoteModel>> databaseNote() => databaseHelperNote.getProduct();

  Future<List<AptekaModel>> dbAptekaItems() => dbApteka.getProduct();

  Future<List<ItemResult>> databaseCardItem(bool isCard) =>
      databaseHelper.getProdu(isCard);

  Future<ItemModel> fetchCategryItemList(
    String id,
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) =>
      pharmacyApiProvider.fetchCategoryItemsList(
        id,
        page,
        20,
        international_name_ids,
        manufacturer_ids,
        ordering,
        price_max,
        price_min,
        unit_ids,
      );

  Future<ItemModel> fetchIdsItemsList(
    String id,
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) =>
      pharmacyApiProvider.fetchIdsItemsList(
        id,
        page,
        20,
        international_name_ids,
        manufacturer_ids,
        ordering,
        price_max,
        price_min,
        unit_ids,
      );

  Future<ItemModel> fetchSearchItemList(
    String obj,
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) =>
      pharmacyApiProvider.fetchSearchItemsList(
        obj,
        page,
        20,
        international_name_ids,
        manufacturer_ids,
        ordering,
        price_max,
        price_min,
        unit_ids,
      );

  Future<ItemsAllModel> fetchItems(String id) =>
      pharmacyApiProvider.fetchItems(id);

  Future<List<LocationModel>> fetchApteka(double lat, double lng) =>
      pharmacyApiProvider.fetchApteka(lat, lng);

  Future<List<LocationModel>> fetchAccessApteka(AccessStore accessStore) =>
      pharmacyApiProvider.fetchAccessApteka(accessStore);

  Future<List<RegionModel>> fetchRegions(String obj) =>
      pharmacyApiProvider.fetchRegions(obj);

  Future<OrderStatusModel> fetchRAddOrder(AddOrderModel order) =>
      pharmacyApiProvider.fetchAddOrder(order);

  Future<OrderStatusModel> fetchPayment(PaymentOrderModel order) =>
      pharmacyApiProvider.fetchPayment(order);

  Future<CreateOrderStatusModel> fetchCreateOrder(CreateOrderModel order) =>
      pharmacyApiProvider.fetchCreateOrder(order);

  Future<CheckOrderResponceModel> fetchCheckOrder(CheckOrderModel order) =>
      pharmacyApiProvider.fetchCheckOrder(order);

  Future<HistoryModel> fetchHistory(int page) =>
      pharmacyApiProvider.fetchOrderHistory(page, 20);

  Future<FilterModel> fetchFilterParametrs(int page, int type) =>
      pharmacyApiProvider.fetchFilterParametrs(page, 50, type);

  Future<OrderOptionsModel> fetchOrderOptions(String lan) =>
      pharmacyApiProvider.fetchOrderOptions(lan);

  Future<ChatApiModel> fetchGetAppMessage(int page) =>
      pharmacyApiProvider.fetchGetAppMessage(page, 20);

  Future<LoginModel> fetchSentMessage(String message) =>
      pharmacyApiProvider.fetchSentMessage(message);

  Future<CheckErrorModel> fetchCheckErrorPickup(
          AccessStore accessStore, String language) =>
      pharmacyApiProvider.fetchCheckErrorPickup(accessStore, language);

  Future<CheckErrorModel> fetchCheckErrorDelivery(
          AccessStore accessStore, String language) =>
      pharmacyApiProvider.fetchCheckErrorDelivery(accessStore, language);

  Future<PaymentVerfy> fetchVerfyPaymentModel(VerdyPaymentModel verfy) =>
      pharmacyApiProvider.fetchVerfyPaymentModel(verfy);

  Future<int> fetchMinSum() => pharmacyApiProvider.fetchMinSum();

  Future<CheckVersion> fetchCheckVersion(String version) =>
      pharmacyApiProvider.fetchCheckVersion(version);

  Future<CheckVersion> fetchSendRating(String comment, int rating) =>
      pharmacyApiProvider.fetchSendRating(comment, rating);

  Future<CheckVersion> fetchOrderItemReview(
          String comment, int rating, int orderId) =>
      pharmacyApiProvider.fetchOrderItemReview(comment, rating, orderId);

  Future<GetReviewModel> fetchGetNoReview() =>
      pharmacyApiProvider.fetchGetNoReview();

  Future<CashBackModel> fetchCashBack() => pharmacyApiProvider.fetchCashBack();

  Future<List<FaqModel>> fetchFAQ() => pharmacyApiProvider.fetchFAQ();

  Future<CurrentLocationAddressModel> fetchLocationAddress(
          double lat, double lng) =>
      pharmacyApiProvider.fetchLocationAddress(lat, lng);
}
