// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import '/consts/consts.dart';

// class TextboxWidgetDropdown extends StatelessWidget {
//   const TextboxWidgetDropdown({
//     Key? key,
//     required this.controller,
//     this.lableText = '',
//     required this.items,
//   }) : super(key: key);

//   final TextEditingController controller;
//   final String lableText;
//   final List<String> items;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 42,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 3,
//       ).copyWith(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//           color: AppColors.border,
//           width: 0.8,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownSearch(
//         dropdownBuilder: (context, selectedItem) {
//           return Text(
//             selectedItem.toString(),
//             style: TextStyle(
//               color: AppColors.text.withOpacity(0.6),
//               fontSize: AppSizes.size14,
//             ),
//           );
//         },
//         dropdownButtonBuilder: (context) => Icon(
//           Icons.expand_more,
//           color: AppColors.primaryColor,
//         ),
//         dropdownSearchDecoration: InputDecoration(
//           labelStyle: TextStyle(
//             color: AppColors.text.withOpacity(0.6),
//             fontSize: AppSizes.size14,
//           ),
//           hintStyle: TextStyle(
//             color: AppColors.text.withOpacity(0.6),
//             fontSize: AppSizes.size14,
//           ),
//           isDense: true,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 10,
//             vertical: 8,
//           ),
//           border: InputBorder.none,
//         ),
//         maxHeight: 160,
//         mode: Mode.MENU,
//         items: items,
//         onChanged: (v) {
//           controller.text = v.toString();
//         },
//         selectedItem: controller.text == '' ? lableText : controller.text,
//       ),
//     );
//   }
// }
