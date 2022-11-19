class Transactions {
  late int id;
  late String dateAndTime;
  late String transactionType;
  late int? fromAccount;
  late int? toAccount;
  late int category;
  late String? accountName;
  late String? categoryName;
  late String? fromAccountName;
  late String toAccountName;
  late String transactionCategoryName;
  late double finalAmount;
  late String? description;
  late int isDeleted;
  late int excludeFromSummary;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["TRANSACTION_DATE"] = dateAndTime;
    map["TRANSACTION_TYPE"] = transactionType;
    map["FROM_ACCOUNT"] = fromAccount;
    map["TO_ACCOUNT"] = toAccount;
    map["CATEGORY"] = category;
    map["FINAL_AMOUNT"] = finalAmount;
    map["DESCRIPTION"] = description;
    map["IS_DELETED"] = isDeleted;
    map["EXCLUDED_FROM_SUMMARY"] = excludeFromSummary;
    return map;
  }

  Transactions.fromMapObject(Map<String, dynamic> map) {
    id = map["ID"];
    dateAndTime = map["TRANSACTION_DATE"];
    transactionType = map["TRANSACTION_TYPE"];
    fromAccount = map["FROM_ACCOUNT"];
    toAccount = map["TO_ACCOUNT"];
    category = map["CATEGORY"];
    finalAmount = map["FINAL_AMOUNT"];
    description = map["DESCRIPTION"];
    accountName = map.containsKey("ACCOUNT_NAME") ? map["ACCOUNT_NAME"] : null;
    fromAccountName = map["FROM_ACCOUNT_NAME"] ?? "";
    toAccountName = map["TO_ACCOUNT_NAME"] ?? "";
    categoryName = map.containsKey("CATEGORY_NAME") ? map["CATEGORY_NAME"] : null;
    transactionCategoryName = map["TRANSACTION_CATEGORY_NAME"];
    isDeleted = map["IS_DELETED"];
    excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
  }
}