import 'dart:convert';

CheckErrorModel chechErrorModelFromJson(String str) =>
    CheckErrorModel.fromJson(json.decode(str));

String chechErrorModelToJson(CheckErrorModel data) =>
    json.encode(data.toJson());

class CheckErrorModel {
  CheckErrorModel({
    this.error,
    this.msg,
    this.errors,
    this.data,
  });

  int error;
  String msg;
  List<CheckErroData> errors;
  CashBackData data;

  factory CheckErrorModel.fromJson(Map<String, dynamic> json) =>
      CheckErrorModel(
        error: json["error"],
        msg: json["msg"],
        data: json["data"] == null ? null : CashBackData.fromJson(json["data"]),
        errors: json["errors"] == null
            ? null
            : List<CheckErroData>.from(
                json["errors"].map((x) => CheckErroData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "data": data.toJson(),
        "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
      };
}

class CheckErroData {
  CheckErroData({
    this.drugId,
    this.msg,
  });

  int drugId;
  String msg;

  factory CheckErroData.fromJson(Map<String, dynamic> json) => CheckErroData(
        drugId: json["drug_id"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "drug_id": drugId,
        "msg": msg,
      };
}

class CashBackData {
  CashBackData({
    this.total,
    this.cash,
    this.isTotalCash,
  });

  double total;
  double cash;
  bool isTotalCash;

  factory CashBackData.fromJson(Map<String, dynamic> json) => CashBackData(
        total: json["total"] == null ? 0.0 : json["total"].toDouble(),
        cash: json["cash"] == null ? 0.0 : json["cash"].toDouble(),
        isTotalCash: json["is_total_cash"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "cash": cash,
        "is_total_cash": isTotalCash,
      };
}
