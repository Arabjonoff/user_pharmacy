class ItemModel {
  int id;
  String image;
  String name;
  String title;
  String about;
  String price;
  bool favourite = false;
  int cardCount = 0;

  ItemModel(this.id, this.image, this.name, this.title, this.about, this.price,
      this.cardCount);

  ItemModel.map(dynamic obj) {
    this.id = obj["id"];
    this.image = obj["image"];
    this.name = obj["name"];
    this.title = obj["title"];
    this.about = obj["about"];
    this.price = obj["price"];
    this.cardCount = obj["cardCount"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["image"] = image;
    map["name"] = name;
    map["title"] = title;
    map["about"] = about;
    map["price"] = price;
    map["cardCount"] = cardCount;
    return map;
  }

  ItemModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.image = map["image"];
    this.name = map["name"];
    this.title = map["title"];
    this.about = map["about"];
    this.price = map["price"];
    this.cardCount = map["cardCount"];
  }
}
