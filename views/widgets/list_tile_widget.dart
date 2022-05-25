import 'package:flutter/material.dart';
import '/consts/consts.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    Key? key,
    required this.icon,
    required this.name,
    this.subTitle = '',
    this.callback,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final String subTitle;
  // ignore: prefer_typing_uninitialized_variables
  final callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.background2,
          border: Border(
            bottom: BorderSide(
              width: 0.2,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppStyles.text.copyWith(
                        fontSize: AppSizes.size13,
                        color: AppColors.text,
                      ),
                    ),
                    if (subTitle != '')
                      Text(
                        subTitle,
                        style: AppStyles.text.copyWith(
                          fontSize: AppSizes.size13,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                  ],
                )
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: AppColors.text,
            ),
          ],
        ),
      ),
    );
  }
}
