class Transactions {
  late int _id;
  late String _dateAndTime;
  late String _transactionType;
  late int? _fromAccount;
  late int? _toAccount;
  late int _category;
  late String? _accountName;
  late String? _categoryName;
  late double _finalAmount;
  late String? _description;
  late int _isDeleted;
  late int _excludeFromSummary;

  int? get id => _id;
  String get dateAndTime => _dateAndTime;
  String get transactionType => _transactionType;
  int? get fromAccount => _fromAccount;
  int? get toAccount => _toAccount;
  int get category => _category;
  double get finalAmount => _finalAmount;
  String? get description => _description;
  String? get categoryName => _categoryName;
  String? get accountName => _accountName;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["TRANSACTION_DATE"] = _dateAndTime;
    map["TRANSACTION_TYPE"] = _transactionType;
    map["FROM_ACCOUNT"] = _fromAccount;
    map["TO_ACCOUNT"] = _toAccount;
    map["CATEGORY"] = _category;
    map["FINAL_AMOUNT"] = _finalAmount;
    map["DESCRIPTION"] = _description;
    map["IS_DELETED"] = _isDeleted;
    map["EXCLUDED_FROM_SUMMARY"] = _excludeFromSummary;
    return map;
  }

  Transactions.fromMapObject(Map<String, dynamic> map) {
    _id = map["ID"];
    _dateAndTime = map["TRANSACTION_DATE"];
    _transactionType = map["TRANSACTION_TYPE"];
    _fromAccount = map["FROM_ACCOUNT"];
    _toAccount = map["TO_ACCOUNT"];
    _category = map["CATEGORY"];
    _finalAmount = map["FINAL_AMOUNT"];
    _description = map["DESCRIPTION"];
    _accountName = map.containsKey("ACCOUNT_NAME") ? map["ACCOUNT_NAME"] : null;
    _categoryName = map.containsKey("CATEGORY_NAME") ? map["CATEGORY_NAME"] : null;
    _isDeleted = map["IS_DELETED"];
    _excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
  }
}