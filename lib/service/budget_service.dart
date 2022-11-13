import 'package:moneytracker/model/budget_model.dart';
import 'package:moneytracker/screen/budget.dart';
import 'package:sqflite/sqflite.dart';

import '../util/database_helper.dart';

class BudgetService {

  final String _tableName = "BUDGET";

  Future<List<BudgetModel>> checkBudgetExists() async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        "SELECT * FROM BUDGET WHERE IS_DELETED = ?",
        [0]);
    return result.map((record) => BudgetModel.fromMapObject(record)).toList();
  }

  Future<int> createBudgetEntry(Map<String, dynamic>? budget) async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.insert(_tableName, budget!);
    return result;
  }

  Future<List<BudgetModel>> getDataForBudgetChart(String fromDate, String toDate, type) async{
    String query = """SELECT COUNT(T.FINAL_AMOUNT) AS TOTAL_TRANSACTION, B.BUDGET_AMOUNT, SUM(T.FINAL_AMOUNT) AS EXPENSE, AVG(T.FINAL_AMOUNT) AS AVG_EXPENSE, 
         MAX(T.FINAL_AMOUNT) AS HIGHEST, MIN(T.FINAL_AMOUNT) AS LOWEST FROM TRANSACTIONS T, BUDGET B WHERE DATE(SUBSTR(T.TRANSACTION_DATE,7,4)
        ||'-'
        || SUBSTR(T.TRANSACTION_DATE,4,2)
        ||'-'
        || SUBSTR(T.TRANSACTION_DATE,1,2)) BETWEEN DATE(?) AND DATE(?) AND T.IS_DELETED = ? AND IS_SUSPENDED = ? 
        GROUP BY T.TRANSACTION_TYPE HAVING T.TRANSACTION_TYPE = ?""";

        DatabaseHelper databaseHelper = DatabaseHelper();
        Database database = await databaseHelper.database;
        var result = await database.rawQuery(query, [fromDate, toDate, 0, 0, type]);
        return result.map((records) => BudgetModel.fromMapObjectForCHart(records)).toList();
  }
}