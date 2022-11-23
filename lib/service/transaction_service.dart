import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/service/account_service.dart';
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
    var result = await database.rawQuery("SELECT * FROM TRANSACTION WHERE IS_DELETED = ?", [0]);
    return result.map((transaction) => Transactions.fromMapObject(transaction)).toList();
  }

  Future<List<Transactions>> getTransactionsPageWise(int limit, int offset) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery("""SELECT T.ID, T.TRANSACTION_DATE, T.TRANSACTION_TYPE, T.FROM_ACCOUNT, T.TO_ACCOUNT, IFNULL(T.CATEGORY, 0) AS CATEGORY,
 T.FINAL_AMOUNT, T.DESCRIPTION, T.IS_DELETED, T.EXCLUDED_FROM_SUMMARY, A.ACCOUNT_NAME AS FROM_ACCOUNT_NAME, B.ACCOUNT_NAME AS TO_ACCOUNT_NAME, 
 IFNULL(C.CATEGORY_NAME, "Transfer") AS TRANSACTION_CATEGORY_NAME FROM TRANSACTIONS AS T 
LEFT JOIN ACCOUNT AS A ON A.ID = T.FROM_ACCOUNT 
LEFT JOIN ACCOUNT AS B ON B.ID = T.TO_ACCOUNT 
LEFT JOIN CATEGORY AS C ON C.ID = T.CATEGORY WHERE T.IS_DELETED = ? ORDER BY T.ID DESC LIMIT ? OFFSET ? """, [0, limit, offset]);
    return result.map((transactions) => Transactions.fromMapObject(transactions)).toList();
  }

  Future<List<Transactions>> getTransactionsById(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery("""SELECT T.ID, T.TRANSACTION_DATE, T.TRANSACTION_TYPE, T.FROM_ACCOUNT, T.TO_ACCOUNT, IFNULL(T.CATEGORY, 0) AS CATEGORY,
 T.FINAL_AMOUNT, T.DESCRIPTION, T.IS_DELETED, T.EXCLUDED_FROM_SUMMARY, A.ACCOUNT_NAME AS FROM_ACCOUNT_NAME, B.ACCOUNT_NAME AS TO_ACCOUNT_NAME, 
 IFNULL(C.CATEGORY_NAME, "Transfer") AS TRANSACTION_CATEGORY_NAME FROM TRANSACTIONS AS T 
LEFT JOIN ACCOUNT AS A ON A.ID = T.FROM_ACCOUNT 
LEFT JOIN ACCOUNT AS B ON B.ID = T.TO_ACCOUNT 
LEFT JOIN CATEGORY AS C ON C.ID = T.CATEGORY WHERE T.IS_DELETED = ? AND T.ID = ?""", [0, id]);
    return result.map((transactions) => Transactions.fromMapObject(transactions)).toList();
  }

  Future<int?> getTransactionCountByAccountId(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result =
        await database.rawQuery("SELECT COUNT(*) FROM TRANSACTIONS WHERE (TO_ACCOUNT = ? OR FROM_ACCOUNT = ?) AND IS_DELETED = ?", [id, id, 0]);
    return Sqflite.firstIntValue(result);
  }

  Future<List> getTotalIncomeAndExpenseInDateRange(String fromDate, String toDate, String type) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    String query = """SELECT T.TRANSACTION_TYPE, SUM(FINAL_AMOUNT) AS FINAL_AMOUNT FROM TRANSACTIONS T WHERE DATE(SUBSTR(T.TRANSACTION_DATE,7,4)
        ||'-'
        || SUBSTR(T.TRANSACTION_DATE,4,2)
        ||'-'
        || SUBSTR(T.TRANSACTION_DATE,1,2)) BETWEEN DATE(?) AND DATE(?) AND T.IS_DELETED = ? AND IS_SUSPENDED = ? AND EXCLUDED_FROM_SUMMARY = ?
        GROUP BY T.TRANSACTION_TYPE HAVING T.TRANSACTION_TYPE = ? ORDER BY TRANSACTION_TYPE""";

    var result = await database.rawQuery(query, [fromDate, toDate, 0, 0, 0, type]);

    return result.toList();
  }
}
