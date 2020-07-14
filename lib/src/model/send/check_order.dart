class CheckOrderModel {
  String location;
  String type;
  int shipping_time;
  List<Drugs> drugs;

  CheckOrderModel({this.location, this.type, this.shipping_time, this.drugs});

  CheckOrderModel.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    type = json['type'];
    shipping_time = json['shipping_time'];
    if (json['drugs'] != null) {
      drugs = new List<Drugs>();
      json['drugs'].forEach((v) {
        drugs.add(new Drugs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['type'] = this.type;
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
