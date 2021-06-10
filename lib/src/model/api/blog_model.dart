class BlogModel {
  int count;
  String next;
  String previous;
  List<BlogResults> results;

  BlogModel({this.count, this.next, this.previous, this.results});

  BlogModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<BlogResults>();
      json['results'].forEach((v) {
        results.add(new BlogResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlogResults {
  int id;
  String title;
  String body;
  String image;
  String imageUz;
  DateTime updatedAt;

  BlogResults({
    this.id,
    this.title,
    this.body,
    this.image,
    this.imageUz,
    this.updatedAt,
  });

  BlogResults.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    body = json['body'] ?? "";
    image = json['image'] ?? "";
    imageUz = json['image_uz'] ?? "";
    updatedAt = json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['image_uz'] = this.imageUz;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
