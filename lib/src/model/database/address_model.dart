class AddressModel {
  int id;
  String street;
  String lat;
  String lng;
  String dom;
  String en;
  String kv;
  String comment;
  int type;

  AddressModel({
    this.id,
    this.street,
    this.lat,
    this.lng,
    this.type,
    this.dom,
    this.en,
    this.kv,
    this.comment,
  });

  AddressModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.street = map["street"];
    this.lat = map["lat"];
    this.lng = map["lng"];
    this.type = map["type"];
    this.dom = map["dom"];
    this.en = map["en"];
    this.kv = map["kv"];
    this.comment = map["comment"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["street"] = street;
    map["lat"] = lat;
    map["lng"] = lng;
    map["type"] = type;
    map["dom"] = dom;
    map["en"] = en;
    map["kv"] = kv;
    map["comment"] = comment;
    return map;
  }
}
