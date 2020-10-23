import 'dart:convert';

CreateOrderStatusModel createOrderStatusModelFromJson(String str) =>
    CreateOrderStatusModel.fromJson(json.decode(str));

String createOrderStatusModelToJson(CreateOrderStatusModel data) =>
    json.encode(data.toJson());

class CreateOrderStatusModel {
  CreateOrderStatusModel({
    this.status,
    this.msg,
    this.orderId,
    this.data,
  });

  int status;
  String msg;
  int orderId;
  Data data;

  factory CreateOrderStatusModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderStatusModel(
        status: json["status"],
        msg: json["msg"] == null ? "" : json["msg"],
        orderId: json["order_id"] == null ? 0 : json["order_id"],
        data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "order_id": orderId,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.orderId,
    this.total,
    this.deliverySum,
    this.cash,
    this.startShipping,
    this.isUserPay,
    this.isTotalCash,
  });

  int orderId;
  double total;
  double deliverySum;
  double cash;
  dynamic startShipping;
  bool isUserPay;
  bool isTotalCash;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderId: json["order_id"],
        total: json["total"],
        deliverySum: json["delivery_sum"],
        cash: json["cash"],
        startShipping: json["start_shipping"],
        isUserPay: json["is_user_pay"],
        isTotalCash: json["is_total_cash"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total": total,
        "delivery_sum": deliverySum,
        "cash": cash,
        "start_shipping": startShipping,
        "is_user_pay": isUserPay,
        "is_total_cash": isTotalCash,
      };
}
