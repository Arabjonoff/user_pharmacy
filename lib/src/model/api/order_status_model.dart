class OrderStatusModel {
  int status;
  String msg;
  Data data;

  OrderStatusModel({this.status, this.msg, this.data});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null
        ? new Data.fromJson(json['data'])
        : Data(
            return_url: "",
            error: 1,
            error_msg: "",
          );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String return_url;
  int error;
  String error_msg;

  Data({this.return_url, this.error, this.error_msg});

  Data.fromJson(Map<String, dynamic> json) {
    return_url = json['return_url'];
    error = json['error'];
    error_msg = json['error_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_url'] = this.return_url;
    data['error'] = this.error;
    data['error_msg'] = this.error_msg;
    return data;
  }
}
