class Constants {

  static const List<String> currencyList = ["INR", "USD", "EUR", "JPY"];
  /* Color Constants */
  static const String screenBackgroundColor = "#D3D3DB";
  static const String appBarBackgroundColor = "#FFFFFF";
  static const String appBarTitleColor = "#000000";
  static const String appBarBackButtonColor = "#000000";
  static const String moreScreenSectionTitleColor = "#857E8D";
  static const String moreScreenListTileColor = "#FFFFFF";
  static const String lisListTileColor = "#FFFFFF";
  static const String listSuspendedListTileColor = "#BDBDBD";
  static const String detailCategorySubCategoryListTileColor = "#EEEEEE";

  //Theming
  static const String defaultThemeColor = "#5730E3";
  static const String defaultThemeAppBarTitleColor = "#FFFFFF";
  static const String defaultHomePageMainContainerColor = "#FFFFFF";

  static const String appName = "FinApp";

  /* Text Constsnts */

  /// More Screen
  static const String moreScreenAppBarTitle = "More";
  static const String moreScreenReminderText = "Reminder";
  static const String moreScreenReminderTimeText = "Reminder Time";
  static const String moreScreenFinanceText = "Finance";
  static const String moreScreenSettingsText = "Settings";
  static const String moreScreenAccountMenuText = "Accounts";
  static const String moreScreenCategoryMenuText = "Categories";
  static const String moreScreenCurrencyMenuText = "Currency";
  static const String moreScreenBackupText = "Backup";
  static const String moreScreenInfoMenuText = "Info";
  static const String moreScreenResetDataMenuText = "Reset Data";
  static const String moreScreenAboutText = "About";
  static const String moreScreenShareText = "Share";
  static const String moreScreenRateText = "Rate";
  static const String moreScreenFeedbackText = "Feedback";
  static const String saveButton = "Save";
  static const String addButton = "Add";
  static const String updateButton = "Update";
  static const String totalBalance = "Total Balance";
  static const String initialBalance = "0.00";

  /** Account Screen **/

  static const String noInfo = "---";
  static const String blank = "";

  static const String listAccountScreenAppBarTitle = "Accounts";
  static const String addAccountScreenAppBarTitle = "Add Account";
  static const String detailAccountScreenAppBarTitle = "Account Detail";

  static const String listCategoriesScreenAppBarTitle = "Categories";
  static const String addCategoriesScreenAppBarTitle = "Add Category";
  static const String editCategoriesScreenAppBarTitle = "Edit Category";

  /** Add Account Form Constants **/

  static const String addAccountFormAccountName = "ACCOUNT_NAME";
  static const String addAccountFormAccountNameLabel = "Account Name";
  static const String addAccountFormAccountNameRequired = "Enter account name";

  static const String addAccountFormCreditCardName = "IS_CREDIT_CARD";
  static const String addAccountFormCreditCardLabel = "Credit Card?";

  static const String addAccountFormCreditLimit = "CREDIT_LIMIT";
  static const String creditLimitLabel = "Credit Limit";
  static const String addAccountFormCreditLimitRequired = "Enter credit limit";

  static const String addAccountFormBillingDay = "BILLING_DAY";
  static const String billingDayLabel = "Billing Day";

  static const String addAccountFormGracePeriod = "GRACE_PERIOD";
  static const String gracePeriodLabel = "Grace Period";

  static const String addAccountFormAvailableBalance = "AVAILABLE_BALANCE";
  static const String availableBalanceLabel = "Available Balance";

  static const String addAccountFormDescription = "DESCRIPTION";
  static const String descriptionLabel = "Description";

  /** Add Category Form Constants **/

  static const String addCategoryFormCategoryName = "CATEGORY_NAME";
  static const String categoryNameLabel = "Category Name";
  static const String addCategoryFormCategoryNameRequired = "Enter account name";

  static const String addCategoryFormDescription = "DESCRIPTION";

  static const String addCategoryFormCategoryType = "CATEGORY_TYPE";
  static const String addCategoryFormCategoryTypeNameLabel = "Category Type";

  static const String addCategoryFormParentCategory = "PARENT_CATEGORY";
  static const String addCategoryFormParentCategoryNameLabel = "Parent Category";

  static const String detailCategoryScreenAppBarTitle = "Category Detail";

  static const String noOptionFound = "No item found";
  static const String searchHere = "Search here...";
  static const String enterValidNumber = "Enter valid number";

  static const String inTransaction = "In Transaction";
  static const String outTransaction = "Out Transaction";
  static const String creditedAmount = "Credited Amount";
  static const String debitedAmount = "Debited Amount";
  static const String outStandingBalance = "Outstanding Balance";

  static const String suspend = "Suspend";
  static const String resume = "Resume";
  static const String delete = "Delete";
  static const String confirm = "Confirm";
  static const String areYouSureToDelete = "Are you sure to delete?";
  static const String areYouSureToSuspend = "Are you sure to suspend?";
  static const String areYouSureToResumeAgain = "Are you sure to resume again?";
  static const String yes = "Yes";
  static const String no = "No";
  static const accountCanNotBeDeletedAsTransactionExists =
      "Account can not be deleted as transaction exists with this account. However, you can disable it.";
  static const categoryCanNotBeDeletedAsHavingChildCategory = "Category can not be deleted as it is having child category";

