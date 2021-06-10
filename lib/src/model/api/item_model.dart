class ItemModel {
  ItemModel({
    this.count,
    this.next,
    this.previous,
    this.results,
    this.drugs,
    this.title,
  });

  int count;
  dynamic next;
  dynamic previous;
  String title;
  List<ItemResult> results;
  List<ItemResult> drugs;

  ItemModel.fromJson(Map<String, dynamic> json) {
    this.count = json["count"];
    this.next = json["next"];
    this.previous = json["previous"];
    this.title = json["title"]??"";
    this.results = json["results"] == null
        ? []
        : List<ItemResult>.from(
            json["results"].map(
              (x) => ItemResult.fromJson(x),
            ),
          );
    this.drugs = json["drugs"] == null
        ? []
        : List<ItemResult>.from(
            json["drugs"].map(
              (x) => ItemResult.fromJson(x),
            ),
          );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "drugs": List<dynamic>.from(drugs.map((x) => x.toJson())),
      };
}

class ItemResult {
  int id;
  String name;
  String barcode;
  String image;
  String imageThumbnail;
  double price;
  double basePrice;
  Manifacture manufacturer;
  int maxCount;
  bool isComing;
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
    this.basePrice,
  });

  ItemResult.fromJson(Map<String, dynamic> map) {
    this.id = map["id"] ?? 0;
    this.name = map["name"] ?? "";
    this.barcode = map["barcode"] ?? "";
    this.image = map["image"] ?? "";
    this.imageThumbnail = map["image_thumbnail"] ?? "";
    this.maxCount = map["max_count"] ?? 100;
    this.isComing = map["is_coming"] ?? false;
    this.price = map["price"] == null ? 0.0 : map["price"].toDouble();
    this.basePrice =
        map["base_price"] == null ? 0.0 : map["base_price"].toDouble();
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
        "max_count": maxCount,
        "base_price": basePrice,
        "is_coming": isComing,
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
