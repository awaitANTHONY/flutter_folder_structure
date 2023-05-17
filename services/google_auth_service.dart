// import '/controllers/auth_controller.dart';
// import '/utils/helpers.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuthService {
//   AuthController authController = Get.find();

//   GoogleSignIn googleSignIn = GoogleSignIn(
//     scopes: <String>[
//       'email',
//     ],
//   );

//   signIn(callback) async {
//     authController.isLoading.value = true;
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();

//       if (googleSignInAccount != null) {
//         Map data = {
//           'first_name': googleSignInAccount.displayName,
//           'last_name': googleSignInAccount.displayName,
//           'email': googleSignInAccount.email,
//           'password': googleSignInAccount.id,
//           'password_confirmation': googleSignInAccount.id,
//           'provider': 'google',
//         };

//         dd(data);

//         authController.signUp(data, callback);
//       } else {
//         authController.isLoading.value = false;
//       }
//     } catch (e) {
//       authController.isLoading.value = false;
//       dd(e);
//     }
//   }

//   Future<void> signOut() async {
//     await googleSignIn.signOut();
//   }
// }
