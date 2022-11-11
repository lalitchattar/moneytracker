class Account {
  late int _id;
  late String _accountName;
  late double _availableBalance;
  late int _isCreditCard;
  late String? _billingDay;
  late String? _gracePeriod;
  late double _creditLimit;
  late double _outstandingBalance;
  late String? _description;
  late double _debitedAmount;
  late double _creditedAmount;
  late int _inTransaction;
  late int _outTransaction;
  late int _isDeleted;
  late int _isSuspended;
  late int _excludeFromSummary;

  int? get id => _id;
  String get accountName => _accountName;
  double get availableBalance => _availableBalance;
  String? get billingDay => _billingDay;
  String? get gracePeriod => _gracePeriod;
  double? get creditLimit => _creditLimit;
  double? get outstandingBalance => _outstandingBalance;
  String? get description => _description;
  int get isCreditCard => _isCreditCard;
  int get inTransaction => _inTransaction;
  int get outTransaction => _outTransaction;
  double get creditedAmount => _creditedAmount;
  double get debitedAmount => _debitedAmount;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["ACCOUNT_NAME"] = _accountName;
    map["AVAILABLE_BALANCE"] = _availableBalance;
    map["IS_CREDIT_CARD"] = _isCreditCard;
    map["BILLING_DAY"] = _billingDay;
    map["GRACE_PERIOD"] = _gracePeriod;
    map["CREDIT_LIMIT"] = _creditLimit;
    map["OUTSTANDING_BALANCE"] = _outstandingBalance;
    map["DESCRIPTION"] = _description;
    map["DEBITED_AMOUNT"] = _debitedAmount;
    map["CREDITED_AMOUNT"] = _creditedAmount;
    map["IN_TRANSACTION"] = _inTransaction;
    map["OUT_TRANSACTION"] = _outTransaction;
    map["IS_DELETED"] = _isDeleted;
    map["IS_SUSPENDED"] = _isSuspended;
    map["EXCLUDED_FROM_SUMMARY"] = _excludeFromSummary;
    return map;
  }

  Account.fromMapObject(Map<String, dynamic> map) {
    _id = map["ID"];
    _accountName = map["ACCOUNT_NAME"];
    _availableBalance = map["AVAILABLE_BALANCE"];
    _isCreditCard = map["IS_CREDIT_CARD"];
    _billingDay = map["BILLING_DAY"];
    _gracePeriod = map["GRACE_PERIOD"];
    _creditLimit = map["CREDIT_LIMIT"];
    _outstandingBalance = map["OUTSTANDING_BALANCE"];
    _description = map["DESCRIPTION"];
    _debitedAmount = map["DEBITED_AMOUNT"];
    _creditedAmount = map["CREDITED_AMOUNT"];
    _inTransaction = map["IN_TRANSACTION"];
    _outTransaction = map["OUT_TRANSACTION"];
    _isDeleted = map["IS_DELETED"];
    _isSuspended = map["IS_SUSPENDED"];
    _excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
  }
}
