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
  });

  int error;
  String msg;
  List<CheckErroData> errors;

  factory CheckErrorModel.fromJson(Map<String, dynamic> json) =>
      CheckErrorModel(
        error: json["error"],
        msg: json["msg"],
        errors: List<CheckErroData>.from(json["errors"].map((x) => CheckErroData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
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
