import 'dart:convert';

CashBackModel cashBackModelFromJson(String str) =>
    CashBackModel.fromJson(json.decode(str));

class CashBackModel {
  CashBackModel({
    this.status,
    this.cash,
    this.bonus,
  });

  int status;
  double cash;
  int bonus;

  factory CashBackModel.fromJson(Map<String, dynamic> json) => CashBackModel(
        status: json["status"],
        cash: json["cash"] == null ? 0.0 : json["cash"].toDouble(),
        bonus: json["bonus"] ?? 0,
      );
}
