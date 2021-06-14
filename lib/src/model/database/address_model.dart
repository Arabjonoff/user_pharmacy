class AddressModel {
  int id;
  String street;
  String lat;
  String lng;
  int type;

  AddressModel({
    this.id,
    this.street,
    this.lat,
    this.lng,
    this.type,
  });

  AddressModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.street = map["street"];
    this.lat = map["lat"];
    this.lng = map["lng"];
    this.type = map["type"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["street"] = street;
    map["lat"] = lat;
    map["lng"] = lng;
    map["type"] = type;
    return map;
  }
}
