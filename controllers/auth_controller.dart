// import 'package:cnf_sports_new/services/api_services.dart';
// import 'package:cnf_sports_new/services/vpn_service.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:football_live_hd/controllers/setting_controller.dart';
// import '/services/apple_auth_service.dart';
// import '/services/inapp_purchase_service.dart';
// import '/views/screens/auth/login_screen.dart';
// import '/models/user.dart';
// import '/services/api_service.dart';
// import '/services/google_auth_service.dart';
// import '/utils/VpnService.dart';
// import '/utils/helpers.dart';
// import '/views/screens/parent_screen.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   SettingController settingController = Get.find();
//   RxBool isSignIn = false.obs;
//   RxBool isLoading = false.obs;
//   RxString token = ''.obs;
//   Rx<User> user = User().obs;

//   signIn(Map data) async {
//     isLoading.value = true;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     var vpnResult = await CheckVpnConnection.isVpnActive();
//     if (connectivityResult != ConnectivityResult.none && !vpnResult) {
//       try {
//         var response = await ApiService.signIn(data);

//         if (response != {} && response['status'] == true) {
//           token.value = response['access_token'];
//           writeStorage('token', response['access_token']);
//           user.value = User.fromJson(response['data']);
//           isSignIn.value = true;
//           if (user.value.subscriptionId != 0) {
//             settingController.isSubscribed.value = true;
//           }
//           showToast('Successfully SignIn.');
//           Get.offAll(() => const ParentScreen());
//         } else {
//           showToast(response['message'] ?? 'Unknown error.');
//         }
//       } catch (e) {
//         showSnackBar('Server Error! Please Try again.'.tr, () {});
//       } finally {
//         isLoading.value = false;
//       }
//     } else {
//       showSnackBar('No internet connection please try again!'.tr, () {});
//     }
//   }

//   signUp(Map data) async {
//     isLoading.value = true;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     var vpnResult = await CheckVpnConnection.isVpnActive();
//     if (connectivityResult != ConnectivityResult.none && !vpnResult) {
//       try {
//         var response = await ApiService.signUp(data);

//         if (response != {} && response['status'] == true) {
//           token.value = response['access_token'];
//           writeStorage('token', response['access_token']);
//           user.value = User.fromJson(response['data']);
//           isSignIn.value = true;
//           if (user.value.subscriptionId != 0) {
//             settingController.isSubscribed.value = true;
//           }
//           showToast('Successfully SignIn.');
//           Get.offAll(() => const ParentScreen());
//         } else {
//           showToast(response['message'] ?? 'Unknown error.');
//         }
//       } catch (e) {
//         showSnackBar('Server Error! Please Try again.'.tr, () {});
//       } finally {
//         isLoading.value = false;
//       }
//     } else {
//       showSnackBar('No internet connection please try again!'.tr, () {});
//     }
//   }

//   loadUser() async {
//     isLoading.value = true;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     var vpnResult = await CheckVpnConnection.isVpnActive();
//     if (connectivityResult != ConnectivityResult.none && !vpnResult) {
//       try {
//         var response = await ApiService.loadUser();

//         if (response != {} && response['status'] == true) {
//           user.value = User.fromJson(response['data']);
//           isSignIn.value = true;

//           InAppPurchaseService.checkSubscribed(user.value.subscriptionId != 0);
//         }
//       } catch (e) {
//         //
//       } finally {
//         isLoading.value = false;
//       }
//     } else {
//       showSnackBar('No internet connection please try again!'.tr, () {});
//     }
//   }

//   signOut() {
//     writeStorage('token', null);
//     isSignIn.value = false;
//     settingController.isSubscribed.value = false;
//     showToast('Successfully Signout.');

//     if (user.value.provider == 'google') {
//       GoogleAuthService().signOut();
//     } else if (user.value.provider == 'apple') {
//       AppleAuthService().signOut();
//     }
//   }

//   forgetPassword(Map data) async {
//     isLoading.value = true;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     var vpnResult = await CheckVpnConnection.isVpnActive();
//     if (connectivityResult != ConnectivityResult.none && !vpnResult) {
//       try {
//         var response = await ApiService.forgetPassword(data);
//         if (response != {} && response['status'] == true) {
//           showToast(response['message']);
//           Get.to(() => const LoginScreen());
//         } else {
//           showToast(response['message'] ?? 'Unknown error.');
//         }
//       } catch (e) {
//         showSnackBar('Server Error! Please Try again.'.tr, () {});
//       } finally {
//         isLoading.value = false;
//       }
//     } else {
//       showSnackBar('No internet connection please try again!'.tr, () {});
//     }
//   }

//   onInitApp() async {
//     var boxToken = readStorage('token');
//     if (boxToken != null) {
//       token.value = boxToken;
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
