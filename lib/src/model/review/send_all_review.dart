import 'dart:convert';

SendAllReviewModel sedReviewModelFromJson(String str) =>
    SendAllReviewModel.fromJson(json.decode(str));

String sedReviewModelToJson(SendAllReviewModel data) =>
    json.encode(data.toJson());

class SendAllReviewModel {
  SendAllReviewModel({
    this.comment,
    this.rating,
  });

  String comment;
  int rating;

  factory SendAllReviewModel.fromJson(Map<String, dynamic> json) =>
      SendAllReviewModel(
        comment: json["comment"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "rating": rating,
      };
}
