class CheckVersionModel {
  bool title;
  String packageName;
  String desk;

  CheckVersionModel({
    this.title,
    this.packageName,
    this.desk,
  });

  factory CheckVersionModel.fromJson(Map<String, dynamic> json) =>
      CheckVersionModel(
        title: json["title"],
        desk: json["desk"],
        packageName: json["packageName"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "desk": desk,
        "packageName": packageName,
      };
}
