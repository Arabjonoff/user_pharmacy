class ItemModel {
  ItemModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<ItemResult> results;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<ItemResult>.from(
                json["results"].map((x) => ItemResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class ItemResult {
  int id;
  String name;
  String barcode;
  String image;
  String imageThumbnail;
  double price;
  double base_price;
  Manifacture manufacturer;
  int max_count;
  bool is_coming;
  bool favourite = false;
  int cardCount = 0;
  String msg = "";

  ItemResult(
    this.id,
    this.name,
    this.barcode,
    this.image,
    this.imageThumbnail,
    this.price,
    this.manufacturer,
    this.favourite,
    this.cardCount, {
    this.base_price,
  });

  int get getId => id;

  String get getName => name;

  String get getBarcode => barcode;

  String get getImage => image;

  String get getImageThumbnail => imageThumbnail;

  double get getPrice => price;

  Manifacture get getManufacturer => manufacturer;

  bool get getFavourite => favourite;

  int get getCardCount => cardCount;

  ItemResult.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.barcode = map["barcode"];
    this.image = map["image"];
    this.imageThumbnail = map["image_thumbnail"];
    this.max_count = map["max_count"];
    this.is_coming = map["is_coming"];
    this.price = map["price"].toDouble();
    this.base_price = map["base_price"].toDouble();
    this.manufacturer = map['manufacturer'] != null
        ? new Manifacture.fromMap(map['manufacturer'])
        : Manifacture("");
    this.favourite = false;
    this.cardCount = 0;
  }

  ItemResult.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.barcode = map["barcode"];
    this.image = map["image"];
    this.imageThumbnail = map["image_thumbnail"];
    this.price = map["price"].toDouble();
    this.manufacturer = Manifacture(map["manufacturer"].toString());
    this.favourite = map["favourite"] == 1 ? true : false;
    this.cardCount = map["cardCount"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["barcode"] = barcode;
    map["image"] = image;
    map["image_thumbnail"] = imageThumbnail;
    map["price"] = price;
    map["favourite"] = favourite ? 1 : 0;
    map["cardCount"] = cardCount;
    map["manufacturer"] = manufacturer.name;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "image": image,
        "max_count": max_count,
        "base_price": base_price,
        "is_coming": is_coming,
        "image_thumbnail": imageThumbnail,
        "price": price,
        "manufacturer": manufacturer.toJson(),
      };
}

class Manifacture {
  Manifacture(
    this.name,
  );

  String name;

  Manifacture.fromMap(Map<String, dynamic> map) {
    this.name = map["name"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
