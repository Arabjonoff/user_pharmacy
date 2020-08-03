class CheckVersion {
  int status;
  String description;
  int version;

  CheckVersion({this.status, this.description, this.version});

  CheckVersion.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    data['version'] = this.version;
    return data;
  }
}