import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/model/category.dart';
import 'package:moneytracker/screen/transaction/transaction_details.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:moneytracker/service/transaction_service.dart';
import 'package:moneytracker/util/utils.dart';

import '../../../main.dart';
import '../../../model/account.dart';
import '../../../service/category_service.dart';

class AddIncomeTransaction extends StatefulWidget {
  const AddIncomeTransaction({Key? key}) : super(key: key);

  @override
  State<AddIncomeTransaction> createState() => _AddIncomeTransactionState();
}

class _AddIncomeTransactionState extends State<AddIncomeTransaction> with RouteAware{
  final _formKey = GlobalKey<FormBuilderState>();
  final CategoryService _categoryService = CategoryService();
  final TransactionService _transactionService = TransactionService();
  final AccountService _accountService = AccountService();
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
          _formKey.currentState!.fields['TO_ACCOUNT']
              ?.didChange(selectedAccountList?.first.accountName);
          _formKey.currentState?.fields['TO_ACCOUNT']?.validate();
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
            leading: CircleAvatar(
              child: Icon(
                  (account.isCreditCard == 1)
                      ? Icons.credit_card
                      : Icons.account_balance),
            ),
            title: Text(account.accountName, style: const TextStyle(fontWeight: FontWeight.w500),),
            trailing: Chip(backgroundColor: account.availableBalance! > 0 ? Colors.green: Colors.red, label: Text(Utils.formatNumber(account.availableBalance).toString())),
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
              leading: CircleAvatar(
                child: Text(category.categoryName.substring(0, 1).toUpperCase()),
              ),
              title: Text(category.categoryName, style: const TextStyle(fontWeight: FontWeight.w500),),
              trailing: Text(category.childCount == 0 ? "" : category.childCount.toString()),
            ),
          );
        }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Add Income Transaction"),
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
                  // locale: const Locale.fromSubtags(languageCode: 'fr'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  initialValue: null,
                  name: "TO_ACCOUNT",
                  decoration: const InputDecoration(
                    labelText: "To Account",
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
                    await _accountService.getAllAccounts(false).then((accounts) => openFilterDelegateForAccount(context, accounts));
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  valueTransformer: (value) {
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
                    await _categoryService.getCategoriesByType("I").then((categories) => openFilterDelegateForCategory(context, categories));
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
          int? transactionId;
          final navigator = Navigator.of(context); //
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            await _transactionService.createTransaction(_formKey.currentState?.value, "I").then((value) async{
              transactionId = value;
              await _accountService.getAccountById(_accountId!).then((accountList) async {
                  Account account = accountList.first;
                  account.availableBalance = account.availableBalance + double.parse(_formKey.currentState?.fields["FINAL_AMOUNT"]?.value);
                  account.creditedAmount = account.creditedAmount + double.parse(_formKey.currentState?.fields["FINAL_AMOUNT"]?.value);
                  account.inTransaction = account.inTransaction + 1;
                  await _accountService.updateAccountForInTransaction(account.toMap(), account.isCreditCard == 1 ? true : false, account.id!).then((value) async{
                    await _categoryService.getCategoryById(_categoryId!).then((categoryList) async {
                      Category category = categoryList.first;
                      category.creditedAmount = category.creditedAmount + double.parse(_formKey.currentState?.fields["FINAL_AMOUNT"]?.value);
                      category.inTransaction = category.inTransaction + 1;
                      await _categoryService.updateCategoryForInTransaction(category.toMap(), category.id!);
                    });
                  });
              });

            });
          }
          navigator.pop();
          navigator.push(MaterialPageRoute(builder: (context) => TransactionDetails(transactionId!)));
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }
}
