class Config {
  late int id;
  late String configKey;
  late String configValue;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["CONFIG_KEY"] = configKey;
    map["CONFIG_VALUE"] = configValue;
    return map;
  }

  Config.fromMapObject(Map<String, dynamic> map) {
    id = map["ID"];
    configKey = map["CONFIG_KEY"];
    configValue = map["CONFIG_VALUE"];
  }
}