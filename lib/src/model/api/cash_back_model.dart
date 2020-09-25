import 'dart:convert';

CashBackModel cashBackModelFromJson(String str) =>
    CashBackModel.fromJson(json.decode(str));

String cashBackModelToJson(CashBackModel data) => json.encode(data.toJson());

class CashBackModel {
  CashBackModel({
    this.status,
    this.cash,
  });

  int status;
  double cash;

  factory CashBackModel.fromJson(Map<String, dynamic> json) => CashBackModel(
        status: json["status"],
        cash: json["cash"] == null ? 0.0 : json["cash"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cash": cash,
      };
}
