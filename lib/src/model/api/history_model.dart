class HistoryModel {
  int count;
  String next;
  String previous;
  List<Results> results;

  HistoryModel({this.count, this.next, this.previous, this.results});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int id;
  String address;
  String location;
  String shipdate;
  String type;
  double total;
  double realTotal;
  String status;
  List<Items> items;

  Results(
      {this.id,
      this.address,
      this.location,
      this.shipdate,
      this.total,
      this.realTotal,
      this.type,
      this.status,
      this.items});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    location = json['location'];
    shipdate = json['shipdate'];
    total = json['total'];
    type = json['type'];
    realTotal = json['real_total'];
    status = json['status'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['location'] = this.location;
    data['shipdate'] = this.shipdate;
    data['total'] = this.total;
    data['type'] = this.type;
    data['real_total'] = this.realTotal;
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int id;
  Drug drug;
  int qty;
  double price;
  double subtotal;
  bool status;

  Items({this.id, this.drug, this.qty, this.price, this.subtotal, this.status});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drug = json['drug'] != null ? new Drug.fromJson(json['drug']) : null;
    qty = json['qty'];
    price = json['price'];
    subtotal = json['subtotal'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.drug != null) {
      data['drug'] = this.drug.toJson();
    }
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['subtotal'] = this.subtotal;
    data['status'] = this.status;
    return data;
  }
}

class Drug {
  int id;
  String name;
  String barcode;
  String image;
  String imageThumbnail;
  String piece;
  String dose;

  Drug(
      {this.id,
      this.name,
      this.barcode,
      this.image,
      this.imageThumbnail,
      this.piece,
      this.dose});

  Drug.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
    piece = json['piece'];
    dose = json['dose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['image'] = this.image;
    data['image_thumbnail'] = this.imageThumbnail;
    data['piece'] = this.piece;
    data['dose'] = this.dose;
    return data;
  }
}
