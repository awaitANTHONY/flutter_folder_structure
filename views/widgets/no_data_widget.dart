import '/consts/consts.dart';
import '/utils/helpers.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatefulWidget {
  const NoDataWidget({
    super.key,
    this.title = 'No Data',
    this.message = 'Data not found',
  });

  final String message;
  final String title;

  @override
  State<NoDataWidget> createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 150.w,
            fit: BoxFit.cover,
            color: AppColors.primary,
          ),
          20.verticalSpace,
          Text(
            lang(widget.title),
            style: TextStyle(
              color: AppColors.blackLess,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            lang(widget.message),
            style: TextStyle(
              color: AppColors.blackLess,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
