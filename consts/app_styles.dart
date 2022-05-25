import 'package:flutter/material.dart';
import '/consts/consts.dart';

class AppStyles {
  static final TextStyle text = TextStyle(
    color: AppColors.text,
    fontSize: AppSizes.size12,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle text2 = TextStyle(
    color: AppColors.primaryColor,
    fontSize: AppSizes.size16,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle heading = TextStyle(
    color: AppColors.text,
    fontSize: AppSizes.size20,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle heading2 = TextStyle(
    color: AppColors.text,
    fontSize: AppSizes.size18,
    fontWeight: FontWeight.normal,
  );

  static InputDecoration textInputDecoration([
    String lableText = "",
    String hintText = "",
    String prefixText = "",
  ]) {
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      labelStyle: const TextStyle(color: AppColors.text2),
      hintStyle: const TextStyle(color: AppColors.text2),
      prefixText: prefixText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
    );
  }

  static InputDecoration phoneInputDecoration([
    String lableText = "",
    String hintText = "",
    String prefixText = "+88",
  ]) {
    return InputDecoration(
      counterText: '',
      labelText: lableText,
      hintText: hintText,
      labelStyle: const TextStyle(color: AppColors.text2),
      hintStyle: const TextStyle(color: AppColors.text2),
      prefixText: prefixText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
    );
  }

  static InputDecoration textInputDecoration2([
    String lableText = "",
    String hintText = "",
  ]) {
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: AppColors.text2.withOpacity(0.6),
        fontSize: AppSizes.size14,
      ),
      hintStyle: TextStyle(
        color: AppColors.text2,
        fontSize: AppSizes.size14,
      ),
      fillColor: Colors.transparent,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 0,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.text2,
          width: 0.8,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.text2,
          width: 0.8,
        ),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.text2,
          width: 0.8,
        ),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.text2,
          width: 0.8,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.text2.withOpacity(0.3),
          width: 0.8,
        ),
      ),
    );
  }

  static InputDecoration textInputDecoration3([
    String hintText = "",
  ]) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      hintStyle: TextStyle(
        color: AppColors.text2,
        fontSize: AppSizes.size13,
      ),
      fillColor: Colors.grey.withOpacity(0.2),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  static BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }
}
