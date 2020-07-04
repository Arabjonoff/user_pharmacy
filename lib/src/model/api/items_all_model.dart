import 'item_model.dart';

class ItemsAllModel {
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
  Category pharmGroup;
  Category category;
  List<ItemResult> analog;
  List<ItemResult> recommendations;
  bool favourite = false;
  int cardCount = 0;
  bool sale = false;

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
    this.pharmGroup,
    this.category,
    this.analog,
    this.recommendations,
  });

  ItemsAllModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
    piece = json['piece'];
    dose = json['dose'];
    status = json['status'];
    price = json['price'];
    expirationDate = json['expiration_date'];
    isRecept = json['is_recept'];
    unit = json['unit'] != null
        ? new Category.fromJson(json['unit'])
        : Category(id: 0, name: "");
    internationalName = json['international_name'] != null
        ? new InternationalName.fromJson(json['international_name'])
        : InternationalName(id: 0, name: "", nameRu: "");
    manufacturer = json['manufacturer'] != null
        ? new Category.fromJson(json['manufacturer'])
        : Category(id: 0, name: "");
    pharmGroup = json['pharm_group'] != null
        ? new Category.fromJson(json['pharm_group'])
        : Category(id: 0, name: "");
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : Category(id: 0, name: "");
    if (json['analog'] != null) {
      analog = new List<ItemResult>();
      json['analog'].forEach((v) {
        analog.add(new ItemResult.fromJson(v));
      });
    }
    if (json['recommendations'] != null) {
      recommendations = new List<ItemResult>();
      json['recommendations'].forEach((v) {
        recommendations.add(new ItemResult.fromJson(v));
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
    data['piece'] = this.piece;
    data['dose'] = this.dose;
    data['status'] = this.status;
    data['price'] = this.price;
    data['expiration_date'] = this.expirationDate;
    data['is_recept'] = this.isRecept;
    if (this.unit != null) {
      data['unit'] = this.unit.toJson();
    }
    if (this.internationalName != null) {
      data['international_name'] = this.internationalName.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer.toJson();
    }
    if (this.pharmGroup != null) {
      data['pharm_group'] = this.pharmGroup.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.analog != null) {
      data['analog'] = this.analog.map((v) => v.toJson()).toList();
    }
    if (this.recommendations != null) {
      data['recommendations'] =
          this.recommendations.map((v) => v.toJson()).toList();
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
