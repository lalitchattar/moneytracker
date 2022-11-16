class Constants {

  /* Color Constants */
  static const String screenBackgroundColor = "#D3D3DB";
  static const String appBarBackgroundColor = "#FFFFFF";
  static const String appBarTitleColor = "#000000";
  static const String appBarBackButtonColor = "#000000";
  static const String moreScreenSectionTitleColor = "#857E8D";
  static const String moreScreenListTileColor = "#FFFFFF";
  static const String lisAccountListTileColor = "#FFFFFF";
  static const String lisAccountSuspendedListTileColor = "#BDBDBD";

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

  /** Account Screen **/

  static const String noInfo = "---";

  static const String listAccountScreenAppBarTitle = "Accounts";
  static const String addAccountScreenAppBarTitle = "Add Account";
  static const String detailAccountScreenAppBarTitle = "Account Detail";


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
  static const String availableBalanceLabel = "Available balance";

  static const String addAccountFormDescription = "DESCRIPTION";
  static const String descriptionLabel = "Description";

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
  static const accountCanNotBeDeletedAsTransactionExists = "Account can not be deleted as transaction exists with this account. However, you can disable it.";

  static const String noAccountFound = "No Account Details Found";

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

  static const String accountNameAlreadyExists = "Account with same name already exists";
  static const String selectBillingDay = "Select billing day";


}