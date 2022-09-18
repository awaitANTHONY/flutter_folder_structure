// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/consts/consts.dart';
// import '/controllers/auth_controller.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   AuthController authController = Get.put(AuthController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Column(
//         children: [
//           Expanded(
//             flex: 6,
//             child: Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               child: Image.asset(
//                 'assets/images/splash.png',
//                 height: 230,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 25,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Welcome to',
//                     style: AppStyles.heading.copyWith(
//                       color: AppColors.text,
//                       fontSize: 35,
//                     ),
//                   ),
//                   Text(
//                     'Veva Live Football',
//                     style: AppStyles.text.copyWith(
//                       color: AppColors.text.withOpacity(0.9),
//                       fontSize: AppSizes.size20,
//                     ),
//                   ),
//                   Text(
//                     'Get world class live football, including the English Premier League, Champions League, Europa League, FA Cup, La Liga, Lige 1, and more.',
//                     style: AppStyles.text.copyWith(
//                       color: AppColors.text.withOpacity(0.7),
//                       fontSize: AppSizes.size16,
//                     ),
//                   ),
//                   const Spacer(),
//                   Stack(
//                     children: [
//                       InkWell(
//                         onTap: () {},
//                         child: Obx(() {
//                           return Container(
//                             width: MediaQuery.of(context).size.width,
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(5)),
//                               boxShadow: const <BoxShadow>[
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   offset: Offset(0, 0),
//                                   blurRadius: 3,
//                                   spreadRadius: 1,
//                                 )
//                               ],
//                               gradient: LinearGradient(
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                                 colors: [
//                                   AppColors.primaryColor,
//                                   AppColors.primaryColor.withOpacity(0.8),
//                                 ],
//                               ),
//                             ),
//                             child: !authController.isLoading.value
//                                 ? Text(
//                                     'Sign Up with Google'.tr,
//                                     style: TextStyle(
//                                       fontSize: AppSizes.size16,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 : const SizedBox(
//                                     width: 24,
//                                     height: 24,
//                                     child: CircularProgressIndicator(
//                                       color: AppColors.text,
//                                     ),
//                                   ),
//                           );
//                         }),
//                       ),
//                       Positioned(
//                         top: 0,
//                         bottom: 0,
//                         left: 10,
//                         child: Image.asset(
//                           'assets/images/google.png',
//                           height: 30,
//                           width: 30,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
