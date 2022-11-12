import 'package:intl/intl.dart';

class Utils {
  static dynamic formatNumber(dynamic number) {
    NumberFormat formatPattern;
    if(number == 0) {
      formatPattern = NumberFormat("0.00", "en_US");
    } else {
      formatPattern = NumberFormat("###.00", "en_US");
    }
    return formatPattern.format(number);
  }

  static String formatDate(String dateTime) {
    DateTime dateTimeObj = DateFormat("dd-MM-yyyy").parse(dateTime);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTimeObj);
  }

  static String formatTime(String dateTime) {
    DateTime dateTimeObj = DateFormat("dd-MM-yyyy HH:mm").parse(dateTime);
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTimeObj);
  }
}