import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/controllers/auth_controller.dart';
import '/views/screens/parent_screen.dart';

class GoogleAuthService {
  AuthController authController = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  login() async {
    authController.isLoading.value = true;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await _auth.signInWithCredential(credential);

      final User? user = authResult.user;

      if (user != null) {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['name'] = user.displayName;
        data['email'] = user.email;
        data['password'] = user.uid;
        data['password_confirmation'] = user.uid;
        data['prodiver'] = 'google';

        authController.signup(data);
      }

      return;
    } catch (e) {
      authController.isLoading.value = false;

      //print(e);
      //throw (e);
    }
  }

  Future<void> logout() async {
    await googleSignIn.signOut();
  }
}
