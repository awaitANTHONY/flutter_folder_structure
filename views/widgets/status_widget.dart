import 'package:get/get_utils/src/extensions/string_extensions.dart';

import '/consts/consts.dart';
import '/utils/helpers.dart';

import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  const StatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.sp),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: _getStatusColor(status.toLowerCase()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          lang(status).capitalize!,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'inactive':
      case 'in-active':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}
