import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '/controllers/auth_controller.dart';
import '/models/user.dart';
import '/models/setting.dart';
import '/consts/consts.dart';

class ApiService {
  static var client = http.Client();
  //static AuthController authController = Get.find();

  static Future<Setting> loadSettings() async {
    Uri uri = Uri.parse(AppConsts.baseUrl + AppConsts.settings);

    String body = jsonEncode(<String, dynamic>{
      'api_key': AppConsts.apiKey,
    });

    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return Setting.fromJson(jsonDecode(jsonString));
    } else {
      return Setting();
    }
  }

  static Future<UserModel> signup(data) async {
    Uri uri = Uri.parse(AppConsts.baseUrl + AppConsts.signup);

    data['api_key'] = AppConsts.apiKey;

    String body = jsonEncode(data);

    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return UserModel.fromJson(jsonDecode(jsonString));
    } else {
      return UserModel();
    }
  }

  static Future<UserModel> signin(data) async {
    Uri uri = Uri.parse(AppConsts.baseUrl + AppConsts.signin);

    data['api_key'] = AppConsts.apiKey;

    String body = jsonEncode(data);

    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return UserModel.fromJson(jsonDecode(jsonString));
    } else {
      return UserModel();
    }
  }

  static Future<UserModel> user() async {
    Uri uri = Uri.parse(AppConsts.baseUrl + AppConsts.user);
    var data = {};
    data['api_key'] = AppConsts.apiKey;

    String body = jsonEncode(data);

    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer ' + authController.accessToken.value,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return UserModel.fromJson(jsonDecode(jsonString));
    } else {
      return UserModel();
    }
  }
}
