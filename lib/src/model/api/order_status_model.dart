class OrderStatusModel {
  int status;
  String msg;
  int region;
  Data data;

  OrderStatusModel({this.status, this.msg, this.data, this.region});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    region = json['region'] == null ? 0 : json['region'];
    msg = json['msg'] == null ? "" : json['msg'];
    data = json['data'] != null
        ? new Data.fromJson(json['data'])
        : Data(
            error_note: "",
            error_code: 1,
            phone_number: "",
            card_token: "",
          );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['region'] = this.region;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int error_code;
  String error_note;
  int invoice_id;
  String card_token;
  String phone_number;

  Data({this.error_code, this.error_note, this.card_token, this.phone_number});

  Data.fromJson(Map<String, dynamic> json) {
    error_code = json['error_code'];
    error_note = json['error_note'];
    invoice_id = json['invoice_id'] == null ? 0 : json['invoice_id'];
    card_token = json['card_token'] == null ? "" : json['card_token'];
    phone_number = json['phone_number'] == null ? "" : json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = this.error_code;
    data['error_note'] = this.error_note;
    data['invoice_id'] = this.invoice_id;
    data['card_token'] = this.card_token;
    data['phone_number'] = this.phone_number;
    return data;
  }
}
