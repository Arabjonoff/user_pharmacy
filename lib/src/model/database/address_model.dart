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
    required this.id,
    this.street = "",
    this.lat = "",
    this.lng = "",
    this.type = 0,
    this.dom = "",
    this.en = "",
    this.kv = "",
    this.comment = "",
  });

  factory AddressModel.fromMap(Map<dynamic, dynamic> map) {
    return AddressModel(
      id: map["id"],
      street: map["street"],
      lat: map["lat"],
      lng: map["lng"],
      type: map["type"],
      dom: map["dom"],
      en: map["en"],
      kv: map["kv"],
      comment: map["comment"],
    );
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
