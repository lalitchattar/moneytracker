class Category {
  late int id;
  late String categoryName;
  late String categoryType;
  late String? description;
  late int parentCategory;
  late int iconId;
  late int editable;
  late double debitedAmount;
  late double creditedAmount;
  late int inTransaction;
  late int outTransaction;
  late int isDeleted;
  late int isSuspended;
  late int excludeFromSummary;
  late int childCount;
  late String? parentCategoryName;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["CATEGORY_NAME"] = categoryName;
    map["CATEGORY_TYPE"] = categoryType;
    map["DESCRIPTION"] = description;
    map["PARENT_CATEGORY"] = parentCategory;
    map["DEBITED_AMOUNT"] = debitedAmount;
    map["CREDITED_AMOUNT"] = creditedAmount;
    map["IN_TRANSACTION"] = inTransaction;
    map["OUT_TRANSACTION"] = outTransaction;
    map["IS_DELETED"] = isDeleted;
    map["IS_SUSPENDED"] = isSuspended;
    map["EXCLUDED_FROM_SUMMARY"] = excludeFromSummary;
    return map;
  }

  Category.fromMapObject(Map<String, dynamic> map) {
    id = map["ID"];
    categoryName = map["CATEGORY_NAME"];
    categoryType = map["CATEGORY_TYPE"];
    parentCategory = map["PARENT_CATEGORY"];
    iconId = map["ICON_ID"];
    editable = map["EDITABLE"];
    description = map["DESCRIPTION"];
    debitedAmount = map["DEBITED_AMOUNT"];
    creditedAmount = map["CREDITED_AMOUNT"];
    inTransaction = map["IN_TRANSACTION"];
    outTransaction = map["OUT_TRANSACTION"];
    isDeleted = map["IS_DELETED"];
    isSuspended = map["IS_SUSPENDED"];
    excludeFromSummary = map["EXCLUDED_FROM_SUMMARY"];
    childCount = map.containsKey("CHILD_COUNT") ? map["CHILD_COUNT"] : 0;
    parentCategoryName = map.containsKey("PARENT_CATEGORY_NAME") ? map["PARENT_CATEGORY_NAME"] : "";
  }
}