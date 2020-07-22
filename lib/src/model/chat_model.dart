import 'dart:convert';

List<ChatModel> regionModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String regionModelToJson(List<ChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  ChatModel({
    this.id,
    this.message,
    this.userId,
    this.month,
    this.day,
    this.time,
  });

  int id;
  String message;
  int userId;
  int month;
  int day;
  String time;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        message: json["message"],
        userId: json["userId"],
        day: json["day"],
        month: json["month"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "userId": userId,
        "month": month,
        "day": day,
        "time": time,
      };
}
