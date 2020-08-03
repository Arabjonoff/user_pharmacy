class CheckVersionModel {
  bool title;
  String packageName;

  CheckVersionModel({this.title, this.packageName});

  factory CheckVersionModel.fromJson(Map<String, dynamic> json) =>
      CheckVersionModel(
        title: json["title"],
        packageName: json["packageName"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "packageName": packageName,
      };
}
