import 'dart:convert';



class AddOrderModel {
  String address;
  String location;
  String shipdate;
  String type;
  String full_name;
  String phone;
  int store_id;
  List<Drugs> drugs;


  AddOrderModel({this.address, this.location, this.shipdate, this.type,
      this.full_name, this.phone, this.store_id, this.drugs});



  AddOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    location = json['location'];
    shipdate = json['shipdate'];
    type = json['type'];
    full_name = json['full_name'];
    phone = json['phone'];
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
    data['shipdate'] = this.shipdate;
    data['full_name'] = this.full_name;
    data['phone'] = this.phone;
    data['store_id'] = this.store_id;

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
