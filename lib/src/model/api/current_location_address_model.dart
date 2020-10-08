import 'dart:convert';

CurrentLocationAddressModel currentLocationAddressModelFromJson(String str) =>
    CurrentLocationAddressModel.fromJson(json.decode(str));

String currentLocationAddressModelToJson(CurrentLocationAddressModel data) =>
    json.encode(data.toJson());

class CurrentLocationAddressModel {
  CurrentLocationAddressModel({
    this.results,
    this.status,
  });

  List<Result> results;
  String status;

  factory CurrentLocationAddressModel.fromJson(Map<String, dynamic> json) =>
      CurrentLocationAddressModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class Result {
  Result({
    this.formattedAddress,
  });

  String formattedAddress;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
      };
}
