import '/consts/consts.dart';
import 'package:flutter/material.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
    this.isDisabled = false,
    this.isLoading = false,
  });

  final String text;
  final IconData? icon;
  final Function() onTap;
  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10.sp);
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDisabled
                ? [
                    AppColors.secondary.withValues(alpha: 0.5),
                    AppColors.primary.withValues(alpha: 0.5),
                  ]
                : [AppColors.secondary, AppColors.primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: borderRadius,
        ),
        child: ElevatedButton(
          onPressed: isDisabled ? null : onTap,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: !isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: AppColors.white, size: 18.sp),
                      5.horizontalSpace,
                    ],
                    Text(
                      text,
                      style: AppStyles.semiBold.copyWith(
                        color: AppColors.white,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
