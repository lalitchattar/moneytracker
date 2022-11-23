import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AccountService {
  final String _tableName = "ACCOUNT";

  Future<int> createAccount(Map<String, dynamic>? account) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.insert(_tableName, account!);
    return result;
  }

  Future<List<Account>> getAllAccounts(bool fetchSuspended) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery("SELECT * FROM ACCOUNT WHERE IS_DELETED = ? AND IS_SUSPENDED <= ? ORDER BY IS_SUSPENDED ASC", [0, fetchSuspended ? 1 : 0]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  Future<List<Account>> getAllAccountsByType(bool isCreditCard) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery("SELECT * FROM ACCOUNT WHERE IS_DELETED = ? AND IS_CREDIT_CARD = ?", [0, isCreditCard ? 1 : 0]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  Future<List<Account>> getAccountByName(String name) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery('SELECT * FROM ACCOUNT WHERE ACCOUNT_NAME = ? AND IS_DELETED = ? COLLATE NOCASE', [name.trim(), 0]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  Future<List<Account>> getAccountById(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery('SELECT * FROM ACCOUNT WHERE ID = ?', [id]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  void deleteAccount(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery('UPDATE ACCOUNT SET IS_DELETED = ? WHERE ID = ?', [1, id]);
  }

  Future<void> updateAccount(Map<String, dynamic>? account, bool isCreditCard, int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    if (isCreditCard) {
      String updateQuery = """
      UPDATE ACCOUNT SET ACCOUNT_NAME = ?, CREDIT_LIMIT = ?, OUTSTANDING_BALANCE = ?,
      BILLING_DAY = ?, GRACE_PERIOD = ?, 
      AVAILABLE_BALANCE = ?, DESCRIPTION = ? WHERE ID = ?
      """;
      List<dynamic> params = [
        account!["ACCOUNT_NAME"],
        account!["CREDIT_LIMIT"],
        account!["OUTSTANDING_BALANCE"],
        account!["BILLING_DAY"],
        account!["GRACE_PERIOD"],
        account!["AVAILABLE_BALANCE"],
        account!["DESCRIPTION"],
        id
      ];
      await database.rawQuery(updateQuery, params);
      await updateOutstandingBalance(id);
    } else {
      String updateQuery = """
      UPDATE ACCOUNT SET ACCOUNT_NAME = ?, 
      AVAILABLE_BALANCE = ?, DESCRIPTION = ? WHERE ID = ?
      """;
      List<dynamic> params = [account!["ACCOUNT_NAME"], account!["AVAILABLE_BALANCE"], account!["DESCRIPTION"], id];
      await database.rawQuery(updateQuery, params);
    }
  }

  Future<void> updateAccountForInTransaction(Map<String, dynamic>? account, bool isCreditCard, int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    if (isCreditCard) {
      String updateQuery = """
      UPDATE ACCOUNT SET OUTSTANDING_BALANCE = ?,
      AVAILABLE_BALANCE = ?, IN_TRANSACTION = ?, 
      CREDITED_AMOUNT = ? WHERE ID = ?
      """;
      List<dynamic> params = [
        account!["OUTSTANDING_BALANCE"],
        account!["AVAILABLE_BALANCE"],
        account!["IN_TRANSACTION"],
        account!["CREDITED_AMOUNT"],
        id
      ];
      await database.rawQuery(updateQuery, params);
    } else {
      String updateQuery = """
      UPDATE ACCOUNT SET AVAILABLE_BALANCE = ?, 
      CREDITED_AMOUNT = ?, IN_TRANSACTION = ? WHERE ID = ?
      """;
      List<dynamic> params = [account!["AVAILABLE_BALANCE"], account!["CREDITED_AMOUNT"], account!["IN_TRANSACTION"], id];
      await database.rawQuery(updateQuery, params);
    }
  }

  Future<void> updateAccountForOutTransaction(Map<String, dynamic>? account, bool isCreditCard, int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    if (isCreditCard) {
      String updateQuery = """
      UPDATE ACCOUNT SET OUTSTANDING_BALANCE = ?,
      AVAILABLE_BALANCE = ?, OUT_TRANSACTION = ?, 
      DEBITED_AMOUNT = ? WHERE ID = ?
      """;
      List<dynamic> params = [
        account!["OUTSTANDING_BALANCE"],
        account!["AVAILABLE_BALANCE"],
        account!["OUT_TRANSACTION"],
        account!["DEBITED_AMOUNT"],
        id
      ];
      await database.rawQuery(updateQuery, params);
    } else {
      String updateQuery = """
      UPDATE ACCOUNT SET AVAILABLE_BALANCE = ?, 
      DEBITED_AMOUNT = ?, OUT_TRANSACTION = ? WHERE ID = ?
      """;
      List<dynamic> params = [account!["AVAILABLE_BALANCE"], account!["DEBITED_AMOUNT"], account!["OUT_TRANSACTION"], id];
      await database.rawQuery(updateQuery, params);
    }
  }

  Future<void> updateOutstandingBalance(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    String updateQuery = """
        UPDATE ACCOUNT SET OUTSTANDING_BALANCE = (CREDIT_LIMIT - AVAILABLE_BALANCE) WHERE ID = ? AND AVAILABLE_BALANCE != 0;
      """;
    List<dynamic> params = [id];
    await database.rawQuery(updateQuery, params);
  }

  void toggleSuspendAccount(int id, int flag) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery('UPDATE ACCOUNT SET IS_SUSPENDED = ? WHERE ID = ?', [flag, id]);
  }

  Future<List> getTotalBalance() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    String resultQuery = """
        SELECT SUM(AVAILABLE_BALANCE) AS AVAILABLE_BALANCE FROM ACCOUNT WHERE IS_DELETED = ? AND IS_SUSPENDED = ? AND EXCLUDED_FROM_SUMMARY = ? AND IS_CREDIT_CARD = ?
      """;
    var result = await database.rawQuery(resultQuery, [0, 0, 0, 0]);
    return result.toList();
  }
}