  static const String noAccountFound = "No Account Details Found";
  static const String noCategoryFound = "No category found";
  static const String noSubCategoryDetailFound = "No Sub Category Details Found";

  static const billingDaysOption = [
    "1st of Every Month",
    "2nd of Every Month",
    "3rd of Every Month",
    "4th of Every Month",
    "5th of Every Month",
    "6th of Every Month",
    "7th of Every Month",
    "8th of Every Month",
    "9th of Every Month",
    "10th of Every Month",
    "11th of Every Month",
    "12th of Every Month",
    "13th of Every Month",
    "14th of Every Month",
    "15th of Every Month",
    "16th of Every Month",
    "17th of Every Month",
    "18th of Every Month",
    "19th of Every Month",
    "20th of Every Month",
    "21st of Every Month",
    "22nd of Every Month",
    "23rd of Every Month",
    "24th of Every Month",
    "25th of Every Month",
    "26th of Every Month",
    "27th of Every Month",
    "28th of Every Month",
    "29th of Every Month",
    "30th of Every Month",
    "31st of Every Month"
  ];

  static const gracePeriodOption = [
    "1 day",
    "2 days",
    "3 days",
    "4 days",
    "5 days",
    "6 days",
    "7 days",
    "8 days",
    "9 days",
    "10 days",
    "11 days",
    "12 days",
    "13 days",
    "14 days",
    "15 days",
    "16 days",
    "17 days",
    "18 days",
    "19 days",
    "20 days",
    "21 days",
    "22 days",
    "23 days",
    "24 days",
    "25 days",
    "26 days",
    "27 days",
    "28 days",
    "29 days",
    "30 days"
  ];

  static const Map<String, String> categoryType = {"Income Category": "I", "Expense Category": "E"};

  static const String accountNameAlreadyExists = "Account with same name already exists";
  static const String categoryWithSameNameAlreadyExists = "Category with same name already exists";
  static const String selectBillingDay = "Select billing day";
  static const String selectCategoryType = "Select Category Type";
  static const String incomeCategory = "Income Category";
  static const String expenseCategory = "Expense Category";
  static const String otherCategory = "Other Category";
  static const String incomeCategoryCode = "I";
  static const String expenseCategoryCode = "E";
  static const String otherCategoryCode = "O";
  static const String transferTransactionCode = "T";

  static const String addIncomeScreenAppBarTitle = "Add Income Transaction";
  static const String addExpenseScreenAppBarTitle = "Add Expense Transaction";
  static const String addTransactionScreenTransactionDate = "TRANSACTION_DATE";
  static const String addTransactionScreenTransactionDateLabel = "Date & Time";
  static const String dateTimeFormat = "dd-MM-yyyy HH:mm";

  static const String addTransactionScreenToAccount = "TO_ACCOUNT";
  static const String toAccountLabel = "To Account";
  static const String selectAccount = "Select account";
  static const String selectToAccount = "Select To account";
  static const String selectFromAccount = "Select From account";

  static const String addTransactionScreenCategory = "CATEGORY";
  static const String addTransactionScreenCategoryLabel = "Category";
  static const String selectCategory = "Select category";

  static const String addTransactionScreenFromAccount = "FROM_ACCOUNT";
  static const String fromAccountLabel = "From Account";

  static const String finalAmount = "FINAL_AMOUNT";
  static const String addTransactionScreenFinalAmountLabel = "Amount";
  static const String enterFinalAmount = "Enter final amount";
  static const String enterValidAmount = "Enter valid amount";

  static const String addTransactionScreenDescription = "DESCRIPTION";
  static const String addTransactionScreenDetailsLabel = "Details";

  static const String listTransactionScreenAppBarTitle = "Transactions";
  static const String detailTransactionScreenAppBarTitle = "Transactions Detail";

  static const String income = "Income";
  static const String expense = "Expense";
  static const String transfer = "Transfer";
  static const String budget = "Budget";
  static const String incomeCode = "I";
  static const String expenseCode = "E";
  static const String transferCode = "T";
  static const String transactionDate = "Transaction Date";
  static const String transactionTime = "Time";
  static const String transactionAmount = "Amount";
  static const String transactionType = "TRANSACTION_TYPE";

  static const String from = "From: ";
  static const String to = "To: ";
  static const String latestTransaction = "Latest Transactions";
  static const String addBudget = "Add Budget";
  static const String budgetFor = "Budget for month ";
  static const String budgetAmount = "BUDGET_AMOUNT";
  static const String enterBudgetAmount = "Enter budget amount";
  static const String forYear = "FOR_YEAR";
  static const String setBudgetForCompleteYear = "Set Budget for complete year";
  static const String cancel = "Cancel";
  static const String done = "Done";
  static const String noTransactionFoundToSetBudget = "No Transaction found to calculate budget";
  static const String domain = "domain";
  static const String measure = "measure";
  static const String spent = "Spent";
  static const String remain = "Remain";
  static const String exceed = "Exceed";
  static const String transactions = "Transactions";
  static const String highestSpend = "Highest Spend";
  static const String lowestSpend = "Lowest Spend";
  static const String reminderTime = "8:00 PM";
  static const String currency = "INR";
  static const String currencyCode = "₹";
  static const String subCategory = "Sub Categories";
}
