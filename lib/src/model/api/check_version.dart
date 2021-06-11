class CheckVersion {
  int status;
  String description;
  int version;
  bool winner;
  bool isRequestForm;
  String konkursText;
  String requestTitle;
  String requestUrl;
  bool requestForm;

  CheckVersion({
    this.status,
    this.description,
    this.version,
    this.winner,
    this.isRequestForm,
    this.konkursText,
    this.requestTitle,
    this.requestUrl,
    this.requestForm,
  });

  CheckVersion.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 1;
    description = json['description'] ?? "";
    version = json['version'] ?? "";
    konkursText = json['konkurs_text'] ?? "";
    requestTitle = json['request_title'] ?? "";
    requestUrl = json['request_url'] ?? "";
    winner = json['winner'] ?? false;
    isRequestForm = json['is_request_form'] ?? false;
    requestForm = json['request_form'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    data['version'] = this.version;
    data['konkurs_text'] = this.konkursText;
    data['winner'] = this.winner;
    data['is_request_form'] = this.isRequestForm;
    data['request_title'] = this.requestTitle;
    data['request_url'] = this.requestUrl;
    data['request_form'] = this.requestForm;
    return data;
  }
}
