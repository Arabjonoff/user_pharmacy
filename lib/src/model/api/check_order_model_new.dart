class CheckOrderModelNew {
  int status;
  String msg;
  Data data;

  CheckOrderModelNew({this.status, this.msg, this.data});

  CheckOrderModelNew.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 1;
    msg = json['msg'] ?? "";
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Stores> stores;

  Data({
    this.stores,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores.add(new Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stores != null) {
      data['stores'] = this.stores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  int id;
  String name;
  String address;
  double distance;
  double deliverySum;
  double total;
  String text;

  Stores({
    this.id,
    this.name,
    this.address,
    this.distance,
    this.deliverySum,
    this.total,
    this.text,
  });

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    address = json['address'] ?? "";
    distance = json['distance'] ?? 0.0;
    deliverySum = json['delivery_sum'] ?? 0.0;
    total = json['total'] ?? 0.0;
    text = json['text'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['distance'] = this.distance;
    data['delivery_sum'] = this.deliverySum;
    data['total'] = this.total;
    data['text'] = this.text;
    return data;
  }
}
