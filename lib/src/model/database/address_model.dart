class AddressModel {
  int id;
  String street;
  String lat;
  String lng;

  AddressModel({this.id, this.street, this.lat, this.lng});

  int get getId => id;

  String get getStreet => street;

  String get getLat => lat;

  String get getLng => lng;

  AddressModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.street = map["street"];
    this.lat = map["lat"];
    this.lng = map["lng"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["street"] = street;
    map["lat"] = lat;
    map["lng"] = lng;
    return map;
  }
}
