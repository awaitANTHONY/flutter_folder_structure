// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import '/consts/consts.dart';
// import '/controllers/auth_controller.dart';
// import '/utils/helpers.dart';
// import '/services/ads_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// // ignore: depend_on_referenced_packages
// import 'package:crypto/crypto.dart';

// class SocialAuthService {
//   static AuthController authController = Get.find();

//   static Future<void> google(VoidCallback callback) async {
//     authController.isGoogleLoginLoading.value = true;

//     try {
//       if (Platform.isAndroid) {
//         await GoogleSignIn.instance.initialize(
//           clientId: AppConsts.serverClientId,
//           serverClientId: AppConsts.serverClientId,
//         );
//       }
//       final GoogleSignInAccount googleSignInAccount = await GoogleSignIn
//           .instance
//           .authenticate();
//       final GoogleSignInAuthentication googleAuth =
//           googleSignInAccount.authentication;

//       if (googleAuth.idToken == null) {
//         throw Exception('Failed to get Google ID token');
//       }

//       await authController.makeOAuthRequest(
//         provider: 'google',
//         data: {'id_token': googleAuth.idToken},
//         onSuccess: () {
//           callback();
//         },
//       );
//     } catch (e) {
//       dd('Google Auth Error: $e');
//       await GoogleSignIn.instance.signOut();
//     } finally {
//       authController.isGoogleLoginLoading.value = false;
//     }
//   }

//   static Future<void> apple(VoidCallback callback) async {
//     authController.isAppleLoginLoading.value = true;
//     // Suppress app open ads for the duration of the Apple auth flow.
//     // On iOS the native sheet dismisses back to the app, which triggers the
//     // foreground lifecycle event — without this the ad fires over the sign-in.
//     AdsService.appOpenService?.pauseAds();

//     try {
//       final rawNonce = _generateNonce();
//       final nonce = _sha256ofString(rawNonce);

//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         nonce: nonce,
//         webAuthenticationOptions: Platform.isAndroid
//             ? WebAuthenticationOptions(
//                 clientId: 'com.ribetai.footballapp',
//                 redirectUri: Uri.parse(
//                   'https://ribetai.com/auth/apple/callback',
//                 ),
//               )
//             : null,
//       );

//       if (appleCredential.identityToken == null) {
//         throw Exception('Failed to get Apple ID token');
//       }

//       await authController.makeOAuthRequest(
//         provider: 'apple',
//         data: {
//           'id_token': appleCredential.identityToken,
//           'authorization_code': appleCredential.authorizationCode,
//           'nonce': rawNonce,
//           'platform': Platform.isAndroid ? 'android' : 'ios',
//         },
//         onSuccess: () {
//           callback();
//         },
//       );
//     } catch (e) {
//       dd('Apple Auth Error: $e');
//     } finally {
//       authController.isAppleLoginLoading.value = false;
//       AdsService.appOpenService?.resumeAds();
//     }
//   }

//   static String _generateNonce([int length = 32]) {
//     const charset =
//         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(
//       length,
//       (_) => charset[random.nextInt(charset.length)],
//     ).join();
//   }

//   static String _sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   static Future<void> signOut() async {
//     try {
//       if (authController.user.value.provider == 'google') {
//         await GoogleSignIn.instance.signOut();
//       }
//     } catch (e) {
//       dd('OAuth Sign Out Error: $e');
//     }
//   }
// }
