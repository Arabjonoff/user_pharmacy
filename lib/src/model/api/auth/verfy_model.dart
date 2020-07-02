class VerfyModel {
  String msg;
  int status;
  User user;
  String token;

  VerfyModel({this.msg, this.status, this.user, this.token});

  VerfyModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int id;
  String login;
  String avatar;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  int complete;

  User(
      {this.id,
      this.login,
      this.avatar,
      this.firstName,
      this.lastName,
      this.gender,
      this.birthDate,
      this.complete});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    avatar = json['avatar'];
    firstName = json['first_name'] != null ? json['first_name'] : "";
    lastName = json['last_name'] != null ? json['last_name'] : "";
    gender = json['gender'] != null ? json['gender'] : "";
    birthDate = json['birth_date'] != null ? json['birth_date'] : "";
    complete = json['complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['avatar'] = this.avatar;
    if (this.firstName != null) {
      data['first_name'] = this.firstName;
    }
    if (this.lastName != null) {
      data['last_name'] = this.lastName;
    }
    if (this.gender != null) {
      data['gender'] = this.gender;
    }
    if (this.birthDate != null) {
      data['birth_date'] = this.birthDate;
    }
    data['complete'] = this.complete;
    return data;
  }
}
