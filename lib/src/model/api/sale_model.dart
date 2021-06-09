class BannerModel {
  BannerModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
    this.drugs,
    this.url,
  });

  int id;
  String name;
  String image;
  String description;
  String url;
  bool status;
  int drug;
  int category;
  List<int> drugs;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        status: json["status"],
        url: json["url"] ?? "",
        drug: json["drug"] == null ? null : json["drug"],
        category: json["category"] == null ? null : json["drug"],
        drugs: List<int>.from(json["drugs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "status": status,
        "url": url,
        "drug": drug,
        "category": category,
        "drugs": List<dynamic>.from(drugs.map((x) => x)),
      };
}
