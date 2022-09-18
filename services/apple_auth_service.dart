// // ignore_for_file: depend_on_referenced_packages

// import 'dart:convert';
// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/controllers/auth_controller.dart';
// import '/utils/helpers.dart';
// import 'package:get/get.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:crypto/crypto.dart';

// class AppleAuthService {
//   AuthController authController = Get.find();

//   String generateNonce([int length = 32]) {
//     const charset =
//         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//         .join();
//   }

//   String sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   signIn() async {
//     try {
//       final rawNonce = generateNonce();
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       final credential = OAuthProvider("apple.com").credential(
//         idToken: appleCredential.identityToken,
//         rawNonce: rawNonce,
//       );

//       final authResult =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       User? user = authResult.user;
//       if (user != null) {
//         Map data = {
//           'name':
//               '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}',
//           'email': user.email,
//           'password': user.uid,
//           'password_confirmation': user.uid,
//           'provider': 'apple',
//         };

//         dd(data);

//         authController.signUp(data);
//       } else {
//         authController.isLoading.value = false;
//       }
//     } catch (e) {
//       authController.isLoading.value = false;
//       dd(e);
//     }
//   }

//   Future<void> signOut() async {
//     FirebaseAuth.instance.signOut();
//   }
// }
