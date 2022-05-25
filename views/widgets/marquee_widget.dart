import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final Axis scrollAxis;
  final double ratioOfBlankToScreen;

  // ignore: use_key_in_widget_constructors
  const MarqueeWidget({
    @required this.text,
    this.textStyle,
    this.scrollAxis = Axis.horizontal,
    this.ratioOfBlankToScreen = 0.25,
  }) : assert(
          text != null,
        );

  @override
  State<StatefulWidget> createState() {
    return MarqueeWidgetState();
  }
}

class MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin {
  ScrollController? scroController;
  double? screenWidth;
  double? screenHeight;
  double position = 0.0;
  Timer? timer;
  final double _moveDistance = 3.0;
  final int _timerRest = 100;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    scroController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      startTimer();
    });
  }

  void startTimer() {
    double widgetWidth =
        _key.currentContext!.findRenderObject()!.paintBounds.size.width;
    double widgetHeight =
        _key.currentContext!.findRenderObject()!.paintBounds.size.height;
    timer = Timer.periodic(Duration(milliseconds: _timerRest), (timer) {
      double maxScrollExtent = scroController!.position.maxScrollExtent;
      double pixels = scroController!.position.pixels;
      if (pixels + _moveDistance >= maxScrollExtent) {
        if (widget.scrollAxis == Axis.horizontal) {
          position = (maxScrollExtent -
                      screenWidth! * widget.ratioOfBlankToScreen +
                      widgetWidth) /
                  2 -
              widgetWidth +
              pixels -
              maxScrollExtent;
        } else {
          position = (maxScrollExtent -
                      screenHeight! * widget.ratioOfBlankToScreen +
                      widgetHeight) /
                  2 -
              widgetHeight +
              pixels -
              maxScrollExtent;
        }
        scroController!.jumpTo(position);
      }
      position += _moveDistance;
      scroController!.animateTo(position,
          duration: Duration(milliseconds: _timerRest), curve: Curves.linear);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  Widget getBothEndsChild() {
    if (widget.scrollAxis == Axis.vertical) {
      String newString = widget.text!.split("").join("\n");
      return Center(
        child: Text(
          newString,
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Center(
        child: Text(
      widget.text ?? '',
      style: widget.textStyle,
    ));
  }

  Widget getCenterChild() {
    if (widget.scrollAxis == Axis.horizontal) {
      return Container(width: screenWidth! * widget.ratioOfBlankToScreen);
    } else {
      return Container(height: screenHeight! * widget.ratioOfBlankToScreen);
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: _key,
      scrollDirection: widget.scrollAxis,
      controller: scroController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        getBothEndsChild(),
        getCenterChild(),
        getBothEndsChild(),
      ],
    );
  }
}
