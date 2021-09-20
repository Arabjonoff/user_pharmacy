class OrderOptionsModel {
  List<ShippingTimes> shippingTimes;
  List<PaymentTypes> paymentTypes;

  OrderOptionsModel({this.shippingTimes, this.paymentTypes});

  OrderOptionsModel.fromJson(Map<String, dynamic> json) {
    if (json['shipping_times'] != null) {
      shippingTimes = <ShippingTimes>[];
      json['shipping_times'].forEach((v) {
        shippingTimes.add(new ShippingTimes.fromJson(v));
      });
    }
    if (json['payment_types'] != null) {
      paymentTypes = <PaymentTypes>[];
      json['payment_types'].forEach((v) {
        paymentTypes.add(new PaymentTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingTimes != null) {
      data['shipping_times'] =
          this.shippingTimes.map((v) => v.toJson()).toList();
    }
    if (this.paymentTypes != null) {
      data['payment_types'] = this.paymentTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingTimes {
  int id;
  String name;
  double price;
  int time;
  bool isUserPay;
  List<String> descriptions;

  ShippingTimes({
    this.id,
    this.name,
    this.price,
    this.time,
    this.isUserPay,
    this.descriptions,
  });

  ShippingTimes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
    price = json['price'] == null ? 0.0 : json['price'];
    time = json['time'];
    isUserPay = json['is_user_pay'];
    descriptions = json['descriptions'] == null
        ? null
        : List<String>.from(json["descriptions"].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['time'] = this.time;
    data['is_user_pay'] = this.isUserPay;
    data['descriptions'] = List<dynamic>.from(descriptions.map((x) => x));
    return data;
  }
}

class PaymentTypes {
  int id;
  int cardId;
  String name;
  String cardToken;
  String pan;
  String type;

  PaymentTypes({
    this.id,
    this.cardId,
    this.cardToken,
    this.name,
    this.pan,
    this.type,
  });

  PaymentTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardId = json['card_id'];
    cardToken = json['card_token'];
    name = json['name'];
    pan = json['pan'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['card_id'] = this.cardId;
    data['card_token'] = this.cardToken;
    data['name'] = this.name;
    data['pan'] = this.pan;
    data['type'] = this.type;
    return data;
  }
}

class PaymentTypesCheckBox {
  int id;
  int paymentId;
  int cardId;
  String name;
  String cardToken;
  String pan;
  String type;

  PaymentTypesCheckBox({
    this.id,
    this.paymentId,
    this.cardToken,
    this.cardId,
    this.name,
    this.pan,
    this.type,
  });
}
