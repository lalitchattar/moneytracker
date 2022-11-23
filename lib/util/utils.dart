import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';

import 'constants.dart';

class Utils {
  /*static dynamic formatNumber(dynamic number) {
    NumberFormat formatPattern;
    if(number == 0) {
      formatPattern = NumberFormat("0.00", "en_US");
    } else {
      formatPattern = NumberFormat("###.00", "en_US");
    }
    return formatPattern.format(number);
  }*/

  static String formatDate(String dateTime) {
    DateTime dateTimeObj = DateFormat("dd-MM-yyyy").parse(dateTime);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTimeObj);
  }

  static String formatTime(String dateTime) {
    DateTime dateTimeObj = DateFormat("dd-MM-yyyy HH:mm").parse(dateTime);
    return DateFormat.jm().format(dateTimeObj);
  }

  static double calculateXPercentageOfY(double x, double y) {
    return double.parse(formatNumber(((x / y) * 100)));
  }

  static double calculateExceedAmount(double expense, double budget) {
    return double.parse(formatNumber((expense - budget) > 0 ? (expense - budget) : 0));
  }

  ///////////////////////////////////////////////////////////////

  static Color getColorFromColorCode(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String formatNumber(double number) {
    NumberFormat formatPattern;
    if (number == 0) {
      formatPattern = NumberFormat("0.00", "en_US");
    } else {
      formatPattern = NumberFormat("###.00", "en_US");
    }
    return formatPattern.format(number);
  }

  static String formatDateTime(String dateTime, String format) {
    DateTime dateTimeObj = DateFormat(format).parse(dateTime);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTimeObj);
  }

  static String formattedMoney(num amount, String code) {
    Money money = Money.fromNum(amount, code: code);
    return money.format("S${Constants.currencyFormat}").toString();
  }
}
