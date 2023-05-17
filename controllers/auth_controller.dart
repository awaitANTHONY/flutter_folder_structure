// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/services.dart';
// import '/services/api_services.dart';
// import '/consts/consts.dart';
// import '/controllers/setting_controller.dart';
// import '/services/google_auth_service.dart';
// import '/models/user.dart';
// import '/utils/helpers.dart';
// import '/views/screens/parent_screen.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class AuthController extends GetxController {
//   var client = http.Client();
//   SettingController settingController = Get.find();
//   RxBool isSignIn = false.obs;
//   RxBool isLoading = false.obs;
//   RxString accessToken = ''.obs;
//   Rx<UserData> user = UserData().obs;

//   signIn(Map<String, dynamic> data) async {
//     isLoading.value = true;

//     try {
//       String url = '${AppConsts.baseUrl}${AppConsts.signin}';
//       Map<String, String> headers = {
//         'X-API-KEY': AppConsts.apiKey,
//       };
//       Map<String, dynamic> body = data;
//       var response = await ApiService.post(
//         url,
//         headers: headers,
//         body: body,
//       );

//       var jsonString = response.body;
//       var responseModel = User.fromJson(jsonDecode(jsonString));

//       if (responseModel.status == true) {
//         accessToken.value = responseModel.accessToken!;
//         writeStorage('accessToken', responseModel.accessToken!);
//         user.value = responseModel.data!;
//         isSignIn.value = true;
//         showToast('Successfully SignIn.');
//         Get.offAll(() => const ParentScreen());
//       } else {
//         showToast(responseModel.message ?? 'Unknown error.');
//       }
//     } catch (e) {
//       showSnackBar('Server Error! Please Try again.'.tr, () {});
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   signUp(Map<String, dynamic> data, VoidCallback callback) async {
//     isLoading.value = true;

//     try {
//       String url = '${AppConsts.baseUrl}${AppConsts.signup}';
//       Map<String, String> headers = {
//         'X-API-KEY': AppConsts.apiKey,
//       };
//       data['device_token'] = await getToken();
//       Map<String, dynamic> body = data;
//       var response = await ApiService.post(
//         url,
//         headers: headers,
//         body: body,
//       );

//       var jsonString = response.body;
//       var responseModel = User.fromJson(jsonDecode(jsonString));

//       if (responseModel.status == true) {
//         accessToken.value = responseModel.accessToken!;
//         writeStorage('accessToken', responseModel.accessToken!);
//         user.value = responseModel.data!;
//         isSignIn.value = true;
//         showToast('Successfully Signup.');
//         Get.offAll(() => const ParentScreen());
//         callback();

//         dd('callback()');
//       } else {
//         showToast(responseModel.message ?? 'Unknown error.');
//       }
//     } catch (e) {
//       log(e.toString());
//       showSnackBar('Server Error! Please Try again.'.tr, () {});
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   loadUser() async {
//     isLoading.value = true;

//     try {
//       String url = '${AppConsts.baseUrl}${AppConsts.user}';
//       Map<String, String> headers = {
//         'X-API-KEY': AppConsts.apiKey,
//         'Authorization': 'Bearer ${accessToken.value}',
//       };

//       Map<String, dynamic> body = {};
//       var response = await ApiService.post(
//         url,
//         headers: headers,
//         body: body,
//       );

//       var jsonString = response.body;
//       var responseModel = User.fromJson(jsonDecode(jsonString));

//       if (responseModel.status == true) {
//         user.value = responseModel.data!;
//         isSignIn.value = true;
//       } else {
//         showToast(responseModel.message ?? 'Unknown error.');
//       }
//     } catch (e) {
//       //
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   signOut(VoidCallback callback) {
//     writeStorage('accessToken', null);
//     accessToken.value = '';
//     isSignIn.value = false;
//     showToast('Successfully Signout.');

//     if (user.value.provider == 'google') {
//       GoogleAuthService().signOut();
//     } else if (user.value.provider == 'apple') {
//       //AppleAuthService().signOut();
//     }

//     callback();
//   }

//   // forgetPassword(Map data) async {
//   //   isLoading.value = true;
//   //   var connectivityResult = await (Connectivity().checkConnectivity());
//   //   if (connectivityResult != ConnectivityResult.none) {
//   //     try {
//   //       var response = await ApiService.forgetPassword(data);
//   //       if (response != {} && response['status'] == true) {
//   //         showToast(response['message']);
//   //         Get.to(() => const LoginScreen());
//   //       } else {
//   //         showToast(response['message'] ?? 'Unknown error.');
//   //       }
//   //     } catch (e) {
//   //       showSnackBar('Server Error! Please Try again.'.tr, () {});
//   //     } finally {
//   //       isLoading.value = false;
//   //     }
//   //   } else {
//   //     showSnackBar('No internet connection please try again!'.tr, () {});
//   //   }
//   // }

//   onInitApp() async {
//     var boxToken = readStorage('accessToken');
//     if (boxToken != null) {
//       accessToken.value = boxToken;
//       await Future.delayed(2.seconds);
//       loadUser();
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     onInitApp();
//   }
// }
