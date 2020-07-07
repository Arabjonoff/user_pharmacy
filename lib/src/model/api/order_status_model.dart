class OrderStatusModel {
  int status;
  String msg;
  String data;

  OrderStatusModel({this.status, this.msg, this.data});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}

class Data {
  int error;
  String shopTransactionId;
  String octoPaymentUUID;
  String status;
  String octoPayUrl;

  Data(
      {this.error,
      this.shopTransactionId,
      this.octoPaymentUUID,
      this.status,
      this.octoPayUrl});

  Data.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    shopTransactionId = json['shop_transaction_id'];
    octoPaymentUUID = json['octo_payment_UUID'];
    status = json['status'];
    octoPayUrl = json['octo_pay_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['shop_transaction_id'] = this.shopTransactionId;
    data['octo_payment_UUID'] = this.octoPaymentUUID;
    data['status'] = this.status;
    data['octo_pay_url'] = this.octoPayUrl;
    return data;
  }
}
