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
            errorNote: "",
            errorCode: 1,
            phoneNumber: "",
            cardToken: "",
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
  int errorCode;
  String errorNote;
  int invoiceId;
  String cardToken;
  String phoneNumber;

  Data({
    this.errorCode,
    this.errorNote,
    this.cardToken,
    this.phoneNumber,
  });

  Data.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    errorNote = json['error_note'];
    invoiceId = json['invoice_id'] == null ? 0 : json['invoice_id'];
    cardToken = json['card_token'] == null ? "" : json['card_token'];
    phoneNumber = json['phone_number'] == null ? "" : json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = this.errorCode;
    data['error_note'] = this.errorNote;
    data['invoice_id'] = this.invoiceId;
    data['card_token'] = this.cardToken;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
