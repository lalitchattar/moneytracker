import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneytracker/util/utils.dart';

class ThemeUtil {
  //Theming
  static const String defaultThemeColor = "#5730E3";
  static const String defaultThemeAppBarTextColor = "#FFFFFF";
  static const String defaultExpenseColor = "#E33363";
  static const String defaultThemeScaffoldBackgroundColor = "#D3D3DB";

  static Color getDefaultThemeColor() {
    return Utils.getColorFromColorCode(defaultThemeColor);
  }

  static Color getDefaultThemeExpenseColor() {
    return Utils.getColorFromColorCode(defaultExpenseColor);
  }

  static Color getDefaultThemeScaffoldBackgroundColor() {
    return Utils.getColorFromColorCode(defaultThemeScaffoldBackgroundColor);
  }

  static Color getDefaultThemeAppBarTextColor() {
    return Utils.getColorFromColorCode(defaultThemeAppBarTextColor);
  }
}
