class Category {
  late int _id;
  late String _categoryName;
  late String _categoryType;
  late String? _description;
  late int _parentCategory;
  late double _debitedAmount;
  late double _creditedAmount;
  late int _inTransaction;
  late int _outTransaction;
  late int _isDeleted;
  late int _isSuspended;
  late int _excludeFromSummary;
  late int _childCount;
  late String? _parentCategoryName;

  int? get id => _id;
  String get categoryName => _categoryName;
  String get categoryType => _categoryType;
  String? get description => _description;
  int get inTransaction => _inTransaction;
  int get outTransaction => _outTransaction;
  double get creditedAmount => _creditedAmount;
  double get debitedAmount => _debitedAmount;
  int get parentCategory => _parentCategory;
  int get childCount => _childCount;
  String? get parentCategoryName => _parentCategoryName;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["CATEGORY_NAME"] = _categoryName;
    map["CATEGORY_TYPE"] = _categoryType;
    map["DESCRIPTION"] = _description;
    map["PARENT_CATEGORY"] = _parentCategory;
    map["DEBITED_AMOUNT"] = _debitedAmount;
    map["CREDITED_AMOUNT"] = _creditedAmount;
    map["IN_TRANSACTION"] = _inTransaction;
    map["OUT_TRANSACTION"] = _outTransaction;
    map["IS_DELETED"] = _isDeleted;
    map["IS_SUSPENDED"] = _isSuspended;
    map["EXCLUDED_FROM_SUMMARY"] = _excludeFromSummary;
    return map;
  }

  Category.fromMapObject(Map<String, dynamic> map) {
    _id = map["ID"];
    _categoryName = map["CATEGORY_NAME"];
    _categoryType = map["CATEGORY_TYPE"];
    _parentCategory = map["PARENT_CATEGORY"];
    _description = map["DESCRIPTION"];
    _debitedAmount = map["DEBITED_AMOUNT"];
    _creditedAmount = map["CREDITED_AMOUNT"];
    _inTransaction = map["IN_TRANSACTION"];
    _outTransaction = map["OUT_TRANSACTION"];
    _isDeleted = map["IS_DELETED"];
    _isSuspended = map["IS_SUSPENDED"];
    _excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
    _childCount = map.containsKey("CHILD_COUNT") ? map["CHILD_COUNT"] : 0;
    _parentCategoryName = map.containsKey("PARENT_CATEGORY_NAME") ? map["PARENT_CATEGORY_NAME"] : "";
  }
}