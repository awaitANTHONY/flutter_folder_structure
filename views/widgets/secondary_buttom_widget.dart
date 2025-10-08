import '/consts/consts.dart';
import 'package:flutter/material.dart';

class SecondaryButtomWidget extends StatelessWidget {
  const SecondaryButtomWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  final String text;
  final Null Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          side: BorderSide(color: AppColors.primary, width: 1.5.sp),
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          shadowColor: Colors.transparent,
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
