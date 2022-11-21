class BudgetModel {
  late int id;
  late double budgetAmount;
  late int forYear;
  late int alertEnabled;
  late int totalTransaction;
  late double expense;
  late double avgExpense;
  late double highestAmount;
  late double lowestAmount;
  late int isDeleted;

  BudgetModel.fromMapObject(Map<String, dynamic> map) {
    id = map["ID"];
    budgetAmount = map["BUDGET_AMOUNT"];
    forYear = map["FOR_YEAR"];
    alertEnabled = map["ALERT_ENABLED"];
    isDeleted = map["IS_DELETED"];
  }

  BudgetModel.fromMapObjectForCHart(Map<String, dynamic> map) {
    totalTransaction = map["TOTAL_TRANSACTION"];
    budgetAmount = map["BUDGET_AMOUNT"];
    expense = map["EXPENSE"];
    highestAmount = map["HIGHEST"];
    lowestAmount = map["LOWEST"];
  }

}