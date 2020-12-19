class AddOrderModel {
  String address;
  String location;
  String type;
  String fullName;
  String phone;
  int shippingTime;
  int paymentType;
  int storeId;
  int cashPay;
  String cardPan;
  String cardExp;
  int cardSave;
  String cardToken;
  String phoneNumber;
  String device;
  List<Drugs> drugs;

  AddOrderModel({
    this.address,
    this.location,
    this.type,
    this.fullName,
    this.phone,
    this.shippingTime,
    this.device,
    this.paymentType,
    this.storeId,
    this.cashPay,
    this.drugs,
    this.cardPan,
    this.cardExp,
    this.cardSave,
    this.phoneNumber,
    this.cardToken,
  });

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'];
    type = json['type'];
    cashPay = json['cash_pay'];
    device = json['device'];
    fullName = json['full_name'];
    phone = json['phone'];
    shippingTime = json['shipping_time'];
    paymentType = json['payment_type'];
    storeId = json['store_id'];
    cardPan = json['card_pan'];
    cardExp = json['card_exp'];
    cardSave = json['card_save'];
    cardToken = json['card_token'];
    phoneNumber = json['phone_number'];
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
    data['cash_pay'] = this.cashPay;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['store_id'] = this.storeId;
    data['payment_type'] = this.paymentType;
    data['shipping_time'] = this.shippingTime;
    data['card_pan'] = this.cardPan;
    data['card_exp'] = this.cardExp;
    data['card_save'] = this.cardSave;
    data['card_token'] = this.cardToken;
    data['phone_number'] = this.phoneNumber;
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
