class PaymentOrderModel {
  int paymentType;
  int orderId;
  int cashPay;
  bool paymentRedirect;

  PaymentOrderModel({
    this.orderId,
    this.paymentType,
    this.cashPay,
    this.paymentRedirect,
  });

  PaymentOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    cashPay = json['cash_pay'];
    paymentType = json['payment_type'];
    paymentRedirect = json['payment_redirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['cash_pay'] = this.cashPay;
    data['payment_type'] = this.paymentType;
    data['payment_redirect'] = this.paymentRedirect;
    return data;
  }
}
