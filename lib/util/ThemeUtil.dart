import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneytracker/util/constants.dart';
import 'package:moneytracker/util/utils.dart';

class ThemeUtil {

  //Theming
  static const String defaultThemeColor = "#5730E3";
  static const String defaultThemeAppBarTitleColor = "#FFFFFF";
  static const String defaultHomePageMainContainerColor = "#FFFFFF";
  static const String defaultExpenseColor = "#E33363";

  static Color getDefaultThemeColor() {
    return Utils.getColorFromColorCode(defaultThemeColor);
  }

  static Color getDefaultThemeAppBarTitleColor() {
    return Utils.getColorFromColorCode(defaultThemeAppBarTitleColor);
  }

  static Color getDefaultThemeExpenseColor() {
    return Utils.getColorFromColorCode(defaultExpenseColor);
  }

}