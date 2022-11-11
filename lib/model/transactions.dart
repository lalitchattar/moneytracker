class Transactions {
  late int _id;
  late String _dateAndTime;
  late String _transactionType;
  late String? _fromAccount;
  late String? _toAccount;
  late String _category;
  late double _finalAmount;
  late String? _description;
  late int _isDeleted;
  late int _excludeFromSummary;

  int? get id => _id;
  String get dateAndTime => _dateAndTime;
  String get transactionType => _transactionType;
  String? get fromAccount => _fromAccount;
  String? get toAccount => _toAccount;
  String get category => _category;
  double get finalAmount => _finalAmount;
  String? get description => _description;

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
    _isDeleted = map["IS_DELETED"];
    _excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
  }
}