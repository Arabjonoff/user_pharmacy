class SocketModel {
  String type;
  String event;
  Message message;

  SocketModel({this.type, this.event, this.message});

  SocketModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    event = json['event'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['event'] = this.event;
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    return data;
  }
}

class Message {
  int id;
  int userId;
  String body;
  String createdAt;
  String updatedAt;

  Message({
    this.id,
    this.userId,
    this.body,
    this.createdAt,
    this.updatedAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
