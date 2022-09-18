// // ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/views/screens/auth/login_screen.dart';
// import '/controllers/auth_controller.dart';
// import '/utils/helpers.dart';
// import '../../widgets/textbox_widget.dart';
// import '/consts/consts.dart';

// class RegisterScreen extends StatefulWidget {
//   RegisterScreen({Key? key, this.title}) : super(key: key);

//   final String? title;

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   AuthController authController = Get.find();
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController mailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(height: height * .150),
//                     Text(
//                       'Veva Live'.toUpperCase(),
//                       style: AppStyles.heading.copyWith(
//                         color: AppColors.text,
//                         fontSize: AppSizes.size20,
//                       ),
//                     ),
//                     SizedBox(height: 50),
//                     TextboxWidget(
//                       title: 'Name'.tr,
//                       controller: nameController,
//                       hintText: 'Enter your name.'.tr,
//                     ),
//                     TextboxWidget(
//                       title: 'Email'.tr,
//                       controller: mailController,
//                       hintText: 'Enter your email address.'.tr,
//                     ),
//                     TextboxWidget(
//                       title: 'Password'.tr,
//                       controller: passwordController,
//                       isPassword: true,
//                       hintText: 'Enter your password.'.tr,
//                     ),
//                     TextboxWidget(
//                       title: 'Confirm Password'.tr,
//                       controller: confirmPasswordController,
//                       isPassword: true,
//                       hintText: 'Enter your confirm password.'.tr,
//                     ),
//                     SizedBox(height: 20),
//                     Obx(() {
//                       return InkWell(
//                         onTap: () {
//                           if (_formKey.currentState!.validate()) {
//                             if (passwordController.text !=
//                                 confirmPasswordController.text) {
//                               showToast(
//                                 'Confirmation password does not match.'.tr,
//                               );
//                             } else {
//                               final Map<String, dynamic> data =
//                                   <String, dynamic>{};
//                               data['name'] = nameController.text;
//                               data['email'] = mailController.text;
//                               data['password'] = passwordController.text;
//                               data['password_confirmation'] =
//                                   confirmPasswordController.text;
//                               data['prodiver'] = 'email';

//                               authController.signup(data);
//                             }
//                           }
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(5)),
//                             boxShadow: const <BoxShadow>[
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 offset: Offset(0, 0),
//                                 blurRadius: 3,
//                                 spreadRadius: 1,
//                               )
//                             ],
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [
//                                 AppColors.primaryColor,
//                                 AppColors.primaryColor.withOpacity(0.8),
//                               ],
//                             ),
//                           ),
//                           child: !authController.isLoading.value
//                               ? Text(
//                                   'Register Now'.tr,
//                                   style: TextStyle(
//                                     fontSize: AppSizes.size16,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: AppColors.text2,
//                                   ),
//                                 ),
//                         ),
//                       );
//                     }),
//                     SizedBox(height: height * .025),
//                     InkWell(
//                       onTap: () {
//                         Get.to(() => LoginScreen());
//                       },
//                       child: Container(
//                         margin: EdgeInsets.symmetric(vertical: 20),
//                         padding: EdgeInsets.all(15),
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               'Already have an account ?'.tr,
//                               style: AppStyles.text,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               'Login'.tr,
//                               style: AppStyles.text2.copyWith(
//                                 fontSize: AppSizes.size14,
//                                 color: AppColors.text,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
