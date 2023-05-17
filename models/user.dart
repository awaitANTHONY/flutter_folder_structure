class User {
  bool? status;
  String? accessToken;
  UserData? data;
  String? message;

  User({this.status, this.accessToken, this.data, this.message});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    accessToken = json['access_token'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['access_token'] = accessToken;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? provider;

  UserData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.image,
      this.provider});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    image = json['image'];
    provider = json['provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['image'] = image;
    data['provider'] = provider;
    return data;
  }
}
