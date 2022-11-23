import 'package:moneytracker/service/config_service.dart';

import '../model/config.dart';

class ApplicationConfig {
  static const isReminderSet = "IS_REMINDER_SET";
  static const currency = "CURRENCY";
  static const reminderZero = "0";
  static const reminderOne = "1";

  static ApplicationConfig? _applicationConfig;
  static Map<String, String> _configMap = {};

  ApplicationConfig._createInstance();

  factory ApplicationConfig() {
    return _applicationConfig ??= ApplicationConfig._createInstance();
  }

  Map<String, String>? get configMap {
    return _configMap;
  }

  bool getReminderSetting() {
    return _configMap[isReminderSet] == reminderZero ? false : true;
  }

  void setReminderSetting(String value) {
    _configMap[isReminderSet] = value;
  }

  void setCurrencySetting(String value) {
    _configMap[currency] = value;
  }
}
