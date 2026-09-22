import '/consts/consts.dart';

import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onTap;
  final double? iconSize;
  final Color? iconColor;

  const NoDataWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.add_circle_outline_sharp,
    this.buttonText,
    this.onTap,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w).copyWith(top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120.sp,
              height: 120.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: iconSize ?? 60.sp,
                color: iconColor ?? AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            24.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.bold.copyWith(
                color: AppColors.blackLess,
                fontSize: 18.sp,
              ),
            ),
            if (subtitle != null) ...[
              12.verticalSpace,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppStyles.medium.copyWith(
                  color: AppColors.blackLess.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                ),
              ),
            ],
            // Action Button (if provided)
            if (buttonText != null && onTap != null) ...[
              32.verticalSpace,
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(25.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    buttonText!,
                    style: AppStyles.semiBold.copyWith(
                      color: AppColors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
