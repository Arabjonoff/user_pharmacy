import 'dart:convert';

class AddOrderModel {
  String address;
  String location;
  String shipdate;
  List<Drugs> drugs;

  AddOrderModel({this.address, this.location, this.shipdate, this.drugs});

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'];
    shipdate = json['shipdate'];
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
    data['shipdate'] = this.shipdate;

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
