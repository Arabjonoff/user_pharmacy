class ItemsAllModel {



  ItemsAllModel({
    this.id,
    this.name,
    this.barcode,
    this.image,
    this.imageThumbnail,
    this.piece,
    this.dose,
    this.status,
    this.price,
    this.expirationDate,
    this.isRecept,
    this.unit,
    this.internationalName,
    this.manufacturer,
    this.pharm_group,
    this.category,
    this.analog,
    this.recommendations,
  });

  int id;
  String name;
  String barcode;
  String image;
  String imageThumbnail;
  String piece;
  String dose;
  bool status;
  double price;
  String expirationDate;
  bool isRecept;
  Category unit;
  InternationalName internationalName;
  Category manufacturer;
  Category category;
  Category pharm_group;
  List<ItemsAllModel> analog;
  List<ItemsAllModel> recommendations;
  bool favourite = false;
  int cardCount = 0;
  bool sale = false;

  factory ItemsAllModel.fromJson(Map<String, dynamic> json) => ItemsAllModel(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
        image: json["image"],
        imageThumbnail: json["image_thumbnail"],
        piece: json["piece"],
        dose: json["dose"],
        status: json["status"],
        price: json["price"].toDouble(),
        expirationDate: json["expiration_date"],
        isRecept: json["is_recept"],
        unit: Category.fromJson(json["unit"]) == null
            ? Category(id: 0, name: "")
            : Category.fromJson(json["unit"]),
        internationalName:
            InternationalName.fromJson(json["international_name"]) == null
                ? InternationalName(id: 0, name: "", nameRu: "")
                : InternationalName.fromJson(json["international_name"]),
        manufacturer: Category.fromJson(json["manufacturer"]) == null
            ? Category(id: 0, name: "")
            : Category.fromJson(json["manufacturer"]),
        pharm_group: Category.fromJson(json["pharm_group"]) == null
            ? Category(id: 0, name: "")
            : Category.fromJson(json["pharm_group"]),
        category: Category.fromJson(json["category"]) == null
            ? Category(id: 0, name: "")
            : Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "image": image,
        "image_thumbnail": imageThumbnail,
        "piece": piece,
        "dose": dose,
        "status": status,
        "price": price,
        "expiration_date": expirationDate,
        "is_recept": isRecept,
        "unit": unit.toJson(),
        "international_name": internationalName.toJson(),
        "manufacturer": manufacturer.toJson(),
        "category": category.toJson(),
        "pharm_group": pharm_group.toJson(),
      };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class InternationalName {
  InternationalName({
    this.id,
    this.name,
    this.nameRu,
  });

  int id;
  String name;
  String nameRu;

  factory InternationalName.fromJson(Map<String, dynamic> json) =>
      InternationalName(
        id: json["id"],
        name: json["name"],
        nameRu: json["name_ru"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ru": nameRu,
      };
}
