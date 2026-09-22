import '/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class SecondaryButtonWidget extends StatelessWidget {
  const SecondaryButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10.sp);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          width: 1.5,
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          side: BorderSide.none,
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: !isLoading
            ? Text(
                text,
                style: AppStyles.semiBold.copyWith(
                  color: AppColors.black,
                  fontSize: 15.sp,
                ),
              )
            : SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              ),
      ),
    );
  }
}
