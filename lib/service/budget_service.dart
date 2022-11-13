import 'package:sqflite/sqflite.dart';

import '../util/database_helper.dart';

class BudgetService {

  final String _tableName = "BUDGET";

  Future<int> checkBudgetExists() async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        "SELECT COUNT(*) FROM BUDGET WHERE IS_DELETED = ?",
        [0]);
    return Sqflite.firstIntValue(result)!;
  }

  Future<int> createBudgetEntry(Map<String, dynamic>? budget) async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.insert(_tableName, budget!);
    return result;
  }
}