class CheckVersion {
  int status;
  String description;
  int version;
  bool winner;
  bool requestForm;
  String konkursText;

  CheckVersion({
    this.status,
    this.description,
    this.version,
    this.winner,
    this.requestForm,
    this.konkursText,
  });

  CheckVersion.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    version = json['version'];
    konkursText = json['konkurs_text'] ?? "";
    winner = json['winner'] ?? false;
    requestForm = json['is_request_form'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    data['version'] = this.version;
    data['konkurs_text'] = this.konkursText;
    data['winner'] = this.winner;
    data['is_request_form'] = this.requestForm;
    return data;
  }
}
