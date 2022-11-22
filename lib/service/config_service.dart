import 'package:sqflite/sqflite.dart';

import '../model/config.dart';
import '../util/database_helper.dart';

class ConfigService {

  Future<List<Config>> getConfigMap() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    String resultQuery = """
        SELECT * FROM CONFIG;
      """;
    var result = await database
        .rawQuery(resultQuery);
    return result.map((config) => Config.fromMapObject(config)).toList();
  }
}