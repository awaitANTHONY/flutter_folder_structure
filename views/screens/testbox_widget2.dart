import 'package:flutter/material.dart';
import '/consts/consts.dart';

class TextboxWidget2 extends StatelessWidget {
  const TextboxWidget2({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.isPassword = false,
    this.hintText = '',
    this.lableText = '',
  }) : super(key: key);

  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String lableText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          //color: Colors.grey.shade300,
        ),
        child: TextFormField(
          style: TextStyle(
            color: AppColors.text,
            fontSize: AppSizes.size16,
          ),
          cursorColor: AppColors.primaryColor,
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: AppStyles.textInputDecoration2(lableText, hintText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return hintText;
            }
            return null;
          },
        ),
      ),
    );
  }
}
