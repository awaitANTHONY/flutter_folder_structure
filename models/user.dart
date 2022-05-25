class UserModel {
  bool? status;
  String? accessToken;
  String? message;
  User? user;

  UserModel({this.status, this.accessToken, this.message, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    accessToken = json['access_token'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['access_token'] = accessToken;
    data['message'] = message;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}

class User {
  String? email;
  String? subscriptionId;
  String? expiredAt;
  int? status;
  String? name;
  String? subscriptionTitle;

  User(
      {this.email,
      this.subscriptionId,
      this.expiredAt,
      this.status,
      this.name,
      this.subscriptionTitle});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    subscriptionId = json['subscription_id'];
    expiredAt = json['expired_at'];
    status = json['status'];
    name = json['name'];
    subscriptionTitle = json['subscription_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['subscription_id'] = subscriptionId;
    data['expired_at'] = expiredAt;
    data['status'] = status;
    data['name'] = name;
    data['subscription_title'] = subscriptionTitle;

    return data;
  }
}
