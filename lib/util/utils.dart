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
}