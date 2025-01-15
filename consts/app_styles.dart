import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'consts.dart';

class AppStyles {
  static final small = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w300,
    fontSize: 12.sp,
    color: AppColors.white,
  );

  static final medium = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w400,
    fontSize: 13.sp,
  );

  static final large = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
  );

  static final semiBold = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: AppColors.white,
  );

  static final bold = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w900,
    fontSize: 14.sp,
    color: AppColors.white,
  );

  static InputDecoration textInputDecoration([
    String lableText = "",
    String hintText = "",
    String prefixText = "",
    Widget? suffix,
  ]) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.blackLess,
        fontSize: 13.sp,
      ),
      prefixText: prefixText,
      fillColor: AppColors.background,
      filled: true,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  static InputDecoration phoneInputDecoration([
    String lableText = "",
    String hintText = "",
    String prefixText = "",
  ]) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.blackLess,
        fontSize: 13.sp,
        fontWeight: FontWeight.normal,
      ),
      counterText: '',
      prefixText: prefixText,
      fillColor: AppColors.background,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 15,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
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
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
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

  static InputDecoration textInputDecoration3([
    String hintText = "",
  ]) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      hintStyle: TextStyle(
        color: AppColors.black,
        fontSize: 13.sp,
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
