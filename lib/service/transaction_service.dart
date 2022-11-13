import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:sqflite/sqflite.dart';

import '../util/database_helper.dart';
import 'package:moneytracker/model/transactions.dart';

class TransactionService {
  final String _tableName = "TRANSACTIONS";

  Future<int> createTransaction(
      Map<String, dynamic>? transaction, String type) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawInsert(
        """INSERT INTO TRANSACTIONS("TRANSACTION_DATE", "TRANSACTION_TYPE",
      "FROM_ACCOUNT",
     "TO_ACCOUNT", "CATEGORY",
      "FINAL_AMOUNT", "DESCRIPTION") VALUES(?, ?, ?, ?, ?, ?, ?)""",
        [
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
    var result = await database
        .rawQuery("SELECT * FROM TRANSACTION WHERE IS_DELETED = ?", [0]);
    return result
        .map((transaction) => Transactions.fromMapObject(transaction))
        .toList();
  }

  Future<List<Transactions>> getTransactionsPageWise(
      int limit, int offset) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        """SELECT T.*, A.ACCOUNT_NAME, C.CATEGORY_NAME FROM TRANSACTIONS T, ACCOUNT A, 
        CATEGORY C WHERE (A.ID = T.TO_ACCOUNT OR A.ID = T.FROM_ACCOUNT) 
        AND C.ID = T.CATEGORY AND T.IS_DELETED = ? ORDER BY TRANSACTION_DATE DESC LIMIT ? OFFSET ?""",
        [0, limit, offset]);
    return result
        .map((transactions) => Transactions.fromMapObject(transactions))
        .toList();
  }

  Future<List<Transactions>> getTransactionsById(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        """SELECT T.*, A.ACCOUNT_NAME, C.CATEGORY_NAME FROM TRANSACTIONS T, ACCOUNT A, 
        CATEGORY C WHERE (A.ID = T.TO_ACCOUNT OR A.ID = T.FROM_ACCOUNT) 
        AND C.ID = T.CATEGORY AND T.IS_DELETED = ? AND T.ID = ?""",
        [0, id]);
    return result
        .map((transactions) => Transactions.fromMapObject(transactions))
        .toList();
  }

  Future<int?> getTransactionCountByAccountId(int id) async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        "SELECT COUNT(*) FROM TRANSACTIONS WHERE (TO_ACCOUNT = ? OR FROM_ACCOUNT = ?) AND IS_DELETED = ?",
        [id, id, 0]);
    return Sqflite.firstIntValue(result);
  }

}
