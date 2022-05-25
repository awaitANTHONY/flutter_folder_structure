import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/consts/consts.dart';

prizeDialog(BuildContext context, Map<String, String> data) {
  Future.delayed(
    Duration.zero,
    () {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: AppSizes.newSize(40),
              child: Material(
                color: AppColors.background,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 40,
                          color: AppColors.primaryColor,
                          child: Text(
                            'Prize Pool',
                            style: AppStyles.heading.copyWith(
                              color: AppColors.text,
                              fontSize: AppSizes.size14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.text,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/g1.gif',
                                  // height: 50,
                                  // width: 50,
                                  // fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (data['perKill'] != '0.00')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          'Per Kill: ${data['perKill']}',
                                          style: AppStyles.heading.copyWith(
                                            color: AppColors.text2,
                                            fontSize: AppSizes.size14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    if (data['winningPrize'] != '0.00')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          'Winning Kill: ৳ ${data['winningPrize']}',
                                          style: AppStyles.heading.copyWith(
                                            color: AppColors.text2,
                                            fontSize: AppSizes.size14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    if (data['secondPrize'] != '0.00')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          'Second Kill: ৳ ${data['secondPrize']} TK',
                                          style: AppStyles.heading.copyWith(
                                            color: AppColors.text2,
                                            fontSize: AppSizes.size14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    if (data['thirdPrize'] != '0.00')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          'Third Kill: ৳ ${data['thirdPrize']}',
                                          style: AppStyles.heading.copyWith(
                                            color: AppColors.text2,
                                            fontSize: AppSizes.size14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        'Total Prize: ${(double.parse(data['perKill']!) + double.parse(data['winningPrize']!) + double.parse(data['secondPrize']!) + double.parse(data['thirdPrize']!)).toStringAsFixed(2)}',
                                        style: AppStyles.heading.copyWith(
                                          color: AppColors.text2,
                                          fontSize: AppSizes.size14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
