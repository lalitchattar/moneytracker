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

  Future<List<Account>> getAllAccounts() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery("SELECT * FROM ACCOUNT WHERE IS_DELETED = ?", [0]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  Future<List<Account>> getAccountByName(String name) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        'SELECT * FROM ACCOUNT WHERE ACCOUNT_NAME = ? AND IS_DELETED = ? COLLATE NOCASE',
        [name.trim(), 0]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  Future<List<Account>> getAccountById(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result =
        await database.rawQuery('SELECT * FROM ACCOUNT WHERE ID = ?', [id]);
    return result.map((account) => Account.fromMapObject(account)).toList();
  }

  void deleteAccount(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery('UPDATE ACCOUNT SET IS_DELETED = ? WHERE ID = ?', [1, id]);
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
      List<dynamic> params = [account!["ACCOUNT_NAME"],account!["CREDIT_LIMIT"], account!["OUTSTANDING_BALANCE"], account!["BILLING_DAY"], account!["GRACE_PERIOD"], account!["AVAILABLE_BALANCE"], account!["DESCRIPTION"], id];
      await database.rawQuery(updateQuery, params);
    } else {
      String updateQuery = """
      UPDATE ACCOUNT SET ACCOUNT_NAME = ?, 
      AVAILABLE_BALANCE = ?, DESCRIPTION = ? WHERE ID = ?
      """;
      List<dynamic> params = [account!["ACCOUNT_NAME"], account!["AVAILABLE_BALANCE"], account!["DESCRIPTION"], id];
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
}
