class AddOrderModel {
  String address;
  String location;
  String type;
  String full_name;
  String phone;
  int shipping_time;
  int payment_type;
  int store_id;
  int cash_pay;
  String card_pan;
  String card_exp;
  int card_save;
  String card_token;
  String phone_number;
  String device;
  List<Drugs> drugs;

  AddOrderModel(
      {this.address,
      this.location,
      this.type,
      this.full_name,
      this.phone,
      this.shipping_time,
      this.device,
      this.payment_type,
      this.store_id,
      this.cash_pay,
      this.drugs,
      this.card_pan,
      this.card_exp,
      this.card_save,
      this.phone_number,
      this.card_token});

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'];
    type = json['type'];
    cash_pay = json['cash_pay'];
    device = json['device'];
    full_name = json['full_name'];
    phone = json['phone'];
    shipping_time = json['shipping_time'];
    payment_type = json['payment_type'];
    store_id = json['store_id'];
    card_pan = json['card_pan'];
    card_exp = json['card_exp'];
    card_save = json['card_save'];
    card_token = json['card_token'];
    phone_number = json['phone_number'];
    if (json['drugs'] != null) {
      drugs = new List<Drugs>();
      json['drugs'].forEach((v) {
        drugs.add(new Drugs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['location'] = this.location;
    data['type'] = this.type;
    data['device'] = this.device;
    data['cash_pay'] = this.cash_pay;
    data['full_name'] = this.full_name;
    data['phone'] = this.phone;
    data['store_id'] = this.store_id;
    data['payment_type'] = this.payment_type;
    data['shipping_time'] = this.shipping_time;
    data['card_pan'] = this.card_pan;
    data['card_exp'] = this.card_exp;
    data['card_save'] = this.card_save;
    data['card_token'] = this.card_token;
    data['phone_number'] = this.phone_number;
    data['drugs'] = this.drugs.map((v) => v.toJson()).toList();

    return data;
  }
}

class Drugs {
  int drug;
  int qty;

  Drugs({this.drug, this.qty});

  Drugs.fromJson(Map<String, dynamic> json) {
    drug = json['drug'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drug'] = this.drug;
    data['qty'] = this.qty;
    return data;
  }
}
