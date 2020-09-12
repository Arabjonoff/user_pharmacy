import 'dart:convert';

GetReviewModel getReviewModelFromJson(String str) => GetReviewModel.fromJson(json.decode(str));

String getReviewModelToJson(GetReviewModel data) => json.encode(data.toJson());

class GetReviewModel {
  GetReviewModel({
    this.status,
    this.data,
  });

  int status;
  List<int> data;

  factory GetReviewModel.fromJson(Map<String, dynamic> json) => GetReviewModel(
    status: json["status"],
    data: List<int>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
