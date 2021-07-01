class OrderStatusModel {
  int status;
  String msg;
  String paymentRedirectUrl;
  int region;

  OrderStatusModel({
    this.status,
    this.msg,
    this.region,
    this.paymentRedirectUrl,
  });

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    region = json['region'] ?? 0;
    msg = json['msg'] ?? "";
    paymentRedirectUrl = json['payment_redirect_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['region'] = this.region;
    data['msg'] = this.msg;
    data['payment_redirect_url'] = this.paymentRedirectUrl;
    return data;
  }
}
