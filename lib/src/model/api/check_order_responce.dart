class CheckOrderResponceModel {
  int status;
  String msg;
  Data data;

  CheckOrderResponceModel({this.status, this.msg, this.data});

  CheckOrderResponceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['error'] == null ? "" : json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  double distance;
  double deliverySum;
  String address;
  bool isUserPay;
  double total;

  Data(
      {this.distance,
      this.deliverySum,
      this.address,
      this.isUserPay,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    deliverySum = json['delivery_sum'];
    address = json['address'];
    isUserPay = json['is_user_pay'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['delivery_sum'] = this.deliverySum;
    data['address'] = this.address;
    data['is_user_pay'] = this.isUserPay;
    data['total'] = this.total;
    return data;
  }
}
