import 'package:flutter/material.dart';
import '/consts/consts.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({
    Key? key,
    required this.total,
    required this.booked,
  }) : super(key: key);

  final double total;
  final double booked;

  @override
  CustomProgressIndicatorState createState() => CustomProgressIndicatorState();
}

class CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  Animation? animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation =
        Tween(begin: widget.booked, end: widget.total).animate(controller!)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    controller?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: LinearProgressIndicator(
          color: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withOpacity(0.2),
          value: animation?.value,
        ),
      ),
    );
  }
}
