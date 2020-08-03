class ReplacePayModel {
  int order_id;
  int payment_type;
  String card_pan;
  String card_exp;
  int card_save;
  String card_token;

  ReplacePayModel(
      {this.order_id,
      this.payment_type,
      this.card_pan,
      this.card_exp,
      this.card_save,
      this.card_token});

  ReplacePayModel.fromJson(Map<String, dynamic> json) {
    order_id = json['order_id'];
    payment_type = json['payment_type'];
    card_pan = json['card_pan'];
    card_exp = json['card_exp'];
    card_save = json['card_save'];
    card_token = json['card_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.order_id;
    data['payment_type'] = this.payment_type;
    data['card_pan'] = this.card_pan;
    data['card_exp'] = this.card_exp;
    data['card_save'] = this.card_save;
    data['card_token'] = this.card_token;

    return data;
  }
}
