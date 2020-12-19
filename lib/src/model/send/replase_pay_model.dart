class ReplacePayModel {
  int orderId;
  int paymentType;
  String cardPan;
  String cardExp;
  int cardSave;
  String cardToken;

  ReplacePayModel({
    this.orderId,
    this.paymentType,
    this.cardPan,
    this.cardExp,
    this.cardSave,
    this.cardToken,
  });

  ReplacePayModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    paymentType = json['payment_type'];
    cardPan = json['card_pan'];
    cardExp = json['card_exp'];
    cardSave = json['card_save'];
    cardToken = json['card_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['payment_type'] = this.paymentType;
    data['card_pan'] = this.cardPan;
    data['card_exp'] = this.cardExp;
    data['card_save'] = this.cardSave;
    data['card_token'] = this.cardToken;

    return data;
  }
}
