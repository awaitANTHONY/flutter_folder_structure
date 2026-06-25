import 'package:flutter/material.dart';
import 'consts.dart';

class AppStyles {
  static final small = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 14.sp,
    color: AppColors.white,
  );
  static final regular = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15.sp,
    color: AppColors.white,
  );

  static final medium = TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp);

  static final large = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
  );

  static final semiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    color: AppColors.white,
  );

  static final bold = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16.sp,
    color: AppColors.white,
  );

  static InputDecoration textInputDecoration({
    String? lableText,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    String? errorText,
    bool isEnabled = true,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.withValues(alpha: 0.7),
        fontSize: 15,
        fontWeight: FontWeight.w300,
        height: 1,
      ),
      prefix: prefix,
      fillColor: isEnabled ? Colors.white : Colors.grey[100],
      filled: true,
      suffixIcon: suffix,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // isDense: true,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      errorText: errorText,
    );
  }

  static InputDecoration phoneInputDecoration({
    String? lableText,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    String? errorText,
    bool isReadOnly = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.withValues(alpha: 0.7),
        fontSize: 14.0,
        fontWeight: FontWeight.w300,
      ),
      prefixIcon: prefix,
      fillColor: isReadOnly ? Colors.grey[200] : Colors.white,
      filled: true,
      suffixIcon: suffix,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: .5,
        ),
      ),
      errorText: errorText,
    );
  }

  static InputDecoration textInputDecoration2([
    String lableText = "",
    String hintText = "",
    Widget? prefix,
    Widget? suffix,
  ]) {
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      labelStyle: const TextStyle(color: AppColors.black),
      hintStyle: const TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w300,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefix,
      suffixIcon: suffix,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  static InputDecoration textInputDecoration3([String hintText = ""]) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      hintStyle: TextStyle(color: AppColors.black, fontSize: 14.sp),
      fillColor: Colors.grey.withValues(alpha: 0.2),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
