class VerdyPaymentModel {
  VerdyPaymentModel({
    this.cardToken,
    this.smsCode,
  });

  String cardToken;
  int smsCode;

  factory VerdyPaymentModel.fromJson(Map<String, dynamic> json) =>
      VerdyPaymentModel(
        cardToken: json["card_token"],
        smsCode: json["sms_code"],
      );

  Map<String, dynamic> toJson() => {
        "card_token": cardToken,
        "sms_code": smsCode,
      };
}
