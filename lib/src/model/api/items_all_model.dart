import 'item_model.dart';

class ItemsAllModel {
  int id;
  String name;
  String barcode;
  String description;
  String image;
  String imageThumbnail;
  double price;
  double basePrice;
  Category unit;
  InternationalName internationalName;
  Category manufacturer;
  Category category;
  List<ItemResult> analog;
  int maxCount;
  double rating;
  bool isComing;
  bool favourite = false;
  int cardCount = 0;

  ItemsAllModel({
    this.id,
    this.name,
    this.barcode,
    this.description,
    this.image,
    this.imageThumbnail,
    this.price,
    this.basePrice,
    this.unit,
    this.internationalName,
    this.manufacturer,
    this.category,
    this.analog,
    this.rating,
  });

  ItemsAllModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    description = json['description'] ?? "";
    image = json['image'] ?? "";
    imageThumbnail = json['image_thumbnail'] ?? "";
    basePrice = json['base_price'] ?? 0.0;
    maxCount = json["max_count"];
    isComing = json["is_coming"];
    price = json['price'] ?? 0.0;
    rating = json['rating'] ?? 0.0;
    unit = json['unit'] != null
        ? new Category.fromJson(json['unit'])
        : Category(id: 0, name: "");
    internationalName = json['international_name'] != null
        ? new InternationalName.fromJson(json['international_name'])
        : InternationalName(id: 0, name: "", nameRu: "");
    manufacturer = json['manufacturer'] != null
        ? new Category.fromJson(json['manufacturer'])
        : Category(id: 0, name: "");
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : Category(id: 0, name: "");
    if (json['analog'] != null) {
      analog = <ItemResult>[];
      json['analog'].forEach((v) {
        analog.add(new ItemResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['image'] = this.image;
    data['image_thumbnail'] = this.imageThumbnail;
    data['base_price'] = this.basePrice;
    data['price'] = this.price;
    data['max_count'] = this.maxCount;
    data['is_coming'] = this.isComing;
    data['rating'] = this.rating;
    if (this.unit != null) {
      data['unit'] = this.unit.toJson();
    }
    if (this.internationalName != null) {
      data['international_name'] = this.internationalName.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.analog != null) {
      data['analog'] = this.analog.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  String name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class InternationalName {
  int id;
  String name;
  String nameRu;

  InternationalName({this.id, this.name, this.nameRu});

  InternationalName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameRu = json['name_ru'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ru'] = this.nameRu;
    return data;
  }
}
