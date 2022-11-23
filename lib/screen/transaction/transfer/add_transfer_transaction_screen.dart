import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../model/account.dart';
import '../../../service/account_service.dart';
import '../../../service/transaction_service.dart';
import '../../../util/constants.dart';
import '../../../util/utils.dart';
import '../transaction_details_screen.dart';

class AddTransferTransactionScreen extends StatefulWidget {
  const AddTransferTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransferTransactionScreen> createState() => _AddTransferTransactionScreenState();
}

class _AddTransferTransactionScreenState extends State<AddTransferTransactionScreen> with RouteAware {
  final TransactionService _transactionService = TransactionService();
  final AccountService _accountService = AccountService();

  final _formKey = GlobalKey<FormBuilderState>();
  int? _fromAccountId;
  int? _toAccountId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.addIncomeScreenAppBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: FormBuilder(
                  key: _formKey,
                  skipDisabled: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        FormBuilderDateTimePicker(
                          name: Constants.addTransactionScreenTransactionDate,
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialValue: DateTime.now(),
                          inputType: InputType.both,
                          decoration: const InputDecoration(
                            labelText: Constants.addTransactionScreenTransactionDateLabel,
                            border: OutlineInputBorder(),
                          ),
                          initialTime: const TimeOfDay(hour: 8, minute: 0),
                          valueTransformer: (value) {
                            final DateFormat formatter = DateFormat(Constants.dateTimeFormat);
                            return formatter.format(value!);
                          },
                          // locale: const Locale.fromSubtags(languageCode: 'fr'),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          initialValue: null,
                          name: Constants.addTransactionScreenFromAccount,
                          decoration: const InputDecoration(
                            labelText: Constants.fromAccountLabel,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(errorText: Constants.selectToAccount),
                            ],
                          ),
                          readOnly: true,
                          onTap: () async {
                            await _openAccountSelectionDialog(Constants.addTransactionScreenFromAccount);
                          },
                          valueTransformer: (value) {
                            return _fromAccountId;
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          initialValue: null,
                          name: Constants.addTransactionScreenToAccount,
                          decoration: const InputDecoration(
                            labelText: Constants.toAccountLabel,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(errorText: Constants.selectFromAccount),
                            ],
                          ),
                          readOnly: true,
                          onTap: () async {
                            await _openAccountSelectionDialog(Constants.addTransactionScreenToAccount);
                          },
                          valueTransformer: (value) {
                            return _toAccountId;
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.finalAmount,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _formKey.currentState?.fields[Constants.finalAmount]?.validate();
                          },
                          decoration: const InputDecoration(
                            labelText: Constants.addTransactionScreenFinalAmountLabel,
                            border: OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(errorText: Constants.enterFinalAmount),
                              FormBuilderValidators.numeric(errorText: Constants.enterValidAmount)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.addTransactionScreenDescription,
                          decoration: const InputDecoration(
                            labelText: Constants.addTransactionScreenDetailsLabel,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              _saveIncomeTransaction();
                            },
                            child: const Text(Constants.addButton),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openAccountSelectionDialog(String whichAccount) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await _accountService.getAllAccounts(false).then((accounts) => openAccountSelectionScreen(accounts, whichAccount));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> openAccountSelectionScreen(List<Account> accounts, String whichAccount) async {
    await FilterListDelegate.show<Account>(
      context: context,
      list: accounts,
      selectedListData: [],
      theme: FilterListDelegateThemeData(
        tileMargin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          tileColor: Colors.white,
        ),
      ),
      // enableOnlySingleSelection: true,
      onItemSearch: (account, query) {
        return account.accountName!.toLowerCase().contains(query.toLowerCase());
      },
      emptySearchChild: const Center(child: Text(Constants.noCategoryFound)),
      searchFieldHint: Constants.searchHere,
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(
          () {
            if (whichAccount == Constants.addTransactionScreenToAccount) {
              _formKey.currentState!.fields[Constants.addTransactionScreenToAccount]?.didChange(list?.first.accountName);
              _toAccountId = list!.first.id!;
            } else {
              _formKey.currentState!.fields[Constants.addTransactionScreenFromAccount]?.didChange(list?.first.accountName);
              _fromAccountId = list!.first.id!;
            }
          },
        );
      },
      suggestionBuilder: (context, account, isSelected) {
        if (whichAccount == Constants.addTransactionScreenToAccount && account.id != _fromAccountId) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Card(
              elevation: 0,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.grey),
                ),
                tileColor: Utils.getColorFromColorCode(Constants.lisListTileColor),
                leading: _getAccountTypeIcon(account),
                title: Text(account.accountName, style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: Text(
                  Utils.formatNumber(account.availableBalance),
                  style: TextStyle(color: _getBalanceColor(account), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        } else if (whichAccount == Constants.addTransactionScreenFromAccount && account.id != _toAccountId) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Card(
              elevation: 0,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.grey),
                ),
                tileColor: Utils.getColorFromColorCode(Constants.lisListTileColor),
                leading: _getAccountTypeIcon(account),
                title: Text(account.accountName, style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: Text(
                  Utils.formatNumber(account.availableBalance),
                  style: TextStyle(color: _getBalanceColor(account), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  MaterialColor _getBalanceColor(Account account) {
    return account.availableBalance > 0 ? Colors.green : Colors.red;
  }

  Icon _getAccountTypeIcon(Account account) {
    return account.isCreditCard == 1
        ? const Icon(
            Icons.credit_card,
            size: 30,
          )
        : const Icon(
            Icons.account_balance,
            size: 30,
          );
  }

  void _saveIncomeTransaction() async {
    final navigator = Navigator.of(context);
    int? transactionId;
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      debugPrint(_formKey.currentState?.value.toString());
      await _transactionService.createTransaction(_formKey.currentState?.value, Constants.transferTransactionCode).then(
        (value) async {
          transactionId = value;
          await _accountService.getAccountById(_fromAccountId!).then(
            (accountList) async {
              Account account = accountList.first;
              account.availableBalance = account.availableBalance - double.parse(_formKey.currentState?.fields[Constants.finalAmount]?.value);
              account.debitedAmount = account.debitedAmount + double.parse(_formKey.currentState?.fields[Constants.finalAmount]?.value);
              account.outTransaction = account.outTransaction + 1;
              if (account.isCreditCard == 1) {
                account.outstandingBalance = account.outstandingBalance! + double.parse(_formKey.currentState?.fields[Constants.finalAmount]?.value);
              }
              await _accountService.updateAccountForOutTransaction(account.toMap(), account.isCreditCard == 1 ? true : false, account.id!).then(
                (value) async {
                  await _accountService.getAccountById(_toAccountId!).then(
                    (accountList) async {
                      Account account = accountList.first;
                      account.availableBalance = account.availableBalance + double.parse(_formKey.currentState?.fields[Constants.finalAmount]?.value);
                      account.creditedAmount = account.creditedAmount + double.parse(_formKey.currentState?.fields[Constants.finalAmount]?.value);
                      account.inTransaction = account.inTransaction + 1;
                      if (account.isCreditCard == 1) {
                        account.outstandingBalance =
                            account.outstandingBalance! - double.parse(_formKey.currentState?.fields[Constants.finalAmount]?.value);
                      }

                      await _accountService.updateAccountForInTransaction(account.toMap(), account.isCreditCard == 1 ? true : false, account.id);
                    },
                  );
                },
              );
            },
          );
        },
      );
      navigator.pop();
      navigator.push(MaterialPageRoute(builder: (context) => TransactionDetailScreen(transactionId!)));
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }
}
