class CreateOrderModel {
  String type;
  String location;
  List<Drugs> drugs;
  int shipping_time;
  int store_id;
  String address;
  String device;

  CreateOrderModel({
    this.address,
    this.location,
    this.type,
    this.shipping_time,
    this.device,
    this.store_id,
    this.drugs,
  });

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'];
    type = json['type'];
    device = json['device'];
    shipping_time = json['shipping_time'];
    store_id = json['store_id'];
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
    data['store_id'] = this.store_id;
    data['shipping_time'] = this.shipping_time;
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
