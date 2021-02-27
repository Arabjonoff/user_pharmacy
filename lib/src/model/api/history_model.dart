class HistoryModel {
  int count;
  String next;
  String previous;
  List<HistoryResults> results;

  HistoryModel({this.count, this.next, this.previous, this.results});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<HistoryResults>();
      json['results'].forEach((v) {
        results.add(new HistoryResults.fromJson(v));
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

class HistoryResults {
  int id;
  String address;
  Location location;
  DateTime endShiptime;
  double deliveryTotal;
  PaymentType paymentType;
  Store store;
  Delivery delivery;
  String createdAt;
  double total;
  double realTotal;
  String status;
  String type;
  String fullName;
  String phone;
  String expireSelfOrder;
  List<Items> items;

  HistoryResults(
      {this.id,
      this.address,
      this.location,
      this.endShiptime,
      this.deliveryTotal,
      this.paymentType,
      this.store,
      this.delivery,
      this.createdAt,
      this.total,
      this.realTotal,
      this.status,
      this.type,
      this.fullName,
      this.phone,
      this.expireSelfOrder,
      this.items});

  HistoryResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'] == null ? "" : json['address'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : Location(type: "", coordinates: [0.0, 0.0]);
    endShiptime = json["end_shiptime"] == null
        ? null
        : DateTime.parse(json["end_shiptime"]);
    deliveryTotal = json['delivery_total'] == null
        ? 0.0
        : json['delivery_total'].toDouble();
    paymentType = json['payment_type'] != null
        ? new PaymentType.fromJson(json['payment_type'])
        : PaymentType(id: 0, name: "", type: "");
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    delivery =
        json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
    createdAt = json['created_at'];
    total = json['total'] == null ? 0.0 : json['total'];
    realTotal = json['real_total'] == null ? 0.0 : json['real_total'];
    status = json['status'];
    type = json['type'] == null ? "" : json['type'];
    expireSelfOrder =
        json['expire_self_order'] == null ? "" : json['expire_self_order'];
    fullName = json['full_name'] == null ? "" : json['full_name'];
    phone = json['phone'] == null ? "" : json['phone'];
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
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['end_shiptime'] =
        this.endShiptime == null ? null : this.endShiptime.toIso8601String();
    data['delivery_total'] = this.deliveryTotal;
    if (this.paymentType != null) {
      data['payment_type'] = this.paymentType.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery.toJson();
    }
    data['created_at'] = this.createdAt;
    data['total'] = this.total;
    data['real_total'] = this.realTotal;
    data['status'] = this.status;
    data['type'] = this.type;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['expire_self_order'] = this.expireSelfOrder;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class PaymentType {
  int id;
  String name;
  String type;

  PaymentType({this.id, this.name, this.type});

  PaymentType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'] == null ? "" : json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Store {
  int id;
  String name;
  String address;
  String phone;
  String mode;
  Location location;

  Store(
      {this.id, this.name, this.address, this.phone, this.mode, this.location});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    mode = json['mode'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : Location(type: "", coordinates: [0.0, 0.0]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['mode'] = this.mode;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Delivery {
  String login;
  String firstName;
  String lastName;

  Delivery({
    this.login,
    this.firstName,
    this.lastName,
  });

  Delivery.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
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

  Drug({
    this.id,
    this.name,
    this.barcode,
    this.image,
    this.imageThumbnail,
  });

  Drug.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['image'] = this.image;
    data['image_thumbnail'] = this.imageThumbnail;
    return data;
  }
}
