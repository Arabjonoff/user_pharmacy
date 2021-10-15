import 'dart:convert';

CashBackModel cashBackModelFromJson(String str) =>
    CashBackModel.fromJson(json.decode(str));

class CashBackModel {
  CashBackModel({
    this.status,
    this.cash,
    this.ball,
  });

  int status;
  double cash;
  int ball;

  factory CashBackModel.fromJson(Map<String, dynamic> json) => CashBackModel(
        status: json["status"],
        cash: json["cash"] == null ? 0.0 : json["cash"].toDouble(),
        ball: json["ball"] ?? 0,
      );
}
