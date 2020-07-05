class SaleModel {
  SaleModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.name,
    this.image,
    this.description,
    this.status,
    this.drug,
    this.category,
  });

  int id;
  String name;
  String image;
  String description;
  bool status;
  int drug;
  int category;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        status: json["status"],
        drug: json["drug"] == null ? null : json["drug"],
        category: json["category"] == null ? null : json["drug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "status": status,
        "drug": drug,
        "category": category,
      };
}
