class Account {
  late int id;
  late String accountName;
  late double availableBalance;
  late int isCreditCard;
  late String? billingDay;
  late String? gracePeriod;
  late double creditLimit;
  late double outstandingBalance;
  late String? description;
  late double debitedAmount;
  late double creditedAmount;
  late int inTransaction;
  late int outTransaction;
  late int isDeleted;
  late int isSuspended;
  late int excludeFromSummary;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["ACCOUNT_NAME"] = accountName;
    map["AVAILABLE_BALANCE"] = availableBalance;
    map["IS_CREDIT_CARD"] = isCreditCard;
    map["BILLING_DAY"] = billingDay;
    map["GRACE_PERIOD"] = gracePeriod;
    map["CREDIT_LIMIT"] = creditLimit;
    map["OUTSTANDING_BALANCE"] = outstandingBalance;
    map["DESCRIPTION"] = description;
    map["DEBITED_AMOUNT"] = debitedAmount;
    map["CREDITED_AMOUNT"] = creditedAmount;
    map["IN_TRANSACTION"] = inTransaction;
    map["OUT_TRANSACTION"] = outTransaction;
    map["IS_DELETED"] = isDeleted;
    map["IS_SUSPENDED"] = isSuspended;
    map["EXCLUDED_FROM_SUMMARY"] = excludeFromSummary;
    return map;
  }

  Account.fromMapObject(Map<String, dynamic> map) {
    id = map["ID"];
    accountName = map["ACCOUNT_NAME"];
    availableBalance = map["AVAILABLE_BALANCE"];
    isCreditCard = map["IS_CREDIT_CARD"];
    billingDay = map["BILLING_DAY"];
    gracePeriod = map["GRACE_PERIOD"];
    creditLimit = map["CREDIT_LIMIT"];
    outstandingBalance = map["OUTSTANDING_BALANCE"];
    description = map["DESCRIPTION"];
    debitedAmount = map["DEBITED_AMOUNT"];
    creditedAmount = map["CREDITED_AMOUNT"];
    inTransaction = map["IN_TRANSACTION"];
    outTransaction = map["OUT_TRANSACTION"];
    isDeleted = map["IS_DELETED"];
    isSuspended = map["IS_SUSPENDED"];
    excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
  }

}
