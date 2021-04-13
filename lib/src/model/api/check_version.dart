class CheckVersion {
  int status;
  String description;
  int version;
  bool winner;
  String konkursText;

  CheckVersion({
    this.status,
    this.description,
    this.version,
    this.winner,
    this.konkursText,
  });

  CheckVersion.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    version = json['version'];
    konkursText = json['konkurs_text'] ?? "";
    winner = json['winner'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    data['version'] = this.version;
    data['konkurs_text'] = this.konkursText;
    data['winner'] = this.winner;
    return data;
  }
}
