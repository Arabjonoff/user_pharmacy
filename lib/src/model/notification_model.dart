class NotificationModel {
  Notification notification;
  Data data;

  NotificationModel({this.notification, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Notification {
  String title;
  String body;

  Notification({this.title, this.body});

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

class Data {
  int drug;
  int category;
  List<int> drugs;
  String clickAction;

  Data({this.drug, this.category, this.drugs, this.clickAction});

  Data.fromJson(Map<String, dynamic> json) {
    drug = json['drug'] == null ? 0 : json['drug'];
    category = json['category'] == null ? 0 : json['category'];
    drugs = json['drugs'].cast<int>();
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drug'] = this.drug;
    data['category'] = this.category;
    data['drugs'] = this.drugs;
    data['click_action'] = this.clickAction;
    return data;
  }
}
