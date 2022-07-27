import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/services/api_services.dart';
import '/services/vpn_service.dart';
import '/utils/helpers.dart';
import '/models/user.dart';
import '/views/screens/parent_screen.dart';

class AuthController extends GetxController {
  List<Color> colors = [
    Colors.red.shade700,
    Colors.yellow.shade600,
    Colors.purple.shade600,
    Colors.blue.shade600,
    Colors.pink.shade600
  ];
  RxBool isLoading = false.obs;
  RxBool isLogin = false.obs;
  RxString accessToken = ''.obs;
  Rx<User> user = User().obs;

  signup(data) async {
    isLoading.value = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    var vpnResult = await CheckVpnConnection.isVpnActive();
    if (connectivityResult != ConnectivityResult.none && !vpnResult) {
      try {
        var response = await ApiService.signup(data);

        if (response.status == true) {
          user.value = response.user!;
          storeToken(response.accessToken!);
          isLogin.value = true;
          Get.offAll(
            () => const ParentScreen(),
          );
        } else {
          showToast(response.message ?? '');
        }
      } catch (e) {
        showSnackBar(
          'Server error! Please try agains.',
          2,
          () {
            signup(data);
          },
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      showSnackBar(
        'No internet connection please try again!',
        2,
        () {
          signup(data);
        },
      );
    }
  }

  signin(data) async {
    isLoading.value = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    var vpnResult = await CheckVpnConnection.isVpnActive();
    if (connectivityResult != ConnectivityResult.none && !vpnResult) {
      try {
        var response = await ApiService.signin(data);

        if (response.status == true) {
          user.value = response.user!;
          storeToken(response.accessToken!);
          isLogin.value = true;
          Get.offAll(
            () => const ParentScreen(),
          );
        } else {
          showToast(response.message ?? '');
        }
      } catch (e) {
        showSnackBar(
          'Server error! Please try againss.',
          2,
          () {
            signup(data);
          },
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      showSnackBar(
        'No internet connection please try again!',
        2,
        () {
          signup(data);
        },
      );
    }
  }

  loadUser() async {
    isLoading.value = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    var vpnResult = await CheckVpnConnection.isVpnActive();
    if (connectivityResult != ConnectivityResult.none && !vpnResult) {
      try {
        var response = await ApiService.user();

        if (response.status == true) {
          user.value = response.user!;
          storeToken(response.accessToken!);
          isLogin.value = true;
        } else {
          showToast(response.message ?? '');
        }
      } catch (e) {
        showSnackBar(
          'Server error! Please try againss.',
          2,
          () {
            loadUser();
          },
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      showSnackBar(
        'No internet connection please try again!',
        2,
        () {
          loadUser();
        },
      );
    }
  }

  storeToken(token) {
    final box = GetStorage();

    accessToken.value = token;
    box.write('accessToken', token);
  }

  getToken() {
    final box = GetStorage();
    accessToken.value = box.read('accessToken') ?? '';
    return accessToken.value;
  }

  logout() {
    storeToken('');
    accessToken.value = '';
    isLogin.value = false;
    user.value = User();
    Get.offAll(() => const ParentScreen());
  }

  // loadUser() {
  //   var box = GetStorage();
  //   if (box.read('users') != null) {
  //     isLogined.value = true;
  //     user.value = UserModel.fromJson(jsonDecode(box.read('users')));
  //   }
  // }

  // logout() {
  //   if (user.value.prodiver == 'google') {
  //     GoogleAuthService().logout();
  //   } else if (user.value.prodiver == 'email') {
  //     EmailAuthService().logout();
  //   }
  //   var box = GetStorage();
  //   box.remove('users');
  //   isLogined.value = false;

  //   SchedulerBinding.instance?.addPostFrameCallback((_) {
  //     Get.offAll(() => ParentScreen());
  //   });
  // }
}
