import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/model/category.dart';
import 'package:moneytracker/service/account_service.dart';

import '../../../main.dart';
import '../../../model/account.dart';
import '../../../service/category_service.dart';
import '../../../service/transaction_service.dart';

class AddExpenseTransaction extends StatefulWidget {
  const AddExpenseTransaction({Key? key}) : super(key: key);

  @override
  State<AddExpenseTransaction> createState() => _AddExpenseTransactionState();
}

class _AddExpenseTransactionState extends State<AddExpenseTransaction> with RouteAware {

  final _formKey = GlobalKey<FormBuilderState>();
  final CategoryService _categoryService = CategoryService();
  final AccountService _accountService = AccountService();
  final TransactionService _transactionService = TransactionService();
  List<Account>? selectedAccountList = [];
  List<Category>? selectedCategoryList = [];
  late int? _accountId;
  late int? _categoryId;

  Future<void> openFilterDelegateForAccount(BuildContext context, List<Account> accounts) async {
    await FilterListDelegate.show<Account>(
        context: context,
        list: accounts,
        enableOnlySingleSelection: true,
        onItemSearch: (account, query) {
          return account.accountName.toLowerCase().contains(query.toLowerCase());
        },
        onApplyButtonClick: (list) {
          selectedAccountList = list;
          _accountId = selectedAccountList?.first.id;
          setState(() {
            _formKey.currentState!.fields['FROM_ACCOUNT']
                ?.didChange(selectedAccountList?.first.accountName);
            _formKey.currentState?.fields['FROM_ACCOUNT']?.validate();
          });
        },
        suggestionBuilder: (context, account, isSelected) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Text(account.accountName),
              trailing: Text(account.availableBalance.toString()),
            ),
          );
        }
    );
  }

  Future<void> openFilterDelegateForCategory(BuildContext context, List<Category> categories) async {
    await FilterListDelegate.show<Category>(
        context: context,
        list: categories,
        enableOnlySingleSelection: true,
        onItemSearch: (category, query) {
          return category.categoryName.toLowerCase().contains(query.toLowerCase());
        },
        onApplyButtonClick: (list) {
          selectedCategoryList = list;
          _categoryId = selectedCategoryList?.first.id;
          setState(() {
            _formKey.currentState!.fields['CATEGORY']
                ?.didChange(selectedCategoryList?.first.categoryName);
            _formKey.currentState?.fields['CATEGORY']?.validate();
          });
        },
        suggestionBuilder: (context, category, isSelected) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Text(category.categoryName),
              trailing: Text(category.childCount == 0 ? "" : category.childCount.toString()),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Add Expense Transaction"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            skipDisabled: true,
            child: Column(
              children: [
                FormBuilderDateTimePicker(
                  name: 'TRANSACTION_DATE',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialValue: DateTime.now(),
                  inputType: InputType.both,
                  decoration: const InputDecoration(
                    labelText: 'Date & Time',
                    border: OutlineInputBorder(),
                  ),
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                  valueTransformer: (value) {
                    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
                    return formatter.format(value!);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  initialValue: null,
                  name: "FROM_ACCOUNT",
                  decoration: const InputDecoration(
                    labelText: "From Account",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Select account"),
                    ],
                  ),
                  readOnly: true,
                  onTap: () async{
                    await _accountService.getAllAccounts().then((accounts) => openFilterDelegateForAccount(context, accounts));
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  valueTransformer: (value){
                    return _accountId;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                    initialValue: null,
                    name: "CATEGORY",
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    readOnly: true,
                    onTap: () async{
                      await _categoryService.getCategoriesByType("E").then((categories) => openFilterDelegateForCategory(context, categories));
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                            errorText: "Select category"),
                      ],
                    ),
                  valueTransformer: (value) {
                      return _categoryId;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  name: "FINAL_AMOUNT",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _formKey.currentState?.fields["FINAL_AMOUNT"]?.validate();
                  },
                  decoration: const InputDecoration(
                    labelText: "Final Amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Enter final amount"),
                      FormBuilderValidators.numeric(
                          errorText: "Enter valid amount")
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  name: "DESCRIPTION",
                  decoration: const InputDecoration(
                    labelText: "Details",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        spacing: 5.0,
        icon: Icons.check,
        onPress: () async{
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            await _transactionService.createTransaction(_formKey.currentState?.value, "E").then((value) async{
              await _accountService.getAccountById(_accountId!).then((accountList) async{
                Account account = accountList.first;
                account.availableBalance = account.availableBalance - double.parse(_formKey.currentState?.fields["FINAL_AMOUNT"]?.value);
                account.debitedAmount = account.debitedAmount + double.parse(_formKey.currentState?.fields["FINAL_AMOUNT"]?.value);
                account.outTransaction = account.outTransaction + 1;
                account.outstandingBalance = account.outstandingBalance! + double.parse(_formKey.currentState?.fields["FINAL_AMOUNT"]?.value);
                await _accountService.updateAccountForOutTransaction(account.toMap(), account.isCreditCard == 1 ? true : false, account.id!);
              });
            });
          }
        },
      ),
    );
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
