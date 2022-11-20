import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneytracker/util/utils.dart';

class ThemeUtil {

  //Theming
  static const String _defaultThemeColor = "#5730E3";
  static const String _defaultThemeAppBarTextColor = "#FFFFFF";
  static const String _defaultExpenseColor = "#E33363";
  static const String _defaultThemeScaffoldBackgroundColor = "#D3D3DB";

  static Color getDefaultThemeColor() {
    return Utils.getColorFromColorCode(_defaultThemeColor);
  }

  static Color getDefaultThemeExpenseColor() {
    return Utils.getColorFromColorCode(_defaultExpenseColor);
  }

  static Color getDefaultThemeScaffoldBackgroundColor() {
    return Utils.getColorFromColorCode(_defaultThemeScaffoldBackgroundColor);
  }

  static Color getDefaultThemeAppBarTextColor() {
    return Utils.getColorFromColorCode(_defaultThemeAppBarTextColor);
  }

}