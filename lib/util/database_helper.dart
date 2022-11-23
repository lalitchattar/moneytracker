import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  static const String _account = """ CREATE TABLE ACCOUNT (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        ACCOUNT_NAME TEXT NOT NULL,
        AVAILABLE_BALANCE REAL DEFAULT 0,
        DESCRIPTION TEXT,
        IS_CREDIT_CARD INTEGER DEFAULT 0,
        CREDIT_LIMIT REAL DEFAULT 0,
        OUTSTANDING_BALANCE REAL DEFAULT 0,
        BILLING_DAY TEXT,
        GRACE_PERIOD TEXT,
        CREDITED_AMOUNT REAL DEFAULT 0,
        DEBITED_AMOUNT REAL DEFAULT 0,
        IN_TRANSACTION INTEGER DEFAULT 0,
        OUT_TRANSACTION INTEGER DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SUSPENDED INTEGER DEFAULT 0,
        EXCLUDED_FROM_SUMMARY INTEGER DEFAULT 0
      )
      """;

  static const String _defaultAccount = """INSERT INTO ACCOUNT(ACCOUNT_NAME, DESCRIPTION) VALUES('Cash', 'Cash')""";

  static const String _category = """ CREATE TABLE CATEGORY (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        CATEGORY_NAME TEXT UNIQUE NOT NULL,
        CATEGORY_TYPE TEXT,
        DESCRIPTION TEXT,
        PARENT_CATEGORY INTEGER DEFAULT 0,
        ICON_ID INTEGER DEFAULT 0,
        EDITABLE INTEGER DEFAULT 0,
        CREDITED_AMOUNT REAL DEFAULT 0,
        DEBITED_AMOUNT REAL DEFAULT 0,
        IN_TRANSACTION INTEGER DEFAULT 0,
        OUT_TRANSACTION INTEGER DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SUSPENDED INTEGER DEFAULT 0,
        EXCLUDED_FROM_SUMMARY INTEGER DEFAULT 0
      )""";

  static const _categoryInsert = """ INSERT INTO CATEGORY(
      CATEGORY_NAME, CATEGORY_TYPE, DESCRIPTION, PARENT_CATEGORY, ICON_ID, EDITABLE
      ) SELECT 'Beauty', 'E', 'Beauty', 0, 1, 1 UNION ALL
      SELECT 'Bills', 'E', 'Bills', 0, 2, 1 UNION ALL
      SELECT 'Cable', 'E', 'Cable', 2, 3, 1 UNION ALL
      SELECT 'Electricity', 'E', 'Electricity', 2, 4, 1 UNION ALL
      SELECT 'Water', 'E', 'Water', 2, 5, 1 UNION ALL
      SELECT 'Books', 'E', 'Books', 0, 6, 1 UNION ALL
      SELECT 'Dining', 'E', 'Dining', 0, 7, 1 UNION ALL
      SELECT 'Discount', 'I', 'Discount', 0, 8, 1 UNION ALL
      SELECT 'Cashback', 'I', 'Cashback', 0, 9, 1 UNION ALL
      SELECT 'Donation', 'E', 'Donation', 0, 10, 1 UNION ALL
      SELECT 'Education', 'E', 'Education', 0, 11, 1 UNION ALL
      SELECT 'Entertainment', 'E', 'Entertainment', 0, 12, 1 UNION ALL
      SELECT 'Movies', 'E', 'Movies', 12, 13, 1 UNION ALL
      SELECT 'Food & Drinks', 'E', 'Food & Drinks', 0, 14, 1 UNION ALL
      SELECT 'Fuel', 'E', 'Fuel', 0, 15, 1 UNION ALL
      SELECT 'Gas', 'E', 'Gas', 0, 16, 1 UNION ALL
      SELECT 'Grocery', 'E', 'Grocery', 0, 17, 1 UNION ALL
      SELECT 'Health', 'E', 'Health', 0, 18, 1 UNION ALL
      SELECT 'Medicines', 'E', 'Medicines', 18, 19, 1 UNION ALL
      SELECT 'Household', 'E', 'Household', 0, 20, 1 UNION ALL
      SELECT 'Interest', 'I', 'Interest', 0, 21, 1 UNION ALL
      SELECT 'Kids', 'E', 'Kids', 0, 22, 1 UNION ALL
      SELECT 'Maintenance', 'E', 'Maintenance', 0, 23, 1 UNION ALL
      SELECT 'Others', 'B', 'Others', 0, 24, 1 UNION ALL
      SELECT 'Recharge', 'E', 'Recharge', 0, 25, 1 UNION ALL
      SELECT 'Salary', 'I', 'Salary', 0, 26, 1 UNION ALL
      SELECT 'Bonus', 'I', 'Bonus', 0, 27, 1 UNION ALL
      SELECT 'Shopping', 'E', 'Shopping', 0, 28, 1 UNION ALL
      SELECT 'Clothes', 'E', 'Clothes', 28, 29, 1 UNION ALL
      SELECT 'Electronics', 'E', 'Electronics', 28, 30, 1 UNION ALL
      SELECT 'Jewellery', 'E', 'Jewellery', 28, 31, 1 UNION ALL
      SELECT 'Stationery', 'E', 'Stationery', 0, 32, 1 UNION ALL
      SELECT 'Tax', 'E', 'Tax', 0, 33, 1 UNION ALL
      SELECT 'Transport', 'E', 'Transport', 0, 34, 1 UNION ALL
      SELECT 'Travel', 'E', 'Travel', 0, 35, 1 UNION ALL
      SELECT 'Utilities', 'E', 'Utilities', 0, 36, 1 UNION ALL
      SELECT 'Vacation', 'E', 'Vacation', 0, 37, 1 """;

  static const String _transaction = """ CREATE TABLE TRANSACTIONS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        TRANSACTION_DATE TEXT NOT NULL,
        TRANSACTION_TYPE TEXT NOT NULL,
        FROM_ACCOUNT INTEGER,
        TO_ACCOUNT INTEGER,
        CATEGORY INTEGER,
        FINAL_AMOUNT REAL NOT NULL,
        DESCRIPTION TEXT,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SUSPENDED INTEGER DEFAULT 0,
        EXCLUDED_FROM_SUMMARY INTEGER DEFAULT 0
      )""";

  static const String _budget = """ CREATE TABLE BUDGET (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        BUDGET_AMOUNT REAL NOT NULL,
        FOR_YEAR INTEGER NOT NULL DEFAULT 0,
        ALERT_ENABLED INTEGER NOT NULL DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0
      )""";

  static const String _config = """ CREATE TABLE CONFIG (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        CONFIG_KEY TEXT NOT NULL,
        CONFIG_VALUE TEXT NOT NULL
      )""";

  static const _configInsert = """ INSERT INTO CONFIG(
      CONFIG_KEY, CONFIG_VALUE
      ) SELECT 'CURRENCY', 'INR (₹)' UNION ALL
      SELECT 'IS_REMINDER_SET', '0' UNION ALL
      SELECT 'REMINDER_TIME', '20:00 PM' """;

  DatabaseHelper._createInstance();

  Future<Database> get database async {
    return _database ??= await initializeDatabase();
  }

  factory DatabaseHelper() {
    return _databaseHelper ??= DatabaseHelper._createInstance();
  }

  void _createDB(Database database, int version) async {
    await database.execute(_account);
    await database.execute(_defaultAccount);
    await database.execute(_category);
    await database.execute(_categoryInsert);
    await database.execute(_transaction);
    await database.execute(_budget);
    await database.execute(_config);
    await database.execute(_configInsert);
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/moneytracker.db";
    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }
}
