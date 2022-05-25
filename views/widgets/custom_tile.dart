import 'package:flutter/material.dart';
import '/consts/consts.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.callback,
  }) : super(key: key);
  final Widget icon;
  final String title;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(
          bottom: 10,
        ),
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 11,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 13),
                  Text(
                    title,
                    style: AppStyles.text.copyWith(
                      color: AppColors.text2,
                      fontSize: AppSizes.size16,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: AppSizes.size18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
