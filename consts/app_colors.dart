import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static final Color primary = Color(0xFF166b4a);
  static final Color secondary = Color(0xFF0d4a33);
  static const Color white = Colors.white;
  static Color whiteLess = Colors.white.withValues(alpha: .75);
  static const Color black = Colors.black;
  static final Color blackLess = Colors.black.withValues(alpha: .7);
  static final Color border = Colors.grey.withValues(alpha: 0.5);
  static final Color background = HexColor('#F5F5F7');
  static final Color transparent = Colors.transparent;
}
