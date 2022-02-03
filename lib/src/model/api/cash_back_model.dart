import 'dart:convert';

CashBackModel cashBackModelFromJson(String str) =>
    CashBackModel.fromJson(json.decode(str));

class CashBackModel {
  CashBackModel({
    required this.status,
    required this.cash,
    required this.bonus,
  });

  int status;
  double cash;
  int bonus;

  factory CashBackModel.fromJson(Map<String, dynamic> json) => CashBackModel(
        status: json["status"] ?? 0,
        cash: json["cash"] ?? "",
        bonus: json["bonus"] ?? 0,
      );
}
