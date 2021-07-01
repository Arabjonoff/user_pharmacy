class CreateOrderModel {
  String type;
  String location;
  List<Drugs> drugs;
  int shippingTime;
  int storeId;
  String address;
  String device;
  String fullName;
  String phone;
  bool payment_redirect;

  CreateOrderModel({
    this.address,
    this.location,
    this.type,
    this.shippingTime,
    this.device,
    this.storeId,
    this.drugs,
    this.fullName,
    this.phone,
  });

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'];
    type = json['type'];
    device = json['device'];
    shippingTime = json['shipping_time'];
    storeId = json['store_id'];
    fullName = json['full_name'];
    phone = json['phone'];
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
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['type'] = this.type;
    data['device'] = this.device;
    data['store_id'] = this.storeId;
    data['shipping_time'] = this.shippingTime;
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
