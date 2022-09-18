import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/consts.dart';

class TextboxPhone extends StatelessWidget {
  const TextboxPhone({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.lableText = '',
  }) : super(key: key);

  final TextEditingController controller;
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
          keyboardType: TextInputType.phone,
          decoration: AppStyles.phoneInputDecoration(lableText, hintText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return hintText;
            }
            return null;
          },
          maxLength: 11,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      ),
    );
  }
}
