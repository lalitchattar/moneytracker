import 'package:sqflite/sqflite.dart';

import '../util/database_helper.dart';
import 'package:moneytracker/model/transactions.dart';

class TransactionService {

  final String _tableName = "TRANSACTIONS";

  Future<int> createTransaction(Map<String, dynamic>? transaction, String type) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawInsert("""INSERT INTO TRANSACTIONS("TRANSACTION_DATE", "TRANSACTION_TYPE",
      "FROM_ACCOUNT",
     "TO_ACCOUNT", "CATEGORY",
      "FINAL_AMOUNT", "DESCRIPTION") VALUES(?, ?, ?, ?, ?, ?, ?)""", [
        transaction!['TRANSACTION_DATE'],
        type,
        transaction!['FROM_ACCOUNT'],
        transaction!['TO_ACCOUNT'],
        transaction!['CATEGORY'],
        transaction!['FINAL_AMOUNT'],
        transaction!['DESCRIPTION']
    ]);
    return result;
  }

  Future<List<Transactions>> getAllTransaction() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        "SELECT * FROM TRANSACTION WHERE IS_DELETED = ?",
        [0]);
    return result.map((transaction) => Transactions.fromMapObject(transaction)).toList();
  }
}