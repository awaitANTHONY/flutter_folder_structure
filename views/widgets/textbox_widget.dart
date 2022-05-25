import 'package:flutter/material.dart';
import '/consts/consts.dart';

class TextboxWidget extends StatelessWidget {
  const TextboxWidget({
    Key? key,
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.isPassword = false,
    this.hintText,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.size15,
              color: AppColors.text,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade300,
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: AppSizes.size14,
                ),

                // fillColor: Colors.grey.shade300,
                // filled: true,
              ),
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
