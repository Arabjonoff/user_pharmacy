class AddressModel {
  int id;
  String street;
  String flat;
  String padez;
  String etaj;
  String komment;

  AddressModel(
      this.id, this.street, this.flat, this.padez, this.etaj, this.komment);

  int get getId => id;

  String get getStreet => street;

  String get getFlat => flat;

  String get getPadez => padez;

  String get getEtaj => etaj;

  String get getKomment => komment;

  AddressModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.street = map["street"];
    this.flat = map["flat"];
    this.padez = map["padez"];
    this.etaj = map["etaj"];
    this.komment = map["komment"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["street"] = street;
    map["flat"] = flat;
    map["padez"] = padez;
    map["etaj"] = etaj;
    map["komment"] = komment;
    return map;
  }
}
