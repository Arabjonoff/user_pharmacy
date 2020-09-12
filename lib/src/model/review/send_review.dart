

import 'dart:convert';

SendReviewModel sedReviewModelFromJson(String str) => SendReviewModel.fromJson(json.decode(str));

String sedReviewModelToJson(SendReviewModel data) => json.encode(data.toJson());

class SendReviewModel {
  SendReviewModel({
    this.review,
    this.rating,
    this.orderId,
  });

  String review;
  int rating;
  int orderId;

  factory SendReviewModel.fromJson(Map<String, dynamic> json) => SendReviewModel(
    review: json["review"],
    rating: json["rating"],
    orderId: json["order_id"],
  );

  Map<String, dynamic> toJson() => {
    "review": review,
    "rating": rating,
    "order_id": orderId,
  };
}
