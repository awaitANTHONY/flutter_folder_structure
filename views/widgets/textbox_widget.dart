import 'package:flutter/material.dart';
import '/consts/consts.dart';

class TextboxWidget extends StatelessWidget {
  const TextboxWidget({
    Key? key,
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.isPassword = false,
    this.hintText = '',
    this.lableText = '',
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String lableText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5).copyWith(
              top: 5,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.size16,
                color: AppColors.text2,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.size14,
              ),
              decoration: AppStyles.textInputDecoration(lableText, hintText),
              cursorColor: AppColors.primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return hintText;
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
